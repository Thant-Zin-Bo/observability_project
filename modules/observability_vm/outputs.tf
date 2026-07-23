output "vm_name" {
  description = "VM name."
  value       = google_compute_instance.this.name
}

output "ansible_host" {
  description = "Internal IP address for access through IAP."
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "service_account_email" {
  description = "VM service account email."
  value       = google_service_account.vm.email
}
output "network_name" {
  description = "Name of the VPC network created for the observability VM."
  value       = google_compute_network.this.name
}