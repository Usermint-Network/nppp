import os
from datetime import timedelta

import google.auth
from google.auth import impersonated_credentials
from google.cloud import storage
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

app = FastAPI()


class UploadRequest(BaseModel):
    filename: str
    content_type: str



# Env vars provided by Terraform / Cloud Run, now using consistent variable names
MEDIA_BUCKET = os.environ["MEDIA_BUCKET_NAME"]
SERVICE_ACCOUNT_EMAIL = os.environ["SERVICE_ACCOUNT_EMAIL"]


@app.get("/")
def root():
    return {"status": "running"}


@app.get("/health")
def health():
    return {"ok": True}


@app.post("/media/upload-request")
def create_upload_url(body: UploadRequest):
    try:
        # 1) Base credentials = Cloud Run service account (no private key)
        base_credentials, _ = google.auth.default()

        # 2) Impersonate the service account that CAN sign
        signing_credentials = impersonated_credentials.Credentials(
            source_credentials=base_credentials,
            target_principal=SERVICE_ACCOUNT_EMAIL,
            target_scopes=[
                "https://www.googleapis.com/auth/devstorage.read_write",
            ],
            lifetime=3600,
        )

        # 3) Storage client using the impersonated signer
        storage_client = storage.Client()
        bucket = storage_client.bucket(MEDIA_BUCKET)
        blob = bucket.blob(body.filename)

        # 4) Generate a v4 signed URL with the impersonated signer
        upload_url = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(hours=1),
            method="PUT",
            content_type=body.content_type,
            credentials=signing_credentials,
        )

        return {
            "uploadUrl": upload_url,
            "bucket": MEDIA_BUCKET,
            "object": body.filename,
        }

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Error generating signed URL: {e}",
        )
