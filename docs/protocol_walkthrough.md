# NPPP Protocol Walkthrough

This document provides a step-by-step walkthrough of how the Notarization Proof Packet Protocol (NPPP) operates.

The goal of the protocol is simple:

**Produce evidence that can be independently verified later.**

---

# High-Level Flow

The protocol transforms an artifact into a replay-verifiable proof.

Artifact
↓
Canonicalization
↓
Deterministic Evidence Bundle
↓
SHA-256 Integrity Binding
↓
NPPP Proof String
↓
Independent Replay Verification

---

# Step 1 — Artifact Creation

A system generates an artifact.

Examples include:

- AI model output
- dataset evaluation results
- software build artifact
- infrastructure configuration snapshot
- compliance documentation

Example artifact:
artifact.json

---

# Step 2 — Canonicalization

Artifacts must be normalized before notarization.

Canonicalization ensures that identical inputs always produce identical outputs.

Typical canonicalization rules:

• deterministic file ordering  
• normalized metadata  
• stable file encoding  

Purpose:
same artifact → same canonical representation

This step is essential for deterministic hashing.

---

# Step 3 — Evidence Bundle Generation

The canonical artifact is packaged into a deterministic archive called the **Evidence Bundle**.

Example bundle structure:
bundle/ artifact/ artifact.json metadata/ service.json environment.json receipts/ request.json

The bundle is archived as:
bundle.tar.gz

Deterministic archive generation ensures the bundle hash remains stable.

---

# Step 4 — Cryptographic Integrity Binding

The protocol computes a SHA-256 hash of the bundle.

Example:
SHA256(bundle.tar.gz)
8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6

This hash becomes the cryptographic anchor of the proof.

---

# Step 5 — Proof String Construction

The protocol constructs a machine-readable proof string.

Example:
NPPP:V1| project=usermint-network| region=us-central1| service=nppp-notary| freshness=7d| bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz| sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6| created=2026-03-26T00:00:00Z

This string acts as the **portable proof of the notarization event**.

---

# Step 6 — Evidence Storage

The evidence bundle is stored in durable infrastructure.

Example location:
gs://usermint-network-notary-dev/bundles/

The proof string references this bundle.

---

# Step 7 — Replay Verification

Anyone can verify the proof independently.

Verification steps:

1. parse the proof string
2. retrieve the evidence bundle
3. compute the SHA-256 hash
4. compare with the proof hash

If the hashes match:
SHA Replay Verified: OK

This confirms the evidence bundle has not been modified.

---

# Verification Independence

Verification does **not require trust** in the original operator.

Any verifier can reproduce the integrity check.

This property makes NPPP suitable for:

• AI provenance verification  
• software supply chain integrity  
• infrastructure state verification  
• compliance artifact notarization  

---

# Why Replay Verification Matters

Traditional systems rely on assertions:
"We generated this result."

NPPP replaces assertions with reproducible proofs:
"Here is the evidence. Verify it yourself."

This shift enables automated verification in distributed systems.

---

# Relationship to Other Protocols

Protocols like TLS secure communication.

NPPP secures **evidence**.
TLS → secure connection NPPP → verifiable proof

---

# Summary

The NPPP protocol transforms digital artifacts into reproducible cryptographic evidence.

Key properties:

• deterministic artifact processing  
• cryptographic integrity binding  
• portable proof strings  
• independent replay verification  

These primitives allow systems to produce evidence that remains verifiable indefinitely.
