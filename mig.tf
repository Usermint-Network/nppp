resource "google_service_account" "worker" {
  account_id   = "usermint-worker-dev"
  display_name = "Usermint Worker (dev)"
}

# Minimal roles (add more as needed for GCS/Redis/etc)
resource "google_project_iam_member" "worker_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.worker.email}"
}

resource "google_compute_instance_template" "worker_tpl" {
  name_prefix = "usermint-worker-dev-"
  machine_type = "e2-small"
  region       = var.region
  tags         = ["worker"]

  service_account = google_service_account.worker.email
  can_ip_forward  = false

  disk {
    boot         = true
    auto_delete  = true
    source_image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2204-lts"
  }

  network_interface {
    network = data.google_compute_network.vpc.self_link
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -xe
    apt-get update
    apt-get install -y docker.io
    systemctl enable --now docker

    # Example: run a worker container (replace with your image/command)
    docker run --restart=always -d \
      --name usermint-worker \
      us-central1-docker.pkg.dev/usermint-network/usermint/worker:dev
  EOT
}

resource "google_compute_region_instance_group_manager" "worker_mig" {
  name               = "usermint-worker-dev"
  region             = var.region
  base_instance_name = "usermint-worker"

  version {
    instance_template = google_compute_instance_template.worker_tpl.self_link
  }

  target_size = var.mig_size
}

resource "google_compute_autoscaler" "worker_as" {
  name   = "usermint-worker-dev-as"
  region = var.region
  target = google_compute_region_instance_group_manager.worker_mig.id

  autoscaling_policy {
    min_replicas = 0
    max_replicas = 10
    cpu_utilization {
      target = 0.6
    }
    cooldown_period = 60
  }
}

