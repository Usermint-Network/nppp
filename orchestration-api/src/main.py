# orchestration-api/src/main.py
#
# Canonical Move (Gradient One)
# - Deterministic canonical JSON + SHA256 proof IDs
# - Append-only (create-only) storage in GCS (no silent side effects)
# - OIDC verification supporting BOTH:
#     (a) IAP-protected entry (aud = IAP_CLIENT_ID, email claim present)
#     (b) Cloud Run service-to-service calls (aud = INTERNAL_AUDIENCE, email optional)
# - Safe-halt defaults: if uncertain, stop; idempotent writes; explicit errors
#
# REQUIRED ENV:
#   NOTARY_BUCKET                (e.g. usermint-network-notary-dev)
#   IAP_AUDIENCE                 (IAP OAuth Client ID)   [optional but recommended]
#   INTERNAL_AUDIENCE            (Cloud Run URL or canonical service audience) [optional but recommended]
#
# OPTIONAL ENV:
#   LOG_LEVEL                    (INFO default)
#   REQUIRE_EMAIL_FOR_NOTARIZE    ("true"/"false", default false)
#   GIT_SHA, BUILD_ID             (for /versionz)

import os
import json
import time
import base64
import hashlib
import logging
from datetime import datetime, timezone
from typing import Any, Dict, Optional, List, Tuple

from fastapi import FastAPI, Header, HTTPException, Request
from pydantic import BaseModel, Field

from google.auth.transport import requests as google_requests
from google.oauth2 import id_token

try:
    from google.cloud import storage  # type: ignore
except Exception:  # pragma: no cover
    storage = None  # type: ignore


# ------------------------------------------------------------
# App / Logging
# ------------------------------------------------------------
log = logging.getLogger("orchestration-api")
logging.basicConfig(level=os.getenv("LOG_LEVEL", "INFO"))
app = FastAPI(title="usermint-orchestration-api (Canonical Move / Gradient One)")


# ------------------------------------------------------------
# Utilities / Config
# ------------------------------------------------------------
def require_env(name: str) -> str:
    v = (os.getenv(name) or "").strip()
    if not v:
        raise RuntimeError(f"{name} is required")
    return v


def env_bool(name: str, default: bool = False) -> bool:
    v = (os.getenv(name) or "").strip().lower()
    if not v:
        return default
    return v in ("1", "true", "yes", "y", "on")


def rfc3339_now() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def notary_bucket_name() -> str:
    return require_env("NOTARY_BUCKET")


def expected_audiences() -> List[str]:
    """
    Canonical: we accept a set of allowed audiences so the SAME service can be accessed via:
      - IAP (aud = IAP OAuth Client ID)
      - Cloud Run OIDC service-to-service (aud = INTERNAL_AUDIENCE)
    """
    auds: List[str] = []
    for k in ("IAP_AUDIENCE", "INTERNAL_AUDIENCE"):
        v = (os.getenv(k) or "").strip()
        if v:
            auds.append(v.rstrip("/"))
    if not auds:
        raise RuntimeError("At least one of IAP_AUDIENCE or INTERNAL_AUDIENCE must be set")
    return auds


def canonical_json(obj: Any) -> bytes:
    """
    Canonical JSON: UTF-8, sorted keys, no whitespace.
    This is the deterministic basis of source -> proof -> hash.
    """
    return json.dumps(obj, sort_keys=True, separators=(",", ":"), ensure_ascii=False).encode("utf-8")


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def compute_request_id(request: Request) -> str:
    # Prefer upstream request id if present
    rid = request.headers.get("X-Request-Id") or request.headers.get("X-Cloud-Trace-Context")
    if rid:
        return rid.split("/")[0][:64]
    # Fallback: stable-ish deterministic id
    return sha256_hex(canonical_json({"t": time.time_ns(), "p": str(request.url.path)}))[:24]


# ------------------------------------------------------------
# AuthN/AuthZ (Google OIDC)
# ------------------------------------------------------------
_google_req = google_requests.Request()


class CallerIdentity(BaseModel):
    issuer: str
    subject: str
    email: Optional[str] = None
    audience: str
    raw_claims: Dict[str, Any] = Field(default_factory=dict)


def _verify_token_any_audience(token: str, auds: List[str]) -> Tuple[Dict[str, Any], str]:
    """
    Try to verify token against any allowed audience.
    Returns (claims, matched_audience).
    """
    last_err: Optional[Exception] = None
    for aud in auds:
        try:
            claims = id_token.verify_oauth2_token(token, _google_req, aud)
            return claims, aud
        except Exception as e:
            last_err = e
    raise HTTPException(status_code=401, detail=f"invalid token: {type(last_err).__name__}")


