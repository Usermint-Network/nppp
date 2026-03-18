# NPPP Proof Format

This document defines the canonical proof string format for **NPPP v1**.

The proof string is the portable, machine-readable representation of a notarization event. It binds a deterministic evidence bundle to a SHA-256 integrity hash and records the metadata required for replay verification.

---

## Purpose

The NPPP proof string exists to provide a compact representation of:

- the system that produced the proof
- the storage location of the evidence bundle
- the SHA-256 hash of that bundle
- the timestamp at which the proof was created

The proof string is intended to be:

- machine-readable
- deterministic
- replay-verifiable
- stable across all NPPP v1 implementations

---

## Canonical Structure

All NPPP v1 proofs MUST follow this exact field order:

```text
NPPP:V1|project=<project>|region=<region>|service=<service>|freshness=<window>|bundle=<bundle_uri>|sha256=<bundle_hash>|created=<timestamp>
```
### Field Ordering
Field ordering is mandatory for NPPP v1.
Implementations MUST emit fields in this exact sequence:
1. project
2. region
3. service
4. freshness
5. bundle
6. sha256
7. created
The ordering of fields is part of the canonical proof format. Reordering fields produces a non-canonical representation.
### Field Definitions
#### Prefix
```text
NPPP:V1
```
This prefix identifies the proof as an NPPP v1 proof string.
#### project
Identifier of the infrastructure project producing the proof.
Example:
```text
project=usermint-network
```
#### region
Infrastructure region associated with the service.
Example:
```text
region=us-central1
```
#### service
Service identity responsible for notarization.
Example:
```text
service=nppp-notary
```
#### freshness
Evidence collection window or freshness policy used when producing the proof.
Example:
```text
freshness=7d
```
#### bundle
URI of the deterministic evidence bundle.
Example:
```text
bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz
```
#### sha256
SHA-256 hash of the deterministic evidence bundle.
This value MUST be lowercase hexadecimal and MUST represent exactly 32 bytes encoded as 64 hexadecimal characters.
Example:
```text
sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6
```
#### created
UTC timestamp representing proof creation time.
Timestamps SHOULD use RFC 3339 / ISO 8601 UTC form with trailing `Z`.
Example:
```text
created=2026-03-26T00:00:00Z
```
### Canonical Example
```text
NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z
```

---

## Serialization Rules
NPPP v1 proof strings MUST satisfy the following rules:
- fields are pipe-delimited using `|`
- each field is encoded as `key=value`
- the prefix MUST be `NPPP:V1`
- field order MUST remain fixed
- keys MUST appear exactly as defined
- `sha256` MUST be lowercase hexadecimal
- no extra fields may be inserted into the canonical v1 proof string
- surrounding whitespace MUST NOT be added

---

## Parsing Rules
A verifier parsing an NPPP v1 proof string SHOULD:
1. confirm the `NPPP:V1` prefix
2. split the string on pipe delimiters
3. confirm field count and ordering
4. extract values for each field
5. validate required formats
6. proceed to replay verification
If parsing fails at any step, the proof MUST be treated as invalid or non-canonical.

---

## Validation Expectations
A valid NPPP v1 proof string SHOULD satisfy:
- correct prefix
- correct field ordering
- all required fields present
- non-empty values for each field
- valid SHA-256 format
- valid timestamp format
Validation of the proof string format is distinct from validation of the evidence bundle itself.

---

## Relationship to JSON Proof Objects
The canonical proof string is the transport representation of the proof.
Some clients may also expose a normalized JSON representation for tooling, explorers, or schema validation. In such cases, the normalized object MUST preserve the same logical values represented by the canonical proof string.
The proof string remains the canonical v1 representation.

---

## Compatibility and Versioning
NPPP v1 freezes this proof format.
Future changes to:
- field ordering
- field names
- required fields
- serialization format
... require a new protocol version.
Existing NPPP v1 proofs MUST remain verifiable indefinitely.
