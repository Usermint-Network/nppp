
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

<<<<<<< HEAD
# Cloud Run (one resource only)
=======
########################
# Secret Manager
########################
resource "google_secret_manager_secret" "api_secret_example" {
  secret_id = "dev-api-example-secret"
  replication {
    auto {}
  }
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
>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))
resource "google_cloud_run_v2_service" "api" {
  name     = "usermint-api-dev"
  location = var.region

  template {
    service_account = google_service_account.api.email

    containers {
      image = var.api_image

<<<<<<< HEAD
      # Regular envs
=======
>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))
      env {
        name  = "STORAGE_BUCKET"
        value = var.media_bucket_name
      }
<<<<<<< HEAD
=======
      env {
        name  = "CDN_HOST"
        value = ""
      }
>>>>>>> b0a1b24 (Module 1: dev core infra (Cloud Run API, VPC, Redis, Secret Manager, CDN backend))

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
