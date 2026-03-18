# NPPP Bundle Structure

This document defines the conceptual structure of deterministic evidence bundles used by **NPPP v1**.

The evidence bundle is the object whose bytes are hashed and bound to the NPPP proof string.

---

## Purpose

The evidence bundle exists to capture the data required for replay verification.

It is the canonical evidence package associated with a proof and serves as the source object for SHA-256 integrity validation.

---

## Core Requirement

An evidence bundle MUST be deterministic.

Given identical inputs, the resulting bundle MUST produce identical bytes and therefore the same SHA-256 hash.

This requirement is foundational to replay verification.

---

## Conceptual Contents

An NPPP evidence bundle may include the following categories of material:

- artifact payload
- service metadata
- infrastructure metadata
- protocol receipts
- runtime evidence relevant to proof generation

The exact contents may vary by use case, but the bundle MUST remain deterministic.

---

## Recommended Top-Level Layout

A typical bundle may be organized as follows:

```text
bundle/
  artifact/
  metadata/
  receipts/
```
### Directory Roles
#### `artifact/`
Contains the primary notarized artifact or artifacts.
Examples:
- dataset file
- model weights
- PDF document
- software build artifact
- configuration file
#### `metadata/`
Contains metadata required to interpret the bundle and reproduce the proof context.
Examples:
- service metadata
- region or environment data
- notarization parameters
- canonicalization metadata
#### `receipts/`
Contains protocol-related receipts or output evidence associated with the notarization process.
Examples:
- generated proof metadata
- notarization response records
- supporting audit records

---

## Determinism Requirements
The bundle MUST satisfy all of the following:
- Stable file ordering
- Stable directory structure
- Stable metadata serialization
- Stable archive generation
- Stable byte content for identical inputs
If any of these properties are violated, replay verification may fail.

---

## Archive Format
NPPP v1 does not require a single archive container format in this document, but implementations MUST ensure that whatever archive form is used is deterministic.
Example bundle URI:
```text
gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz
```
If an archive format such as `tar.gz` is used, the generation process MUST be deterministic.

---

## Hash Scope
The SHA-256 hash recorded in the proof string applies to the entire serialized evidence bundle.
The verifier hashes the exact bytes retrieved from storage.
The verifier does not hash individual files independently for protocol validity.

---

## Immutability Expectations
Once a bundle is associated with a proof:
- the stored bytes MUST remain unchanged
- the storage location SHOULD remain stable
- the bundle SHOULD remain retrievable for future verification
If the bundle changes after proof creation, verification MUST fail.

---

## Example Bundle Relationship
**Proof string:**
```text
NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z
```
In this example:
- the `bundle` field identifies the stored evidence package
- the `sha256` field identifies the expected digest of the full bundle bytes

---

## Relationship to Canonicalization
Canonicalization occurs before or during bundle construction.
The bundle structure alone does not guarantee determinism. Determinism depends on canonicalization rules being applied consistently before bundle hashing.
See:
- `canonicalization_rules.md`

---

## Bundle vs Proof
- The **bundle** is the evidence object.
- The **proof string** is the cryptographic pointer to that object.
NPPP verification succeeds only if the bundle bytes match the hash encoded in the proof string.

---

## Versioning
This bundle structure document describes the expectations of NPPP v1.
Future versions may expand bundle conventions or introduce stronger structural requirements, but any change that affects proof semantics must be versioned explicitly.
