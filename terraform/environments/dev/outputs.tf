output "load_balancer_ip" {
  value       = module.load_balancer.ip_address
  description = "The external IP address of the load balancer. Configure your DNS A record to point to this IP."
}

output "backend_service_url" {
  value = module.cloud_run_backend.service_url
}

output "frontend_service_url" {
  value = module.cloud_run_frontend.service_url
}

output "github_actions_sa_email" {
  value = module.service_accounts.emails["github-actions-sa"]
}

output "workload_identity_provider" {
  value = module.iam.workload_identity_provider_name
}
