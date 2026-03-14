# NPPP v1
## Notarization Proof Packet Protocol

NPPP v1 is a protocol for producing replay-verifiable evidence packets.

Systems submit canonical artifacts which are packaged into deterministic evidence bundles and bound to a SHA-256 proof string. Anyone can retrieve the bundle and replay verification independently.

In the same way TLS secures connections, **NPPP secures evidence**.

Typical artifacts include:

- AI outputs and model lineage
- datasets and evaluation results
- software build artifacts
- infrastructure state
- compliance records
- digital documents representing real-world assets

Developers receive:

- 20 free notarizations

Verification is always free.

Production notarization costs **$0.10 per proof**.

---

## Quickstart

Example CLI usage:

```bash
pip install nppp

nppp login --api-key <API_KEY>

nppp notarize artifact.json

nppp verify "NPPP:V1|..."
```
