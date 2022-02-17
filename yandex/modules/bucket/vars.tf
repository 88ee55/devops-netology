variable "folder" {
  type = string
}

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
}

variable "file_source" {
}

variable "sse" {
  default = {}
  type    = map(any)
}