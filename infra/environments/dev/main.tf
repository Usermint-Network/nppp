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
  project   = var.project_id
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
  project   = var.project_id
  secret_id = google_secret_manager_secret.api_secret_example.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

########################
# Cloud Run API
########################

resource "google_cloud_run_v2_service" "api" {
  name     = "usermint-api-dev"
  location = var.region

  template {
    containers {
      image = var.api_image

      env {
        name  = "MEDIA_BUCKET_DEV_1"
        value = var.media_bucket_name
      }

      env {
        name  = "terraform-sa@usermint-network.iam.gserviceaccount.com"
        value = ""
      }

      env {
        name = "EXAMPLE_SECRET"
        value=
google_service_account.api.email
          }
        }
      }

      ports {
        container_port = 8080
      }
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"

  depends_on = [
    google_secret_manager_secret_iam_member.api_can_access_example,
    google_project_iam_member.api_artifact_reader,
  ]
}

########################
# Networking (VPC + Subnet)
########################

resource "google_compute_network" "dev_vpc" {
  name                    = "usermint-dev-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "dev_subnet" {
  name          = "usermint-dev-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.dev_vpc.id
}

########################
# Redis (Memorystore)
########################

resource "google_redis_instance" "dev_cache" {
  name           = "usermint-dev-redis"
  tier           = var.redis_tier
  memory_size_gb = var.redis_size_gb

  region                  = var.region
  transit_encryption_mode = "DISABLED" # dev only

  authorized_network = google_compute_network.dev_vpc.id

  redis_version = "REDIS_6_X"
  display_name  = "Usermint Dev Cache"
}

########################
# Outputs
########################

output "api_url" {
  value       = google_cloud_run_v2_service.api.uri
  description = "Primary Cloud Run URL (supports all routes)"
}
