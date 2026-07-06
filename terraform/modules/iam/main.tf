# Example: roles for backend cloud run service account
resource "google_project_iam_member" "backend_roles" {
  for_each = toset(var.backend_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${var.backend_sa_email}"
}

# Example: roles for frontend cloud run service account
resource "google_project_iam_member" "frontend_roles" {
  for_each = toset(var.frontend_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${var.frontend_sa_email}"
}

# Example: roles for github actions
resource "google_project_iam_member" "github_roles" {
  for_each = toset(var.github_roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${var.github_sa_email}"
}

# Workload identity pool for github actions
resource "google_iam_workload_identity_pool" "github_pool" {
  count                     = var.setup_github_wif ? 1 : 0
  workload_identity_pool_id = "github-actions-pool"
  project                   = var.project_id
  display_name              = "GitHub Actions Pool"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  count                              = var.setup_github_wif ? 1 : 0
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool[0].workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor"
    "attribute.repository" = "assertion.repository"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "github_wif_sa_bind" {
  for_each = var.setup_github_wif ? toset([
    "roles/iam.workloadIdentityUser",
    "roles/iam.serviceAccountTokenCreator"
  ]) : []

  service_account_id = var.github_sa_id
  role               = each.value
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool[0].name}/attribute.repository/${var.github_repository}"
}
