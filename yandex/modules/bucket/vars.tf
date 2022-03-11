variable "name" {
  type = string
}

variable "acl" {
  default = "private"
  type    = string
}

variable "key" {
}
variable "sse" {
  default = {}
  type    = map(any)
}