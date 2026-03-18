# Changelog

All notable changes to the NPPP (Notarization Proof Packet Protocol) project will be documented in this file.

This project adheres to semantic versioning principles where applicable.

---

## [v1.0.0] - 2026-03-26

### 🚀 Initial Protocol Release

This release establishes the foundational specification for **NPPP v1**, defining the deterministic notarization and replay verification model.

---

### ✨ Added

#### Core Protocol
- Canonical NPPP proof string format (`protocol/proof_format.md`)
- Replay verification procedure (`protocol/verification_flow.md`)
- Deterministic evidence bundle structure (`protocol/bundle_structure.md`)
- Canonicalization rules for deterministic hashing (`protocol/canonicalization_rules.md`)

#### API Layer
- OpenAPI 3.1 specification for notarization and verification endpoints (`api/openapi.yaml`)
  - `POST /v1/notarize`
  - `POST /v1/verify`
  - `GET /v1/proof/{id}`

#### Explorer + Schema
- JSON Schema for NPPP proof objects (`explorer/proof_schema.json`)
- Example proof object (`explorer/example_proof.json`)

#### Documentation
- NPPP architecture overview (`docs/nppp_architecture.md`)
- Protocol walkthrough and economic model documentation

#### Diagrams
- NPPP system architecture diagram (`diagrams/nppp_architecture.png`)
- Verification flow diagram (`diagrams/verification_flow.png`)

#### Examples
- Dataset notarization example (`examples/dataset_notarization`)
- AI model proof example (`examples/ai_model_proof`)
- Compliance artifact notarization example (`examples/compliance_artifact`)

---

### 🔒 Guarantees Introduced

- Deterministic bundle hashing (SHA-256)
- Canonical proof string format with strict field ordering
- Replay-based verification model (no trust required)
- Storage-agnostic bundle retrieval (e.g., GCS)

---

### ⚠️ Notes

- NPPP v1 proof format is **frozen**
- Any changes to:
  - field ordering
  - hashing behavior
  - bundle semantics  
  require a new protocol version

---

### 🧠 Summary

NPPP v1 establishes a **verifiable, deterministic, and portable proof system** for notarizing digital artifacts and validating their integrity through replay verification.

—
