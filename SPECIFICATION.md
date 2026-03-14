# NPPP v1 Specification

Notarization Proof Packet Protocol

Version: V1  
Status: Active

---

# 1. Overview

NPPP (Notarization Proof Packet Protocol) defines a deterministic method for binding digital artifacts to cryptographic integrity proofs that can be replayed and verified independently.

The protocol produces:

• a deterministic evidence bundle  
• a SHA-256 integrity hash  
• a canonical proof string  
• a replay verification procedure

The output of the protocol is a **proof packet** that allows independent verification of the integrity of the evidence bundle.

---

# 2. Terminology

Artifact  
A digital object submitted for notarization.

Canonical Artifact  
An artifact normalized according to canonicalization rules.

Evidence Bundle  
A deterministic archive containing evidence required to reproduce the proof.

Proof String  
A canonical machine-readable representation of a notarization event.

Verifier  
A system or individual performing replay verification.

---

# 3. Proof String Format

All NPPP proofs follow the canonical structure:

NPPP:V1|project=<project>|region=<region>|service=<service>|freshness=<window>|bundle=<bundle_uri>|sha256=<bundle_hash>|created=<timestamp>



Fields are pipe-delimited.

The ordering of fields MUST remain stable for version V1.

---

# 4. Field Definitions

project

Identifier of the infrastructure project producing the proof.

region

Infrastructure region associated with the service.

service

Service identity responsible for notarization.

freshness

Evidence collection window.

Example:
freshness=7d

bundle

URI of the deterministic evidence bundle.

Example:
gs://bucket/path/bundle.tar.gz


sha256

SHA-256 hash of the evidence bundle.

created

UTC timestamp representing proof creation time.

Example:
2026-03-02T00:11:17Z

---

# 5. Canonicalization Rules

Artifacts MUST be canonicalized prior to bundle generation.

Canonicalization includes:

• deterministic file ordering  
• normalized metadata where possible  
• stable archive structure  

The purpose of canonicalization is to ensure that identical artifacts produce identical evidence bundles.

---

# 6. Evidence Bundle Structure

Evidence bundles are deterministic archives.

Typical bundle contents include:

• artifact payload  
• service metadata  
• infrastructure metadata  
• runtime evidence  
• protocol receipts

The bundle MUST produce identical SHA-256 hashes when rebuilt from identical inputs.

---

# 7. Deterministic Bundle Requirements

To preserve replay verification capability, bundles MUST satisfy:

1. Stable file ordering
2. Stable directory layout
3. Canonical encoding of metadata
4. Deterministic archive generation

If these conditions are violated, verification may fail.

---

# 8. Verification Algorithm

Verification is performed by replaying the integrity check.

Procedure:

1. Parse the NPPP proof string
2. Retrieve the evidence bundle
3. Compute SHA-256 of the bundle
4. Compare computed hash with the proof hash
5. If equal → verification succeeds

Example result:
SHA Replay Verified: OK

---

# 9. Remote Verification

Verification may also occur using a remotely retrieved bundle.

Procedure:

1. Retrieve bundle from the URI
2. Compute SHA-256
3. Compare with proof string
4. If equal → remote verification succeeds

Example result:
Remote SHA Replay Verified: OK

---

# 10. Protocol Guarantees

NPPP v1 guarantees:

• deterministic evidence packaging  
• cryptographic integrity verification  
• replay-verifiable proofs  

The protocol allows any verifier to independently validate the integrity of the evidence bundle.

Verification does not require trust in the original operator.

---

# 11. Non-Goals

NPPP v1 intentionally does not attempt to solve several classes of problems.

The protocol does not guarantee:

• truthfulness of submitted artifacts  
• correctness of artifact contents  
• legal ownership of underlying assets  
• identity verification of submitters  
• external system integrity  

NPPP verifies **cryptographic integrity of evidence**, not the semantic truth of the artifact itself.

The protocol focuses exclusively on reproducible integrity verification.

---

# 12. Version Stability

NPPP v1 defines the first stable proof format.

The V1 proof string format is frozen for compatibility.

Future protocol improvements will require a version increment.

Existing proofs will remain verifiable indefinitely.
