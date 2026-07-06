output "service_url" { value = google_cloud_run_v2_service.service.uri }
output "neg_id" { value = google_compute_region_network_endpoint_group.serverless_neg.id }
