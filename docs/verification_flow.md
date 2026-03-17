# NPPP_Architecture



## NPPP Verification Flow
This sequence diagram illustrates how the Notarization Proof Packet Protocol (NPPP) verifies the authenticity and integrity of notarized content.

**Process Overview:**

1. **Proof Submission** — Client submits a proof string to the `/v1/verify`  endpoint
2. **Proof Parsing** — API extracts the bundle URL and expected SHA-256 hash from the proof string
3. **Bundle Retrieval** — The original evidence bundle is fetched from Google Cloud Storage
4. **Hash Recomputation** — Verification Engine independently computes the SHA-256 hash of the retrieved bundle
5. **Integrity Check** — Computed hash is compared against the expected hash from the proof string
6. **Result** — Verification succeeds if hashes match; fails if they differ
**Key Security Property:** Verification is deterministic—any modification to the original content will produce a different hash, causing verification to fail.



