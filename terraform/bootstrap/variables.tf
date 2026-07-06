variable "project_id" {

  type        = string
  description = "The GCP Project ID where the state bucket will reside"

}

variable "region" {

  type        = string
  description = "The GCP region"
  default     = "us-central1"

}

variable "state_bucket_name" {

  type        = string
  description = "The globally unique name for the state bucket"

}
