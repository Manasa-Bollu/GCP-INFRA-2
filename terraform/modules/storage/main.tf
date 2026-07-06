resource "google_storage_bucket" "bucket" {
  for_each      = toset(var.buckets)
  name          = each.key
  location      = var.region
  project       = var.project_id
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true
}
