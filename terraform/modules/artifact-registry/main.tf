resource "google_artifact_registry_repository" "repo" {
  for_each      = toset(var.repositories)
  location      = var.region
  repository_id = each.key
  description   = "Docker repository for ${each.key}"
  format        = "DOCKER"
  project       = var.project_id

  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = 5
    }
  }
}
