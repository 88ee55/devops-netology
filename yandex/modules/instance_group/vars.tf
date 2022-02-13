variable "folder" {
}

variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "sa" {
}

variable "subnets" {
}

variable "zones" {
  default = ["ru-central1-c"]
  type = list
}

variable "userdata" {
  default = ""
}
variable "sshkey" {
  type = string
}