variable "project_id" {
  type = string
}
variable "lb_name" {
  type    = string
  default = "main-lb"
}
variable "domain" {
  type = string
}
variable "backend_neg_id" {
  type = string
}
variable "frontend_neg_id" {
  type = string
}
variable "ssl_certificate_id" {
  type = string
}
