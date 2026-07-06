resource "google_redis_instance" "cache" {
  name           = var.redis_name
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region
  project        = var.project_id

  authorized_network = var.vpc_network_id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  depends_on = [var.private_vpc_connection_id]
}
