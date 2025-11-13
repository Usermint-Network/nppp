#Updated README.md 
usermint/
├─ README.md
├─ LICENSE
├─ .gitignore
├─ .gitattributes
├─ openapi/
│  └─ usermint.yaml
├─ api/
│  ├─ pyproject.toml
│  ├─ Dockerfile
│  └─ src/
│     ├─ main.py
│     ├─ deps.py
│     ├─ models.py
│     ├─ storage.py
│     ├─ chain.py
│     ├─ identify.py
│     ├─ mintables.py
│     ├─ playback.py
│     ├─ keyserver.py
│     └─ utils/
│        ├─ merkle.py
│        └─ crypto.py
├─ worker/
│  ├─ Dockerfile
│  └─ src/
│     ├─ worker.py
│     └─ ffmpeg_pack.py
├─ ops/
│  └─ startup-scripts/
│     └─ docker-cos.sh
├─ contracts/
│  ├─ foundry.toml
│  ├─ script/Deploy.s.sol
│  └─ src/
│     ├─ ChamberPass.sol
│     └─ SpecialMintableFactory.sol
├─ infra/
│  ├─ environments/
│  │  ├─ dev/
│  │  │  ├─ main.tf
│  │  │  ├─ variables.tf
│  │  │  ├─ outputs.tf
│  │  │  └─ startup.sh
│  │  └─ prod/
│  │     ├─ main.tf
│  │     ├─ variables.tf
│  │     └─ outputs.tf
│  └─ modules/
│     ├─ network/
│     │  └─ main.tf
│     ├─ storage/
│     │  └─ main.tf
│     ├─ compute_api/
│     │  └─ main.tf
│     └─ cdn/
│        └─ main.tf
└─ .github/
   └─ workflows/
      ├─ ci-api.yml
      ├─ ci-worker.yml
      └─ tf-plan-apply.yml

      # UserMint – Secret Chamber Platform

Private, token‑gated music platform for **unreleased** tracks with End‑User Minting (EUM).

## Gradients
1. **Repo Foundation** (you are here) – code skeleton, CI, Terraform dev infra.
2. Infrastructure (HTTPS LB, CDN, Secret Manager, Redis, MIG autoscaling).
3. NFT + Entitlements (Chamber Pass, Mintable Factory, allowlists, Merkle proofs).
4. Artist UX (upload → mintable → invite links) & Fan UX (invite → mint → play).
5. Observability & Anti‑abuse (rate limits, watermarking, anomaly agents).

## Quickstart
```bash
# Build API
cd api && pip install -e . && uvicorn src.main:app --reload
# Worker
cd ../worker && python3 src/worker.py

