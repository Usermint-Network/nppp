# NPPP Genesis Proof

Protocol Launch Artifact for the Notarization Proof Packet Protocol

---

## Overview

The genesis proof represents the first notarization event recorded under the NPPP protocol.

This proof establishes the initial reference point for the protocol and demonstrates the deterministic evidence verification model defined by **NPPP v1**.

The genesis artifact serves as a permanent example of how a proof packet is constructed and verified.

---

## Purpose

The genesis proof exists to:

- demonstrate the NPPP proof format
- provide a canonical verification example
- mark the initial launch of the protocol
- establish the first reference proof for the network

Like the genesis blocks used in blockchain systems, the genesis proof provides a historical anchor for the protocol.

---

## Genesis Timestamp

Protocol Launch Date:
2026-03-26T00:00:00Z

This timestamp represents the initial activation of the **NPPP v1 protocol**.

---

## Genesis Artifact

The genesis proof notarizes a simple launch artifact representing the activation of the protocol.

Example artifact contents may include:

- protocol launch declaration
- repository commit reference
- protocol version
- timestamp of creation

The artifact is packaged into a deterministic evidence bundle following the rules defined in:

`../SPECIFICATION.md`

---

## Genesis Proof File

The genesis proof itself is stored in:

`GENESIS_PROOF_2026_03_26.txt`

This file contains the canonical **NPPP proof string** representing the genesis notarization event.

---

## Verification

The genesis proof can be verified using the NPPP CLI.

Example:

```bash
nppp verify "<GENESIS_PROOF_STRING>"
```

Verification performs the following steps:

1.  parse the proof string
2.  retrieve the evidence bundle
3.  compute the SHA-256 integrity hash
4.  compare the computed hash with the proof hash

If the values match, the proof is valid.

Example result:

```
SHA Replay Verified: OK
```

### Historical Role

The genesis proof serves a similar role to:

- the Bitcoin genesis block
- the Ethereum genesis state
- initial protocol launch artifacts used in distributed systems

While NPPP is not a blockchain, maintaining a genesis proof provides a clear historical starting point for the protocol.

### Long-Term Verification

As long as the evidence bundle referenced in the genesis proof remains accessible, the proof can be independently verified by any party.

This demonstrates the central property of the NPPP protocol:

> replay-verifiable evidence that does not require trust in the original operator.

### Summary

The genesis proof marks the launch of the NPPP protocol and provides a permanent reference example of the notarization proof format.

Future notarization events will follow the same protocol rules defined in:

- `PROTOCOL.md`
- `SPECIFICATION.md`
