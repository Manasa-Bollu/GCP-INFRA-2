variable "project_id" {
  type = string
}
variable "secrets" {
  type    = list(string)
  default = []
}
variable "secret_values" {
  type    = map(string)
  default = {}
}
