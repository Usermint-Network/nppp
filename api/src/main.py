from datetime import timedelta
import os

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from google.cloud import storage

app = FastAPI()

class UploadRequest(BaseModel):
    filename: str
    content_type: str

# Bucket name from Terraform / Cloud Run env:
BUCKET_NAME = os.getenv("STORAGE_BUCKET")
if not BUCKET_NAME:
    raise RuntimeError("STORAGE_BUCKET env var is not set")

# This will use Cloud Run's service account automatically
storage_client = storage.Client()

@app.get("/")
def root():
    return {"status": "running"}

@app.get("/health")
def health():
    return {"ok": True}

@app.post("/media/upload-request")
def get_upload_url(req: UploadRequest):
    try:
        bucket = storage_client.bucket(BUCKET_NAME)
        blob = bucket.blob(req.filename)

        url = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(hours=1),
            method="PUT",
            content_type=req.content_type,
        )

        # This is the gs:// pointer you’ll later store in DB
        storage_url = f"gs://{BUCKET_NAME}/{req.filename}"

        return {
            "upload_url": url,
            "storage_url": storage_url,
        }

    except Exception as e:
        # Log the exact error to Cloud Run logs, but keep client message clean-ish
        raise HTTPException(
            status_code=500,
            detail=f"Error generating signed URL: {e}"
        )
