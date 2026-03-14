# NPPP Economic Model

Economic Design of the Notarization Proof Packet Protocol

---

## Overview

The NPPP protocol separates **verification** from **notarization**.

Verification is always free.

Notarization operations incur a small fee that supports operation of the network infrastructure responsible for generating and storing deterministic evidence bundles.

This economic model is designed to ensure:

- open verification
- predictable infrastructure costs
- sustainable network operation
- minimal friction for developers

---

## Core Principle

The protocol enforces a simple rule:

**Creating proofs costs money.  
Verifying proofs does not.**

This model mirrors other core internet infrastructure.

For example:

| System | Paid Operation | Free Operation |
|------|----------------|----------------|
| Certificate Authorities | Certificate issuance | TLS verification |
| Blockchains | Transaction inclusion | Block verification |
| NPPP | Evidence notarization | Proof verification |

By making verification free, NPPP ensures that proof validation remains accessible to anyone.

---

## Notarization Pricing

The network charges a small fee for each notarization operation.

Current pricing model:

$0.10 per notarization

A notarization operation includes:

- artifact canonicalization
- deterministic bundle generation
- evidence storage
- SHA-256 integrity computation
- proof string generation
- proof ledger recording

This fee covers the infrastructure required to produce durable, replay-verifiable evidence packets.

---

## Free Developer Trial

Developers receive a limited number of free notarizations.

Current developer allocation:

20 free notarizations


This allows developers to:

- experiment with the protocol
- integrate the CLI
- test verification workflows
- validate CI/CD integrations

The goal is to make early experimentation frictionless.

---

## Verification Economics

Verification of an existing proof is always free.

Verification operations involve:

- parsing the proof string
- retrieving the referenced evidence bundle
- recomputing the SHA-256 integrity hash
- comparing the computed hash with the proof hash

Because verification can be performed independently by any verifier, the protocol does not restrict verification access.

Open verification is essential for maintaining trust in the proof model.

---

## Infrastructure Costs

Operating the NPPP protocol requires infrastructure capable of supporting:

- notarization services
- object storage for evidence bundles
- proof metadata storage
- API access
- verification tooling
- operational monitoring

The notarization fee supports these infrastructure requirements.

Verification operations are intentionally lightweight and may be performed by third parties without interacting with the network operator.

---

## Economic Design Goals

The economic model for NPPP was designed around several principles.

### Predictability

Developers should be able to estimate notarization costs easily.

A flat per-proof fee provides simple cost modeling for systems generating large volumes of evidence.

---

### Open Verification

Verification must remain accessible to anyone.

Charging for verification would undermine the independence of proof validation.

---

### Minimal Friction

The cost of notarization must remain low enough to support:

- automated CI/CD evidence generation
- AI system provenance tracking
- compliance documentation
- infrastructure state notarization

Low pricing enables high-volume usage.

---

### Sustainable Infrastructure

The network must maintain durable storage and reliable notarization services.

Charging a small fee for proof creation ensures that infrastructure costs remain sustainable over time.

---

## Long-Term Economic Direction

As the protocol evolves, additional infrastructure layers may emerge.

Potential future capabilities include:

- public proof explorers
- artifact lineage tracking
- compliance dashboards
- automated verification services
- enterprise notarization services

These services may introduce additional economic layers while preserving the core protocol rule:

**verification remains free.**

---

## Summary

The NPPP economic model is intentionally simple.

- proof creation incurs a small fee
- proof verification is free
- developers receive a limited free trial

This model supports sustainable operation of the protocol while preserving open verification for all participants.

The goal is to enable widespread adoption of replay-verifiable evidence across software systems, AI systems, and compliance infrastructure.
