# NPPP API

HTTP Interface for the Notarization Proof Packet Protocol

---

## Overview

The NPPP API provides programmatic access to the Notarization Proof Packet Protocol.

It allows systems to:

- submit artifacts for notarization
- receive NPPP proof strings
- retrieve proof metadata
- perform replay verification workflows

The API is intended for:

- developer tools
- CI/CD pipelines
- infrastructure automation
- AI provenance systems
- compliance systems

---

## Base URL

```text
https://api.usermint.network
```

## Authentication

Notarization requests require an API key issued by the UserMint Network.

Authentication is provided using a bearer token.

Example header:

```http
Authorization: Bearer <API_KEY>
```

Verification of an existing proof may be supported independently of authenticated notarization operations.

## Core Endpoints

The NPPP API exposes three primary endpoints:

- `POST /v1/notarize`
- `POST /v1/verify`
- `GET /v1/proof/{id}`

### POST /v1/notarize

Creates a notarization proof for a submitted artifact.

**Request**

```http
POST /v1/notarize
Authorization: Bearer <API_KEY>
Content-Type: application/json
```

Example request body:

```json
{
  "service": "nppp-notary",
  "artifact_type": "dataset",
  "freshness": "7d",
  "evidence": {
    "path": "dataset.csv"
  }
}
```

**Response**

Example response:

```json
{
  "proof_id": "nppp_000001",
  "proof": "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z",
  "bundle": "gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz",
  "bundle_sha256": "8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6"
}
```

**Behavior**

This endpoint performs the following operations:

1.  canonicalizes the submitted artifact
2.  generates a deterministic evidence bundle
3.  computes the SHA-256 hash
4.  constructs the NPPP proof string
5.  records a proof ledger entry

### POST /v1/verify

Verifies a proof by replaying the cryptographic integrity check.

**Request**

```http
POST /v1/verify
Content-Type: application/json
```

Example request body:

```json
{
  "proof": "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z"
}
```

**Response**

Example response:

```json
{
  "verified": true,
  "expected_sha256": "8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6",
  "computed_sha256": "8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6",
  "status": "SHA Replay Verified: OK"
}
```

**Behavior**

This endpoint:

1.  parses the proof string
2.  retrieves the evidence bundle
3.  computes the SHA-256 hash
4.  compares the computed hash to the proof hash

If the hashes match, verification succeeds.

### GET /v1/proof/{id}

Returns metadata for a previously generated proof.

**Request**

```http
GET /v1/proof/nppp_000001
Authorization: Bearer <API_KEY>
```

**Response**

Example response:

```json
{
  "proof_id": "nppp_000001",
  "artifact_type": "dataset",
  "service": "nppp-notary",
  "bundle_sha256": "8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6",
  "bundle_url": "gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz",
  "created_at": "2026-03-26T00:00:00Z",
  "verification_status": "verified"
}
```

## Error Responses

The API returns standard HTTP status codes.

Common responses include:

| Status Code | Meaning |
|-------------|--------|
| 400 | Invalid request format |
| 401 | Authentication required or invalid API key |
| 404 | Proof not found |
| 500 | Internal service error |

Example error response:

```json
{
  "error": "invalid_request",
  "message": "Missing required field: evidence"
}
```

---

## Typical Integration Flow

A standard client integration looks like this:

1.  authenticate with API key
2.  submit artifact to `/v1/notarize`
3.  receive proof string and bundle metadata
4.  optionally store proof string in downstream systems
5.  replay verification later using `/v1/verify`

---

## Pricing

Verification is always free.

Notarization operations cost:

- $0.10 per proof

Developers receive:

- 20 free notarizations

## Rate Limits

API requests may be subject to rate limits to ensure service stability.

Typical limits may include:

- notarization requests per minute
- verification requests per minute
- metadata lookup requests per minute

If a client exceeds the allowed request rate, the API may return:
HTTP 429 — Too Many Requests

Clients should implement retry logic with exponential backoff when receiving this response.

---

## Related Files

- `openapi.yaml` — machine-readable API definition
- `../SPECIFICATION.md` — formal protocol definition
- `../cli/README.md` — command-line interface
