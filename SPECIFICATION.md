# NPPP v1 Specification
**Notarization Proof Packet Protocol**

Version: V1  
Status: Active  

---

# 1. Overview

NPPP (Notarization Proof Packet Protocol) defines a deterministic method for binding digital artifacts to cryptographic integrity proofs that can be independently replayed and verified.

The protocol produces:

- a deterministic evidence bundle
- a SHA-256 integrity hash
- a canonical proof string
- a replay verification procedure

The output of the protocol is a **proof packet** that enables independent verification of artifact integrity without requiring trust in the originating system.

---

# 2. Terminology

## 2.1 Artifact
A digital object submitted for notarization.

## 2.2 Canonical Artifact
An artifact normalized according to NPPP canonicalization rules.

## 2.3 Evidence Bundle
A deterministic archive containing all material required to reproduce the proof.

## 2.4 Proof String
A canonical, machine-readable representation of a notarization event.

## 2.5 Verifier
An entity performing replay verification.

---

# 3. Protocol Model

NPPP operates as a two-phase protocol:

## 3.1 Notarization Phase
1. Canonicalize artifact
2. Construct deterministic evidence bundle
3. Compute SHA-256 hash of bundle
4. Generate canonical proof string

## 3.2 Verification Phase
1. Parse proof string
2. Retrieve referenced bundle
3. Recompute SHA-256 hash
4. Compare against proof hash

---

# 4. Proof String Format

## 4.1 Canonical Structure

All NPPP v1 proofs MUST follow this exact format:

```text
NPPP:V1|project=<project>|region=<region>|service=<service>|freshness=<window>|bundle=<bundle_uri>|sha256=<bundle_hash>|created=<timestamp>
```
## 4.2 Field Ordering (MANDATORY)
Fields MUST appear in this exact order:
- `project`
- `region`
- `service`
- `freshness`
- `bundle`
- `sha256`
- `created`

Reordering fields produces a non-canonical proof.

## 4.3 Serialization Rules
Proof strings MUST:
- use `|` as a delimiter
- encode fields as `key=value`
- contain no additional fields
- contain no leading or trailing whitespace
- use lowercase hexadecimal for `sha256`

# 5. Field Definitions

| Field       | Description                        |
|-------------|------------------------------------|
| `project`   | Infrastructure project identifier  |
| `region`    | Infrastructure region              |
| `service`   | Notarization service identity      |
| `freshness` | Evidence collection window         |
| `bundle`    | URI of deterministic evidence bundle |
| `sha256`    | SHA-256 hash of bundle             |
| `created`   | UTC timestamp (RFC 3339)           |

# 6. Canonicalization Rules

Artifacts MUST be canonicalized prior to bundle construction.

Canonicalization MUST ensure:
- deterministic file ordering
- stable directory structure
- normalized metadata serialization
- deterministic archive generation

Identical logical inputs MUST produce identical bundle bytes.

# 7. Evidence Bundle

## 7.1 Structure
Typical bundle layout:
```
bundle/
  artifact/
  metadata/
  receipts/
```

## 7.2 Determinism Requirements
Bundles MUST satisfy:
- stable file ordering
- stable directory layout
- stable metadata encoding
- deterministic archive construction

Violation of these requirements results in verification failure.

# 8. Verification Algorithm
Verification MUST be performed as follows:
1. Parse proof string
2. Validate format and field order
3. Extract bundle URI
4. Retrieve bundle
5. Compute SHA-256 hash over raw bytes
6. Compare computed hash with proof hash

**Result:**
- `computed_hash == expected_hash` → `VERIFIED`
- `else` → `FAILED`

Example output:
```
SHA Replay Verified: OK
```

# 9. Remote Verification
Verification MAY be performed using remotely retrieved bundles.

Requirements:
- bundle bytes MUST be exact
- hashing MUST be performed on raw bytes

Example output:
```
Remote SHA Replay Verified: OK
```

# 10. Protocol Guarantees
NPPP v1 guarantees:
- deterministic evidence packaging
- cryptographic integrity verification
- replay-verifiable proofs

Verification requires:
- proof string
- bundle access
- SHA-256 computation

No trust in the originating system is required.

# 11. Non-Goals
NPPP v1 does NOT guarantee:
- truthfulness of artifacts
- correctness of artifact contents
- ownership of assets
- identity of submitters
- external system validity

NPPP verifies integrity, not truth.

# 12. Versioning
The NPPP v1 proof format is frozen.

Any changes to:
- field structure
- hashing rules
- serialization format

MUST result in a new protocol version.

Existing proofs MUST remain verifiable indefinitely.

# 13. Compliance Language
The key words MUST, SHOULD, and MAY are to be interpreted as described in RFC 2119.
