# NPPP Verification Flow

This document defines the replay verification flow for **NPPP v1**.

Verification in NPPP is based on recomputing the SHA-256 hash of the referenced evidence bundle and comparing it to the hash encoded in the proof string.

---

## Purpose

The purpose of verification is to answer a narrow but critical question:

> Does the retrieved evidence bundle exactly match the bundle referenced by the proof?

NPPP verification does not determine whether the evidence is truthful, complete, or legally authoritative. It only determines whether the notarized bundle has remained byte-identical since proof creation.

---

## Verification Inputs

A verifier requires:

- a valid NPPP v1 proof string
- access to the referenced evidence bundle
- an implementation capable of computing SHA-256

---

## Verification Outputs

Verification produces one of two outcomes.

### Success

The recomputed SHA-256 hash exactly matches the hash encoded in the proof string.

Example:

```text
SHA Replay Verified: OK
```
### Failure
The recomputed SHA-256 hash does not match the proof hash, or required inputs cannot be validated or retrieved.
## Canonical Verification Procedure
A verifier SHOULD perform the following steps in order:
1. Parse the NPPP proof string
2. Validate proof string format and required fields
3. Extract the bundle URI
4. Extract the expected `sha256` value
5. Retrieve the referenced evidence bundle
6. Compute the SHA-256 hash of the retrieved bundle
7. Compare the computed hash to the expected hash
8. Return the verification result
## Step-by-Step Detail
### Step 1 — Parse the Proof String
The verifier reads the proof string and confirms that it conforms to the NPPP v1 proof format.
This includes:
- `NPPP:V1` prefix
- correct field ordering
- required fields present
- no malformed key/value structure
### Step 2 — Validate Proof Metadata
The verifier confirms that required fields are present and syntactically valid.
At minimum this includes:
- `project`
- `region`
- `service`
- `freshness`
- `bundle`
- `sha256`
- `created`
### Step 3 — Retrieve the Evidence Bundle
The verifier retrieves the bundle referenced by the `bundle` field.
Example:
```text
gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz
```
Verification may fail if:
- the bundle does not exist
- the bundle cannot be accessed
- the storage service is unavailable
- the URI is invalid
### Step 4 — Compute SHA-256
The verifier computes the SHA-256 digest over the exact bytes of the retrieved bundle.
No transformation, decoding, or repackaging should occur before hashing.
The verifier hashes the raw bundle bytes as stored.
### Step 5 — Compare Hashes
The verifier compares:
- **expected hash** from proof string
- **computed hash** from retrieved bundle
If:
```
computed_hash == expected_hash
```
... verification succeeds.
Otherwise, verification fails.
### Verification Example
Given proof:
```text
NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z
```
A verifier:
1. parses the proof
2. retrieves `example_bundle.tar.gz`
3. computes SHA-256
4. compares the result
... returns success if the hashes match.
Example output:
```text
SHA Replay Verified: OK
```
---

## Remote Verification
Verification may occur against a remotely stored bundle.
This means the verifier may not possess a local copy of the bundle in advance. Instead, the verifier retrieves the bundle at verification time.
Remote verification is valid as long as:
- the bundle bytes retrieved are exact
- the SHA-256 recomputation is performed over those exact bytes
Example output:
```text
Remote SHA Replay Verified: OK
```
---

## Failure Conditions
Verification SHOULD fail if any of the following occur:
- invalid proof prefix
- malformed proof string
- missing required fields
- invalid `sha256` format
- invalid or inaccessible bundle URI
- bundle retrieval failure
- computed hash mismatch

---

## Trust Model
NPPP verification is designed to minimize trust.
A verifier does not need to trust:
- the system that originally created the proof
- the client that submitted the artifact
- the semantic content of the artifact
A verifier only needs:
1. the proof string
2. the referenced bundle
3. the ability to recompute SHA-256

---

## Non-Goals of Verification
NPPP verification does not establish:
- truthfulness of the artifact
- correctness of the artifact contents
- ownership of the underlying asset
- identity of the submitter
- correctness of external systems
It verifies only cryptographic integrity of the evidence bundle.

---

## Versioning
This verification flow is specific to NPPP v1.
Any change to proof semantics, hashing rules, bundle interpretation, or comparison behavior requires a new protocol version.
