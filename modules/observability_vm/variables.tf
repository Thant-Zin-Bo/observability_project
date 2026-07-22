variable "project_id" {
  description = "GCP project ID."
  type        = string
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
}

variable "owner" {
  description = "Owner label."
  type        = string
}

variable "machine_type" {
  description = "Compute Engine machine type."
  type        = string
}



variable "enable_public_api" {
  description = "Expose API port for demo access."
  type        = bool
}