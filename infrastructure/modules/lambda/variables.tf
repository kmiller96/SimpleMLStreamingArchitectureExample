variable "resource_prefix" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "package_path" {
  type = string
}

variable "source_bucket" {
  type = string
}

variable "source_key" {
  type = string
}

variable "entrypoint" {
  type    = string
  default = "app.lambda_handler"
}

variable "environment_variables" {
  type    = map
  default = { foo = "" }
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 3
}