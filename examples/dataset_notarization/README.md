# Dataset Notarization

This example demonstrates how to notarize a dataset using NPPP.

## Use Case

A data pipeline produces a dataset (`dataset.csv`) and needs to prove:

- the dataset existed at a specific time
- the dataset has not been altered
- the dataset can be verified independently

---

## Step 1 — Submit for Notarization

```http
POST /v1/notarize

{
  "service": "nppp-notary",
  "artifact_type": "dataset",
  "freshness": "7d",
  "evidence": {
    "path": "dataset.csv"
  }
}
```
## Step 2 — Receive Proof
```json
{
  "proof_id": "nppp_000001",
  "proof": "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://...|sha256=...|created=2026-03-26T00:00:00Z"
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
* Dataset integrity (via SHA-256)
* Dataset existence at timestamp
* Reproducibility via bundle

## Mapping to Schema

| Field     | Meaning               |
| :-------- | :-------------------- |
| `bundle`  | Stored dataset bundle |
| `sha256`  | Dataset fingerprint   |
| `created` | Time of notarization  |
