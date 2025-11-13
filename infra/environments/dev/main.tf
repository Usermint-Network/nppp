terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_service_account" "api" {
  account_id   = "usermint-api-dev"
  display_name = "Usermint API (dev)"
}

resource "google_project_iam_member" "api_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.api.email}"
}

resource "google_cloud_run_v2_service" "api" {
  name     = "usermint-api-dev"
  location = var.region

  template {
    service_account = google_service_account.api.email

    containers {
      image = var.api_image

      env {
        name  = "STORAGE_BUCKET"
        value = var.media_bucket_name
      }

      env {
        name  = "CDN_HOST"
        value = ""
      }

      ports {
        container_port = 8080
      }
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"
}

output "api_url" {
  value = google_cloud_run_service.api.status[0].url
  description = "Primary Cloud Run URL (supports all routes)"
}
