variable "project_id" {

  type        = string
  description = "The GCP Project ID for the DEV environment"

}

variable "region" {

  type        = string
  description = "The GCP region"
  default     = "us-central1"

}

variable "domain" {

  type        = string
  description = "The custom domain for the environment"
  default     = "api.example.com"

}

variable "github_repository" {

  type        = string
  description = "The GitHub repository in the format owner/repo for Workload Identity Federation"
  default     = "YOUR_ORG/YOUR_REPO"

}
