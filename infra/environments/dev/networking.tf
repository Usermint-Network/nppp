# VPC for dev
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

# Memorystore Redis
resource "google_redis_instance" "dev_cache" {
  name           = "usermint-dev-redis"
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  region                  = var.region
  transit_encryption_mode = "DISABLED" # dev only; you can tighten later

  authorized_network = google_compute_network.dev_vpc.id

  redis_version = "REDIS_6_X"
  display_name  = "Usermint Dev Cache"
}
