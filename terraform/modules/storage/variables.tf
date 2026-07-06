variable "project_id" {
  type = string
}
variable "region" {
  type = string
}
variable "buckets" {
  type    = list(string)
  default = []
}
variable "force_destroy" {
  type    = bool
  default = false
}
