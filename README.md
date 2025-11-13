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
