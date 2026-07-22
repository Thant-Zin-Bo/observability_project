module "observability_vm" {
  source = "../../modules/observability_vm"

  project_id   = var.project_id
  region       = var.region
  zone         = var.zone
  environment  = var.environment
  owner        = var.owner
  machine_type = var.machine_type

  enable_public_api = var.enable_public_api
}