def verify_bearer_oidc(authorization: Optional[str], require_email: bool = False) -> CallerIdentity:
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="missing bearer token")

    token = authorization.split(" ", 1)[1].strip()
    auds = expected_audiences()

    claims, _matched = _verify_token_any_audience(token, auds)

    iss = str(claims.get("iss", "") or "")
    sub = str(claims.get("sub", "") or "")
    email = claims.get("email")
    aud_claim = claims.get("aud")

    if not iss or not sub:
        raise HTTPException(status_code=401, detail="token missing iss/sub")

    # aud can be string or list depending on token type
    if isinstance(aud_claim, str):
        aud_str = aud_claim
    elif isinstance(aud_claim, list) and aud_claim:
        aud_str = str(aud_claim[0])
    else:
        aud_str = ""

    email_str = email if isinstance(email, str) else None
    if require_email and not email_str:
        raise HTTPException(status_code=401, detail="token missing required email claim")

    return CallerIdentity(
        issuer=iss,
        subject=sub,
        email=email_str,
        audience=aud_str,
        raw_claims=claims,
    )


# ------------------------------------------------------------
# Storage: Append-only proofs in GCS
# ------------------------------------------------------------
def require_storage_client() -> "storage.Client":
    if storage is None:
        raise RuntimeError("google-cloud-storage not installed; add it to requirements.txt")
    return storage.Client()


def gcs_put_if_absent(object_name: str, content: bytes, content_type: str = "application/json") -> None:
    """
    Create-only write:
      - if_generation_match=0 enforces "object must not already exist"
    This is an MVP append-only invariant.
    """
    client = require_storage_client()
    bucket = client.bucket(notary_bucket_name())
    blob = bucket.blob(object_name)
    blob.upload_from_string(
        content,
        content_type=content_type,
        if_generation_match=0,  # create-only
    )


def gcs_get(object_name: str) -> bytes:
    client = require_storage_client()
    bucket = client.bucket(notary_bucket_name())
    blob = bucket.blob(object_name)
    return blob.download_as_bytes()


def gcs_list(prefix: str, limit: int = 2000) -> List[str]:
    client = require_storage_client()
    bucket = client.bucket(notary_bucket_name())
    out: List[str] = []
    for b in bucket.list_blobs(prefix=prefix, max_results=limit):
        out.append(b.name)
    return out


def is_precondition_failed(exc: Exception) -> bool:
    # We avoid importing google.api_core for maximum drop-in simplicity.
    msg = str(exc)
    return ("412" in msg) or ("Precondition" in msg) or ("conditionNotMet" in msg)


# ------------------------------------------------------------
# Platform probes / SLA evidence endpoints
# ------------------------------------------------------------
@app.get("/", include_in_schema=False)
def root() -> Dict[str, str]:
    return {"message": "UserMint Orchestration API — Canonical Move (Gradient One)"}


@app.get("/livez", include_in_schema=False)
def livez() -> Dict[str, str]:
    return {"status": "ok"}


@app.get("/readyz", include_in_schema=False)
def readyz() -> Dict[str, Any]:
    # Safe-halt: if required config is missing, fail readiness.
    bucket = notary_bucket_name()
    auds = expected_audiences()
    # Also ensure storage lib is importable
    if storage is None:
        raise HTTPException(status_code=500, detail="google-cloud-storage not installed")
    return {
        "ok": True,
        "notary_bucket": bucket,
        "expected_audiences": auds,
        "require_email_for_notarize": env_bool("REQUIRE_EMAIL_FOR_NOTARIZE", False),
    }


@app.get("/versionz", include_in_schema=False)
def versionz() -> Dict[str, str]:
    return {
        "service": "orchestration-api",
        "git_sha": os.getenv("GIT_SHA", "unknown"),
        "build_id": os.getenv("BUILD_ID", "unknown"),
    }


# ------------------------------------------------------------
# Gradient One API: Notarization (Internal proofs / governance attestations)
# ------------------------------------------------------------
class NotarizeRequest(BaseModel):
    """
    "source" is the client-submitted payload.
    We deterministically canonicalize it and bind it into a proof envelope.
    """
    source: Dict[str, Any] = Field(..., description="Arbitrary client source payload to be notarized")
    source_schema: Optional[str] = Field(None, description="Optional schema/version label for auditing")
    external_ref: Optional[str] = Field(None, description="Optional external reference (invoice id, doc id, etc.)")


