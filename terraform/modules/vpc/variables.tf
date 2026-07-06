variable "project_id" {

  type        = string
  description = "The GCP Project ID"

}

variable "region" {

  type        = string
  description = "The default region for the VPC subnet"

}

variable "network_name" {

  type        = string
  description = "The name of the VPC network"
  default     = "main-vpc"

}

variable "subnet_name" {

  type        = string
  description = "The name of the subnet"
  default     = "main-subnet"

}

variable "subnet_cidr" {

  type        = string
  description = "The CIDR range for the subnet"
  default     = "10.0.0.0/20"

}
