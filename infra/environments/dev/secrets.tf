# Secret definition
resource "google_secret_manager_secret" "api_secret_example" {
  secret_id = "api-secret-example"

  replication {
    auto {}
  }
}

# One version to hold initial value (optional, for demo)
resource "google_secret_manager_secret_version" "api_secret_example_v1" {
  secret      = google_secret_manager_secret.api_secret_example.id
  secret_data = "change-me"
}

# Allow the Cloud Run SA to access the secret
resource "google_secret_manager_secret_iam_member" "api_secret_access" {
  secret_id = google_secret_manager_secret.api_secret_example.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

# Example secret for your API (add more as needed)
resource "google_secret_manager_secret" "api_secret" {
  project   = var.project_id
  secret_id = "api-secret"
  replication { automatic = true }
}

# First version (store a placeholder; rotate later)
resource "google_secret_manager_secret_version" "api_secret_v1" {
  secret      = google_secret_manager_secret.api_secret.id
  secret_data = "replace-me-in-ci"
}

# Allow the Cloud Run SA to read secrets
resource "google_secret_manager_secret_iam_member" "api_secret_reader" {
  secret_id = google_secret_manager_secret.api_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}










variable "project_id" { type = string }
variable "region"     { type = string }          # e.g. us-central1
variable "media_bucket_name" { type = string }   # you already use this
variable "api_image"  { type = string }          # already in use

# New bits:
variable "domain_name" {
  description = "Your custom domain for the HTTPS LB (e.g. api.example.com). Leave empty to skip cert/proxy."
  type        = string
  default     = ""
}

variable "redis_tier"   { type = string  default = "BASIC" }   # BASIC or STANDARD_HA
variable "redis_size_gb"{ type = number  default = 1 }
variable "vpc_name"     { type = string  default = "default" } # keep default VPC for dev
variable "mig_zone"     { type = string  default = "us-central1-a" }
variable "mig_size"     { type = number  default = 1 }


