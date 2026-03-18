# AI Model Proof

This example demonstrates how to notarize an AI model and its training artifacts.

## Use Case

An AI system produces a trained model and needs to prove:

- training data integrity
- model reproducibility
- model version authenticity

---

## Step 1 — Submit for Notarization

```http
POST /v1/notarize

{
  "service": "nppp-notary",
  "artifact_type": "ai_model",
  "freshness": "30d",
  "evidence": {
    "model": "model.pt",
    "training_data": "dataset.csv",
    "config": "config.json"
  }
}
```

## Step 2 — Receive Proof
```json
{
  "proof_id": "nppp_000003",
  "proof": "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=30d|bundle=gs://...|sha256=...|created=2026-03-26T00:02:00Z"
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
* Model integrity
* Training lineage
* Reproducibility guarantees

## Why This Matters
* AI auditability
* Regulatory compliance
* Trust in AI outputs
