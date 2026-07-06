output "repository_urls" {
  value = { for k, v in google_artifact_registry_repository.repo : k => "${v.location}-docker.pkg.dev/${v.project}/${v.name}" }
}
