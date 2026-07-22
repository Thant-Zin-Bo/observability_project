locals {
  name_prefix = "obs-${var.environment}"

  common_labels = {
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
    project     = "gcp-incident-ready-observability-platform"
  }
}

resource "google_compute_network" "this" {
  name                    = "${local.name_prefix}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "this" {
  name          = "${local.name_prefix}-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.this.id
}

resource "google_compute_firewall" "iap_ssh" {
  name    = "${local.name_prefix}-allow-iap-ssh"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["observability-vm"]
}

resource "google_compute_firewall" "api" {
  count   = var.enable_public_api ? 1 : 0
  name    = "${local.name_prefix}-allow-api"
  network = google_compute_network.this.name

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["observability-vm"]
}

resource "google_service_account" "vm" {
  account_id   = "${local.name_prefix}-vm-sa"
  display_name = "Observability VM service account"
}

resource "google_project_iam_member" "vm_logging_viewer" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.vm.email}"
}

resource "google_compute_instance" "this" {
  name         = "${local.name_prefix}-vm"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["observability-vm"]

  labels = local.common_labels

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
      size  = 20
      type  = "pd-balanced"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.this.id


  }

  service_account {
    email  = google_service_account.vm.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    enable-oslogin = "TRUE"
  }
}