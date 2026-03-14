# NPPP CLI

Command Line Interface for the Notarization Proof Packet Protocol

---

## Overview

The NPPP CLI allows developers to interact with the Notarization Proof Packet Protocol directly from the terminal.

Using the CLI, developers can:

- authenticate with the UserMint Network
- notarize digital artifacts
- retrieve proof strings
- verify proofs through replay verification

The CLI is designed for use in:

- local developer environments
- CI/CD pipelines
- automated infrastructure workflows

---

## Installation

Install the CLI using Python pip.

```bash
pip install nppp
```

Verify installation:

```bash
nppp --help
```

---

## Authentication

Before submitting notarization requests, authenticate with an API key issued by the UserMint Network.

```bash
nppp login --api-key <API_KEY>
```

Example:

```bash
nppp login --api-key um_live_abc123xyz
```

After authentication, the CLI stores credentials locally for future requests.

---

## Commands

The CLI currently exposes the following core commands.

### nppp login

Authenticates the developer with the network.

```bash
nppp login --api-key <API_KEY>
```

This command must be executed before submitting notarization requests.

### nppp notarize

Submits an artifact for notarization.

```bash
nppp notarize <file>
```

Example:

```bash
nppp notarize artifact.json
```

When the command executes, the CLI performs the following operations:

- canonicalizes the artifact
- generates a deterministic evidence bundle
- computes the SHA-256 hash of the bundle
- constructs an NPPP proof string

Example output:

```text
Proof Created

Proof ID: nppp_000001

Bundle SHA256:
8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6

Proof:
NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z
```

### nppp verify

Verifies an NPPP proof by replaying the cryptographic integrity check.

```bash
nppp verify "<proof_string>"
```

Example:

```bash
nppp verify "NPPP:V1|project=usermint-network|region=us-central1|service=nppp-notary|freshness=7d|bundle=gs://usermint-network-notary-dev/bundles/example_bundle.tar.gz|sha256=8c95954ad897cd933d760eb29dd7ee7bf69ec7e94b49ed88317b554bfb7ba4d6|created=2026-03-26T00:00:00Z"
```

Verification process:

- parse the proof string
- retrieve the evidence bundle
- compute the SHA-256 hash
- compare the computed hash to the proof hash

Example output:

```text
Retrieving Evidence Bundle
Computing SHA-256

SHA Replay Verified: OK
```

Verification can be performed independently of the original operator.

---

## Example Workflow

Authenticate with the network:

```bash
nppp login --api-key um_live_abc123xyz
```

Notarize a file:

```bash
nppp notarize dataset.csv
```

Verify the resulting proof:

```bash
nppp verify "NPPP:V1|..."
```

---

## Trial Usage

Developers receive:

- 20 free notarizations

Verification is always free.

After the trial quota is consumed, notarization operations cost:

- $0.10 per proof

---

## Design Goals

The NPPP CLI is designed to make notarization and verification simple enough to run anywhere.

Typical use cases include:

- CI/CD pipelines
- infrastructure integrity verification
- AI artifact provenance
- compliance documentation
- digital asset notarization
