output "enabled_services" {
  description = "The enabled services"
  value       = [for s in google_project_service.services : s.service]
}
