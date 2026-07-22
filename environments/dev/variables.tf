variable "project_id" {
  description = "GCP project ID."
  type        = string
  default     = "terraform-learn-498518"
}

variable "region" {
  description = "GCP region."
  type        = string
}

variable "zone" {
  description = "GCP zone."
  type        = string
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner label."
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type."
  type        = string
  default     = "e2-small"
}



variable "enable_public_api" {
  description = "Whether to expose the API port for controlled demo access."
  type        = bool
  default     = true
}