variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "network_name" {
  type = string
}
variable "connector_name" {
  type    = string
  default = "serverless-vpc-conn"
}
variable "subnet_cidr" {
  type    = string
  default = "10.1.0.0/28"
}
