output "vm_name" {
  description = "Name of the private Compute Engine VM."
  value       = module.observability_vm.vm_name
}

output "ansible_host" {
  description = "Private VM IP address for Ansible access through IAP."
  value       = module.observability_vm.ansible_host
}

output "service_account_email" {
  description = "Email address of the service account attached to the VM."
  value       = module.observability_vm.service_account_email
}