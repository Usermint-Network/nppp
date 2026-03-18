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

## Step 1 — Submit Artifact

```json
{
  "service": "nppp-notary",
  "artifact_type": "compliance_document",
  "freshness": "90d",
  "evidence": {
    "document": "audit_report.pdf"
  }
}
Step 2 — Proof Generation
NPPP produces:
deterministic evidence bundle
SHA-256 hash
proof string
Step 3 — Verification
Auditors can:
retrieve bundle
recompute hash
validate proof independently
What is Proven
Document has not changed
Document existed at a specific time
Audit trail is cryptographically verifiable
Why This Matters
Reduces audit friction
Enables zero-trust verification
Supports regulatory compliance
