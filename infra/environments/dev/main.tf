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

########################
# Variables
########################
variable "project_id" {
  type        = string
  description = "GCP project ID"
}
variable "region" {
  type        = string
  description = "GCP region (e.g., us-central1)"
}
variable "media_bucket_name" {
  type        = string
  description = "GCS bucket for media"
}
variable "api_image" {
  type        = string
  description = "Container image for the Usermint API"
}

########################
# IAM / Service Account
########################
resource "google_service_account" "api" {
  account_id   = "usermint-api-dev"
  display_name = "Usermint API (dev)"
}

resource "google_project_iam_member" "api_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.api.email}"
}

########################
# Secret Manager
########################
resource "google_secret_manager_secret" "api_secret_example" {
  secret_id = "dev-api-example-secret"
  replication { auto {} }
}

resource "google_secret_manager_secret_version" "api_secret_example_v1" {
  secret      = google_secret_manager_secret.api_secret_example.id
  secret_data = "dev-example-secret-value"
}

resource "google_secret_manager_secret_iam_member" "api_can_access_example" {
  secret_id = google_secret_manager_secret.api_secret_example.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

########################
# Cloud Run (single resource)
########################
resource "google_cloud_run_v2_service" "api" {
  name     = "usermint-api-dev"
  location = var.region

  template {
    service_account = google_service_account.api.email

    containers {
      image = var.api_image

      # existing envs
      env { name = "STORAGE_BUCKET" value = var.media_bucket_name }
      env { name = "CDN_HOST"       value = "" }

      # Secret as env var
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

  # Ensure IAM on the secret is applied before new revisions roll
  depends_on = [
    google_secret_manager_secret_iam_member.api_can_access_example
    # artifact reader IAM is already above
  ]
}

output "api_url" {
  value       = google_cloud_run_v2_service.api.uri
  description = "Primary Cloud Run URL (supports all routes)"
}
