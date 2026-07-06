variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "service_name" {
  type = string
}
variable "image_url" {
  type = string
}
variable "container_port" {
  type    = number
  default = 8000
}
variable "service_account_email" {
  type = string
}
variable "min_instances" {
  type    = number
  default = 0
}
variable "max_instances" {
  type    = number
  default = 3
}
variable "vpc_connector_id" {
  type    = string
  default = ""
}
variable "env_vars" {
  type    = map(string)
  default = {}
}
variable "secret_env_vars" {

  type = map(object({
    secret_id = string

  }))
  default = {}
}