class NotarizeResponse(BaseModel):
    proof_id: str
    proof_sha256: str
    object_name: str
    created_at: str


def build_proof_payload(req: NotarizeRequest, identity: CallerIdentity, request_id: str) -> Dict[str, Any]:
    created_at = rfc3339_now()
    created_ns = time.time_ns()

    # 1) Canonicalize source (deterministic)
    source_canon = canonical_json(req.source)
    source_sha = sha256_hex(source_canon)

    # 2) Proof envelope (identity + deterministic linkage)
    proof = {
        "type": "usermint.notary.v1",
        "created_at": created_at,
        "created_time_ns": created_ns,
        "request_id": request_id,
        "identity": {
            "issuer": identity.issuer,
            "subject": identity.subject,
            "email": identity.email,     # may be null for internal calls
            "audience": identity.audience,
        },
        "source": {
            "schema": req.source_schema,
            "external_ref": req.external_ref,
            "sha256": source_sha,
            "canonical_b64": base64.b64encode(source_canon).decode("ascii"),
        },
    }

    # 3) Canonicalize proof + hash (immutable proof id)
    proof_canon = canonical_json(proof)
    proof_sha = sha256_hex(proof_canon)

    # 4) Append-only object name (date prefix aids audit)
    date_prefix = created_at[:10]  # YYYY-MM-DD
    object_name = f"proofs/v1/{date_prefix}/{proof_sha}.json"

    return {
        "proof": proof,
        "proof_canon": proof_canon,
        "proof_sha": proof_sha,
        "object_name": object_name,
        "created_at": created_at,
    }


@app.post("/v1/notary/notarize", response_model=NotarizeResponse)
async def notarize(
    req: NotarizeRequest,
    request: Request,
    authorization: Optional[str] = Header(default=None, alias="Authorization"),
) -> NotarizeResponse:
    # Policy switch: optionally require email (useful for IAP human operator calls)
    require_email = env_bool("REQUIRE_EMAIL_FOR_NOTARIZE", False)
    identity = verify_bearer_oidc(authorization, require_email=require_email)

    rid = compute_request_id(request)
    built = build_proof_payload(req, identity, rid)

    # Append-only write; treat duplicates as idempotent success (replay safety)
    try:
        gcs_put_if_absent(built["object_name"], built["proof_canon"], content_type="application/json")
    except Exception as e:
        if not is_precondition_failed(e):
            log.exception("storage_error")
            raise HTTPException(status_code=500, detail=f"storage_error: {type(e).__name__}")

    return NotarizeResponse(
        proof_id=built["proof_sha"],
        proof_sha256=built["proof_sha"],
        object_name=built["object_name"],
        created_at=built["created_at"],
    )


@app.get("/v1/notary/proofs/by-object", include_in_schema=True)
def get_proof_by_object(
    name: str,
    authorization: Optional[str] = Header(default=None, alias="Authorization"),
) -> Dict[str, Any]:
    _ = verify_bearer_oidc(authorization)  # restrict access for MVP
    try:
        b = gcs_get(name)
        return json.loads(b.decode("utf-8"))
    except Exception as e:
        raise HTTPException(status_code=404, detail=f"not_found: {type(e).__name__}")


@app.get("/v1/notary/audit/export", include_in_schema=True)
def audit_export_ndjson(
    date: str,
    authorization: Optional[str] = Header(default=None, alias="Authorization"),
) -> str:
    """
    NDJSON export of proofs for a specific day.
    date: YYYY-MM-DD
    Safe-halt principles:
      - validate input
      - export attempts completeness; one bad object doesn't halt the whole export
    """
    _ = verify_bearer_oidc(authorization)

    if len(date) != 10 or date[4] != "-" or date[7] != "-":
        raise HTTPException(status_code=400, detail="date must be YYYY-MM-DD")

    prefix = f"proofs/v1/{date}/"
    try:
        names = gcs_list(prefix=prefix, limit=2000)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"list_error: {type(e).__name__}")

    lines: List[str] = []
    for name in names:
        try:
            proof = json.loads(gcs_get(name).decode("utf-8"))
            lines.append(json.dumps({"object": name, "proof": proof}, separators=(",", ":"), ensure_ascii=False))
        except Exception:
            # completeness > perfection; record the failure explicitly
            lines.append(json.dumps({"object": name, "error": "unreadable"}, separators=(",", ":")))

    return "\n".join(lines) + ("\n" if lines else "")
