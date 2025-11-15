resource "google_compute_region_network_endpoint_group" "api_neg" {
  name                  = "usermint-api-dev-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = "usermint-api-dev" # Cloud Run service name
  }
}

resource "google_compute_backend_service" "api_backend" {
  name                  = "usermint-api-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  enable_cdn            = true

  backend {
    group = google_compute_region_network_endpoint_group.api_neg.id
  }

  # Satisfies the error: one of cache_key_policy or signed_url_cache_max_age_sec
  cdn_policy {
    signed_url_cache_max_age_sec = 3600
  }
}
