# NPPP GitHub Actions Integration

This directory provides a GitHub Actions workflow for integrating **NPPP (Notarization Proof Packet Protocol)** into CI/CD pipelines.

---

## Overview

The NPPP GitHub Action enables automatic notarization of artifacts generated during builds.

Typical use cases:

- notarizing datasets after pipeline completion
- notarizing AI model outputs
- notarizing build artifacts
- generating verifiable proof records for compliance

---

## Workflow

The action performs the following steps:

1. Collect artifact
2. Submit artifact to NPPP API
3. Receive proof string
4. Store or output proof for downstream use

---

## Example Use Case

A pipeline generates a dataset:

```text
dataset.csv
The workflow:
submits dataset for notarization
receives proof string
logs proof or stores it as an artifact
Requirements
NPPP API endpoint (e.g., https://api.usermint.network)
API key for authentication
Artifact path available in workflow
Outputs
The workflow produces:
NPPP proof string
proof metadata (optional)
Security Notes
API keys should be stored in GitHub Secrets
Proof strings may be logged or persisted depending on workflow design
Example Integration
See nppp-notarize.yml for a full workflow example.

---
