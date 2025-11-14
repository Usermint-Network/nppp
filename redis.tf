data "google_compute_network" "vpc" {
  name    = var.vpc_name
  project = var.project_id
}

resource "google_redis_instance" "cache" {
  name           = "usermint-redis-dev"
  tier           = var.redis_tier          # BASIC for dev, STANDARD_HA for prod
  memory_size_gb = var.redis_size_gb
  region         = var.region

  authorized_network = data.google_compute_network.vpc.self_link
  transit_encryption_mode = "DISABLED"     # enable for prod if needed

  # Optional: maintenance window, redis configs…
}

# Pipe host/port to outputs/env if you’ll reach from GCE or a connector.
output "redis_host" { value = google_redis_instance.cache.host }
output "redis_port" { value = google_redis_instance.cache.port }

