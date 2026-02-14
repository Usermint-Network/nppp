import os
from functools import lru_cache
from typing import Any, Dict

import google.auth
import google.auth.transport.requests
from google.auth.transport.requests import AuthorizedSession
from google.oauth2 import id_token


@lru_cache(maxsize=1)
def _userman_url() -> str:
    url = os.environ.get("USERMAN_URL", "").rstrip("/")
    if not url:
        raise RuntimeError("USERMAN_URL env var not set")
    return url


@lru_cache(maxsize=1)
def _session() -> AuthorizedSession:
    # Uses orchestration-api Cloud Run identity (Workload Identity)
    credentials, _ = google.auth.default()
    req = google.auth.transport.requests.Request()

    # Convert to ID-token creds for the userman audience (service URL)
    target_creds = id_token.IDTokenCredentials.from_credentials(
        credentials,
        target_audience=_userman_url(),
        request=req,
    )
    return AuthorizedSession(target_creds)


def call_userman(path: str, timeout: int = 10) -> Dict[str, Any]:
    url = f"{_userman_url()}{path}"
    resp = _session().get(url, timeout=timeout)
    resp.raise_for_status()
    return resp.json()
