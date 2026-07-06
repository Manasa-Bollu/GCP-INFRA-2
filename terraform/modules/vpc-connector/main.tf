resource "google_vpc_access_connector" "connector" {
  name          = var.connector_name
  project       = var.project_id
  region        = var.region

  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = 3

  subnet {
    name       = google_compute_subnetwork.connector_subnet.name
    project_id = var.project_id
  }
}

resource "google_compute_subnetwork" "connector_subnet" {
  name          = "${var.connector_name}-subnet"
  project       = var.project_id
  region        = var.region
  network       = var.network_name
  ip_cidr_range = var.subnet_cidr
}