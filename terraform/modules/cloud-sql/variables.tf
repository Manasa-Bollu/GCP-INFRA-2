variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_network_id" {
  type = string
}
variable "db_instance_name" {
  type = string
}
variable "db_name" {
  type    = string
  default = "app_db"
}
variable "db_user" {
  type    = string
  default = "app_user"
}
variable "deletion_protection" {
  type    = bool
  default = false
}
variable "private_vpc_connection_id" {
  type = string
}
