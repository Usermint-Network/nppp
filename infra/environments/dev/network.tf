# VPC
resource "google_compute_network" "dev_vpc" {
  name                    = "usermint-dev-vpc"
  auto_create_subnetworks = false
}

# Subnet (adjust CIDR if needed)
resource "google_compute_subnetwork" "dev_subnet" {
  name          = "usermint-dev-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.dev_vpc.id
}
