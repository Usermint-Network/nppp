# NPPP Canonicalization Rules

This document defines the canonicalization principles for **NPPP v1**.

Canonicalization is the process of transforming notarization inputs into a stable representation so that identical logical artifacts produce identical evidence bundles.

---

## Purpose

Canonicalization exists to guarantee determinism.

Without canonicalization, semantically identical artifacts may produce different bytes, causing verification failures even when the underlying evidence has not meaningfully changed.

---

## Canonicalization Goal

The goal of canonicalization is:

> identical inputs should produce identical bundle bytes

This is required for replay verification to function reliably.

---

## Canonicalization Scope

Canonicalization applies to any input that influences the final evidence bundle, including:

- files
- metadata
- structured records
- service-generated context
- archive ordering

---

## Core Rules

NPPP v1 canonicalization SHOULD enforce the following principles.

### 1. Stable File Ordering

Files included in the bundle MUST be ordered deterministically.

Implementations SHOULD use a stable lexical ordering for file paths and entries.

---

### 2. Stable Directory Layout

Bundle layout MUST remain consistent across runs.

Identical logical inputs MUST produce the same folder structure.

Example:

```text
bundle/
  artifact/
  metadata/
  receipts/
```
### 3. Normalized Metadata
Metadata SHOULD be encoded in a stable representation.
Examples:
- consistent key ordering
- consistent field naming
- consistent whitespace handling
- consistent serialization format
### 4. Stable Text Encoding
Textual content SHOULD use a stable encoding, such as UTF-8, where applicable.
Implementations SHOULD avoid environment-dependent encoding behavior.
### 5. Stable Timestamp Handling
Only timestamps intentionally included as part of the notarized evidence should affect the bundle.
Incidental runtime timestamps, temporary file times, or archive creation times SHOULD NOT introduce non-determinism.
### 6. Deterministic Archive Generation
If an archive is used, its construction MUST be deterministic.
Equivalent inputs MUST result in identical archive bytes.

---

## Non-Canonical Sources of Variance
Implementations SHOULD eliminate or normalize sources of accidental variation such as:
- filesystem-dependent ordering
- unstable metadata ordering
- environment-specific line endings
- runtime-generated temporary values
- archive timestamps not intended as notarized evidence

---

## Canonicalization of Structured Data
For structured data formats, implementations SHOULD ensure consistent serialization.
Examples of consistency include:
- stable object key ordering
- normalized whitespace
- consistent numeric representation where relevant
The exact encoding strategy may vary by implementation, but the result MUST remain deterministic.

---

## Canonicalization of Binary Artifacts
Binary artifacts SHOULD be included as-is unless the protocol or application explicitly defines a canonical binary normalization process.
The key requirement is that the bytes included in the bundle remain stable and intentional.

---

## Relationship to Bundling
Canonicalization precedes hashing.
The canonicalized inputs are assembled into the evidence bundle, and the final serialized bundle is hashed using SHA-256.
If canonicalization is inconsistent, bundle hashes will diverge.

---

## Failure Mode
If identical logical artifacts do not produce identical bundle bytes, then:
- the resulting proof hashes may differ
- replay verification may fail unexpectedly
- the notarization process loses determinism

For this reason, canonicalization is not optional in NPPP v1 systems.

---

## Canonicalization and Trust
Canonicalization does not make evidence true.
It makes evidence stable.
This distinction is critical.
NPPP relies on canonicalization to ensure that cryptographic verification is meaningful across repeated verification attempts.

---

## Versioning
These rules define canonicalization expectations for NPPP v1.
Future protocol versions may introduce stricter normalization requirements, artifact-specific canonical forms, or mandatory serialization standards.
