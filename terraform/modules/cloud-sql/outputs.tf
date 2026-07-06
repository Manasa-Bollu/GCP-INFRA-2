output "instance_name" { value = google_sql_database_instance.instance.name }
output "private_ip_address" { value = google_sql_database_instance.instance.private_ip_address }
output "db_name" { value = google_sql_database.database.name }
output "db_user" { value = google_sql_user.users.name }
output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
output "database_url" {
  value     = "postgresql://${google_sql_user.users.name}:${urlencode(random_password.db_password.result)}@${google_sql_database_instance.instance.private_ip_address}:5432/${google_sql_database.database.name}"
  sensitive = true
}
