
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

# Service account for Cloud Run
resource "google_service_account" "api" {
  account_id   = "usermint-api-dev"
  display_name = "Usermint API (dev)"
}

# Grant artifact registry reader to SA
resource "google_project_iam_member" "api_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.api.email}"
}

# Cloud Run (one resource only)
resource "google_cloud_run_v2_service" "api" {
  name     = "usermint-api-dev"
  location = var.region

  template {
    service_account = google_service_account.api.email

    containers {
      image = var.api_image

      # Regular envs
      env {
        name  = "STORAGE_BUCKET"
        value = var.media_bucket_name
      }

      env {
        name  = "CDN_HOST"
        value = ""
      }

      # Secret env (from Secret Manager)
      env {
        name = "EXAMPLE_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.api_secret_example.name
            version = "latest"
          }
        }
      }

      ports { container_port = 8080 }
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"
}

# Output
output "api_url" {
  value       = google_cloud_run_v2_service.api.uri
  description = "Primary Cloud Run URL (supports all routes)"
}
