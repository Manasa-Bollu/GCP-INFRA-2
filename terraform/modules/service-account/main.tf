resource "google_service_account" "sa" {
  for_each     = toset(var.service_accounts)
  account_id   = each.key
  display_name = "Service Account for ${each.key}"
  project      = var.project_id
}
