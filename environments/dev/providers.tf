terraform {
  cloud {
    organization = "thantzinbo"

    workspaces {
      name = "observability_project"
    }
  }
}


provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}