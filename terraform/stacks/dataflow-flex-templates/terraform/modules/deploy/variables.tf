variable "name_prefix" {
  type = string
}

variable "storage_location" {
  type = string
}

variable "template_github_repository" {
  type = string
}

variable "template_directory" {
  type = string
}

variable "template_metadata_file_path" {
  type    = string
  default = "metadata.json"
}

variable "template_source_code_directory" {
  type    = string
  default = "src"
}
