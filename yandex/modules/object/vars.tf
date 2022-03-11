variable "name" {
  type = string
}

variable "acl" {
  default = "public-read"
  type    = string
}

variable "key" {
}

variable "file_destination" {
  default = null
}

variable "file_source" {
  default = null
}