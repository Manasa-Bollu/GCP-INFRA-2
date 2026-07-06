output "workload_identity_provider_name" {
  value = var.setup_github_wif ? google_iam_workload_identity_pool_provider.github_provider[0].name : ""
}
