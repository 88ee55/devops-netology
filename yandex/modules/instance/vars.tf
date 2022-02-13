variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "subnet" {
}

variable "ip" {
  default = ""
}

variable "nat" {
  default = false
  type = bool
}

variable "sshkey" {
  type = string
}

variable "userdata" {
  default = ""
}