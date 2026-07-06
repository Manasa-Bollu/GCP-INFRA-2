variable "project_id" {

  type        = string
  description = "The GCP Project ID for the QA environment"
  default     = "project-b1008fb7-e9d3-4eb5-81f"

}

variable "region" {

  type        = string
  description = "The GCP region"
  default     = "us-central1"

}

variable "domain" {

  type        = string
  description = "The custom domain for the environment"
  default     = "qa-api.example.com"

}

variable "github_repository" {

  type        = string
  description = "The GitHub repository in the format owner/repo for Workload Identity Federation"
  default     = "Manasa-Bollu/GCP-INFRA-2"

}
