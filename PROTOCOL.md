# NPPP Protocol

Notarization Proof Packet Protocol

Version: V1  
Status: Active

---

# The Problem

Modern digital systems generate enormous amounts of data.

Build artifacts.  
AI outputs.  
Datasets.  
Infrastructure states.  
Compliance records.

Yet when verification is required later, the evidence is often incomplete or unreproducible.

Logs expire.  
Artifacts disappear.  
Systems change.

As a result, organizations frequently rely on **assertions rather than proofs**.

NPPP exists to address this gap.

The protocol provides a deterministic way for systems to produce **replay-verifiable evidence packets**.

---

# The Primitive

NPPP introduces a simple primitive:

A system can produce a **proof packet** that allows anyone to independently verify the integrity of the evidence used to create that proof.

The packet contains:

1. a canonical artifact
2. a deterministic evidence bundle
3. a cryptographic integrity hash
4. a machine-readable proof string

Together these components form a **Notarization Proof Packet**.

---

# Conceptual Model

The protocol operates in a deterministic sequence.

artifact
   ↓
canonicalization
   ↓
deterministic evidence bundle
   ↓
SHA-256 integrity binding
   ↓
NPPP proof string
   ↓
replay verification


The result is a proof that can be verified **without trusting the original operator**.

---

# Canonical Artifacts

The first step of the protocol is canonicalization.

Artifacts submitted to the protocol may include:

• AI outputs and model lineage  
• datasets and evaluation results  
• software build artifacts  
• infrastructure configuration states  
• compliance records  
• digital documents representing real-world assets  

Canonicalization normalizes these artifacts so that identical inputs produce identical outputs.

This allows deterministic evidence bundles to be created.

---

# Deterministic Evidence Bundles

Evidence bundles are archives that contain the artifacts required to reproduce a proof.

Typical contents include:

• artifact payload  
• service metadata  
• infrastructure metadata  
• runtime request evidence  
• protocol receipts  

The bundle must be generated deterministically.

Given the same input artifacts, the bundle must produce the same SHA-256 hash.

This property enables independent replay verification.

---

# Proof Strings

The proof string is the canonical representation of a notarization event.

Example structure:

NPPP:V1|
project=<project>|
region=<region>|
service=<service>|
freshness=<window>|
bundle=<bundle_uri>|
sha256=<bundle_hash>|
created=<timestamp>

• the service producing the proof  
• the infrastructure environment  
• the deterministic evidence bundle  
• the cryptographic integrity hash  
• the timestamp of creation  

This string acts as the **portable representation of the proof**.

---

# Verification

Verification consists of replaying the integrity check.

A verifier performs the following steps:

1. parse the proof string
2. retrieve the evidence bundle
3. compute the SHA-256 hash
4. compare the hash to the proof string

If the hashes match, the proof is valid.

Example result:
SHA Replay Verified: OK

Verification may occur locally or against a remotely stored bundle.

---

# Network Operation

The UserMint Network operates the reference implementation of NPPP.

Developers interact with the network through:

• CLI tools  
• HTTP API endpoints  
• CI/CD integrations  

Each notarization produces:

• a proof string  
• an evidence bundle  
• a ledger entry representing the notarization event

Verification remains free.

Notarization operations require a small fee to support network infrastructure.

---

# Economic Model

The network charges a small fee per notarization.

Pricing model:
$0.10 per notarization

Developers receive a limited number of free notarizations to test the protocol.

This structure enables the protocol to operate as infrastructure while maintaining open verification.

---

# Scope

NPPP verifies **cryptographic integrity** of evidence bundles.

The protocol does not assert:

• truthfulness of artifact contents  
• legal ownership of underlying assets  
• correctness of external systems  

Instead, it ensures that the evidence associated with a proof has not been modified.

---

# Why This Matters

Distributed systems increasingly rely on automated verification.

Protocols such as TLS allow secure communication between machines.

NPPP introduces a similar primitive for evidence.

It enables systems to produce artifacts that can be verified later by independent parties.

This capability is particularly important for:

• AI systems  
• automated infrastructure  
• compliance automation  
• supply chain verification  

As systems grow more complex, the ability to verify historical evidence becomes increasingly valuable.

---

# The Beginning of the Protocol

NPPP v1 is the first primitive of the UserMint Network.

It establishes a foundation for verifiable digital evidence.

Future protocol layers may expand the capabilities of the network, but the core idea remains simple:

**Evidence should be reproducible.  
Proofs should be replayable.  
Verification should be independent.**

---

# Genesis

The first public notarization event will occur when the protocol opens.

Genesis Artifact:
genesis/GENESIS_PROOF_2026_03_26.txt


This artifact represents the initial proof produced by the network.

---

# Versioning

NPPP v1 defines the first stable protocol format.

Future changes to the proof structure will require a version increment.

Existing proofs will remain verifiable indefinitely.

---

# Closing Principle

The protocol rests on a single principle:

Systems should not merely claim what happened.

They should produce evidence that allows others to verify it.
