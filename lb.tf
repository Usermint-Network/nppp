

# Serverless NEG pointing to your Cloud Run service
resource "google_compute_region_network_endpoint_group" "cr_neg" {
  name                  = "usermint-api-dev-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.api.name
  }
}

# Backend Service with CDN on
resource "google_compute_backend_service" "api_backend" {
  name                            = "usermint-api-dev-bes"
  load_balancing_scheme           = "EXTERNAL_MANAGED"
  protocol                        = "HTTPS"
  enable_cdn                      = true

  backend {
    group = google_compute_region_network_endpoint_group.cr_neg.id
  }

  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC" # good default; tune later with cache keys/TTL
  }
}

# URL Map
resource "google_compute_url_map" "api_map" {
  name            = "usermint-api-dev-map"
  default_service = google_compute_backend_service.api_backend.id
}

# SSL cert (skip if no domain yet)
resource "google_compute_managed_ssl_certificate" "api_cert" {
  count = length(var.domain_name) > 0 ? 1 : 0
  name  = "usermint-api-dev-cert"
  managed {
    domains = [var.domain_name]
  }
}

# HTTPS Proxy
resource "google_compute_target_https_proxy" "api_https_proxy" {
  count       = length(var.domain_name) > 0 ? 1 : 0
  name        = "usermint-api-dev-https-proxy"
  url_map     = google_compute_url_map.api_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.api_cert[0].id]
}

# Global IP
resource "google_compute_global_address" "api_ip" {
  count = length(var.domain_name) > 0 ? 1 : 0
  name  = "usermint-api-dev-ip"
}

# Forwarding rule
resource "google_compute_global_forwarding_rule" "api_fr" {
  count                 = length(var.domain_name) > 0 ? 1 : 0
  name                  = "usermint-api-dev-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_https_proxy.api_https_proxy[0].id
  port_range            = "443"
  ip_address            = google_compute_global_address.api_ip[0].id
}

output "lb_ip" {
  value       = try(google_compute_global_address.api_ip[0].address, "")
  description = "Point your DNS A record for var.domain_name at this IP."
}

