# Security Policy

NPPP is a protocol for generating replay-verifiable evidence packets.

The security of NPPP v1 relies on deterministic bundle generation, durable evidence storage, and cryptographic integrity verification using SHA-256.

---

## Scope

This security policy applies to:

- the NPPP proof format
- deterministic evidence bundle generation
- replay verification behavior
- reference protocol documentation
- the UserMint Network reference implementation

---

## Security Goals

NPPP v1 is designed to provide:

- integrity verification of notarized evidence bundles
- replay-verifiable proof packets
- independent verification without requiring trust in the original operator
- stable proof semantics across the v1 protocol line

The protocol is intended to make it possible for verifiers to confirm that a notarized evidence bundle has not been modified after proof generation.

---

## Threat Model

NPPP v1 is designed to detect the following classes of failure:

- tampering with stored evidence bundles
- mutation of notarized artifacts after bundle generation
- corruption of bundle contents in storage or transit
- mismatch between a proof string and the underlying evidence bundle

Replay verification detects these conditions by recomputing the SHA-256 hash of the retrieved evidence bundle and comparing it with the hash encoded in the proof string.

---

## Non-Goals

NPPP v1 does **not** guarantee:

- truthfulness of submitted evidence
- correctness of the contents of an artifact
- identity verification of submitters
- legal ownership of underlying assets
- correctness of external systems that produced the evidence
- availability of remote storage endpoints
- confidentiality of public proof material

NPPP verifies the **cryptographic integrity of evidence**, not the semantic truth of the evidence itself.

---

## Cryptographic Primitive

NPPP v1 uses:

- **SHA-256** for deterministic bundle integrity verification

The protocol assumes SHA-256 remains computationally secure for integrity checking within the threat model of NPPP v1.

---

## Determinism Requirement

Security of the protocol depends on deterministic bundle generation.

If identical evidence inputs do not produce identical bundle bytes, replay verification may fail even if the underlying evidence has not changed.

Implementations should ensure:

- stable file ordering
- stable archive structure
- canonical metadata serialization
- stable encoding of textual content where applicable

---

## Verification Model

Verification in NPPP v1 consists of:

1. parsing the proof string
2. retrieving the referenced evidence bundle
3. computing the SHA-256 hash of that bundle
4. comparing the computed hash to the proof hash

If the hashes match, the verifier may conclude that the retrieved bundle bytes match the original notarized bundle bytes.

Example result:

```text
SHA Replay Verified: OK
```

Verification does not require trust in the original operator beyond access to the referenced bundle.

## Storage Considerations

Evidence bundles may be stored in remote object storage.

Storage systems should provide:

- durable retention
- exact byte retrieval
- stable addressing
- auditability where possible

If a bundle is deleted or cannot be retrieved, verification may become unavailable even though the proof format remains valid.

## Reference Implementation Notes

The UserMint Network operates a reference implementation of the NPPP protocol.

Security of the reference implementation depends not only on protocol correctness, but also on:

- service hardening
- access control
- storage durability
- operational security
- logging and audit practices

Implementation weaknesses do not invalidate the protocol definition, but they may affect operational reliability.

## Reporting Security Issues

If you believe you have discovered a security issue affecting NPPP or the reference implementation, please report it privately before public disclosure.

Contact:

- security@usermintnetwork.com

Please include:

- a clear description of the issue
- affected component or file
- reproduction steps
- expected behavior
- observed behavior
- severity assessment, if known

## Disclosure Expectations

Please avoid public disclosure until the issue has been reviewed.

The goal of responsible disclosure is to:

- validate the issue
- assess protocol or implementation impact
- prepare remediation where possible
- notify affected users if necessary

## Versioning and Security Stability

NPPP v1 defines a stable proof format.

Security-relevant changes that alter proof semantics, deterministic bundle rules, or verification behavior must be handled through formal protocol versioning.

Backward-incompatible changes require a new protocol version.

## Security Boundaries

The NPPP protocol secures **evidence integrity**, not evidence interpretation.

A successful verification confirms only that the retrieved evidence bundle is byte-identical to the bundle originally notarized.

Verification does not imply that:

- the evidence was truthful
- the evidence was complete
- the evidence was produced by a trustworthy system

Systems consuming NPPP proofs must apply their own policies when interpreting the contents of an evidence bundle.

## Summary

NPPP v1 provides replay-verifiable cryptographic integrity over deterministic evidence bundles.

It is designed to answer a narrow but important question:

> Has the notarized evidence changed since the proof was created?

It is not designed to answer broader questions of truth, ownership, or legal interpretation.
