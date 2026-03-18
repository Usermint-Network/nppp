# AI Model Proof

This example demonstrates how to notarize an AI model and its training artifacts.

## Use Case

An AI system produces a trained model and needs to prove:

- training data integrity
- model reproducibility
- model version authenticity

## Step 1 — Submit for Notarization

```json
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
Step 2 — Proof Generation
The system bundles:
model weights
training dataset
training configuration
Then computes:
deterministic bundle
SHA-256 hash
NPPP proof string
Step 3 — Verification
Verification ensures:
model has not been altered
training inputs match original state
reproducibility is possible
What is Proven
Model integrity
Training lineage
Reproducibility guarantees
Why This Matters
This enables:
AI auditability
regulatory compliance
trust in AI outputs
