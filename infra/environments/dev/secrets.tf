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

