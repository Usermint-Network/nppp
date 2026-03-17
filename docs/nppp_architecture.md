# NPPP (Notarization Proof Packet Protocol)



NPPP is a Network Proof of Provenance Protocol API Architecture

- **Client Layer**: Supports CI/CD pipelines, developer tools, and AI systems for submitting and verifying proofs
- **API Layer**: Exposes three endpoints—notarize, verify, and proof retrieval
- **Processing Layer**: Handles canonicalization, evidence bundling, SHA-256 hashing, and proof construction
- **Storage**: Evidence bundles stored in Google Cloud Storage; proof metadata persisted in Cloud SQL
- **Verification Flow**: Replay engine retrieves bundles and recomputes hashes to validate proofs against the ledger


