variable "name_prefix" {
  type = string
}

variable "enabled" {
  type    = bool
  default = true
}

variable "default_location" {
  type    = string
  default = "EU"
}

variable "bigquery_schema_file_path" {
  type = string
}

variable "template_github_repository" {
  type = string
}

variable "template_source_directory" {
  type = string
}

variable "template_metadata_file_path" {
  type = string
}

variable "vpc_subnet_ip_block" {
  type = string
}
