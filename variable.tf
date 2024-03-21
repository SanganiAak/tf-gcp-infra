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

variable "route_next_hop_gateway" {
  type = string
}
variable "route_dest_range" {
  type = string
}

variable "routing_mode" {
  type = string
}

variable "subnet_ip" {
  type = string
}

variable "machine_image" {
  type = string
}

variable "size" {
  type = number
}

variable "ip_cidr_range_db" {
  type = string
}

variable "ip_cidr_range_webapp" {
  type = string
}

variable "zone" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "webapp_port" {
  type = number
}

variable "gcp_mysql" {
  type    = string
  default = "mysql-gcp"
}

variable "availability_type" {
  type    = string
  default = "REGIONAL"
}

variable "database_version" {
  type    = number
  default = 8
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "gcp_ipv4_enabled" {
  type    = bool
  default = false
}

variable "mysql_disk_type" {
  type    = string
  default = "pd-ssd"
}

variable "mysql_disk_size" {
  type    = number
  default = 100
}

locals {
  sql_database = {
    user     = "webapp"
    database = "myDatabaseName"
  }
}
