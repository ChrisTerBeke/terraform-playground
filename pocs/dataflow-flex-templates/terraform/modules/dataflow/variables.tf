variable "name_prefix" {
  type = string
}

variable "bigquery_schema_file_path" {
  type = string
}

variable "bigquery_location" {
  type = string
}

variable "vpc_subnet_ip_block" {
  type = string
}

variable "template_storage_bucket" {
  type = string
}

variable "template_storage_path" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "dataflow_max_workers" {
  type    = number
  default = 10
}
