variable "project_id" {
  description = "The GCP project ID"
}

variable "region" {
  description = "The GCP region"
  default     = "us-east1"
}

variable "vpc_name" {
  description = "The name of the VPC"
}

variable "var_count" {
  default = 1
  type    = number
}

variable "app_name" {
  type    = string
  default = "webapp"
}
variable "database" {
  type    = string
  default = "db"

}