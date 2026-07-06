variable "project_id" {
  type = string
}
variable "backend_sa_email" {
  type = string
}
variable "frontend_sa_email" {
  type = string
}
variable "github_sa_email" {
  type = string
}
variable "github_sa_id" {
  type = string
}
variable "backend_roles" {
  type    = list(string)
  default = ["roles/secretmanager.secretAccessor", "roles/cloudsql.client"]
}
variable "frontend_roles" {
  type    = list(string)
  default = ["roles/secretmanager.secretAccessor"]
}
variable "github_roles" {
  type    = list(string)
  default = ["roles/run.admin", "roles/iam.serviceAccountUser", "roles/artifactregistry.writer", "roles/vpcaccess.user"]
}
variable "setup_github_wif" {
  type    = bool
  default = true
}
variable "github_repository" {
  type    = string
  default = "user/repo"
}
