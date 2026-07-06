variable "project_id" {

  type        = string
  description = "The GCP Project ID where the state bucket will reside"
  default     = "project-b1008fb7-e9d3-4eb5-81f"

}

variable "region" {

  type        = string
  description = "The GCP region"
  default     = "us-central1"

}

variable "state_bucket_name" {

  type        = string
  description = "The globally unique name for the state bucket"
  default     = "tfstate-community-rewards"

}
