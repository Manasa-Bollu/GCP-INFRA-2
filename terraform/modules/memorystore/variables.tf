variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "vpc_network_id" {
  type = string
}
variable "redis_name" {
  type    = string
  default = "cache-instance"
}
variable "private_vpc_connection_id" {
  type = string
}
