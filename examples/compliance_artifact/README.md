# Compliance Artifact Notarization

This example demonstrates how NPPP can be used for compliance and audit artifacts.

## Use Case

An organization generates compliance documents such as:

- financial reports
- audit logs
- regulatory filings

They need to prove:

- document integrity
- timestamp of submission
- audit traceability

---

## Step 1 — Submit for Notarization

```http
POST /v1/notarize

{
  "service": "nppp-notary",
  "artifact_type": "compliance_document",
  "freshness": "90d",
  "evidence": {
    "path": "audit_report.pdf"
  }
}
```

## Step 2 — Receive Proof
```json
{
  "proof_id": "nppp_000002",
  "proof": "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=90d|bundle=gs://...|sha256=...|created=2026-03-26T00:01:00Z"
}
```

## Step 3 — Verification
```http
POST /v1/verify

{
  "proof": "NPPP:V1|..."
}
```

---

## What is Proven
* Document has not changed
* Document existed at a specific time
* Audit trail is cryptographically verifiable

## Why This Matters
* Reduces audit friction
* Enables zero-trust verification
* Supports regulatory compliance
