variable "token" {
  type = string
}

variable "folder" {
  type = string
}

variable "zone" {
  default = "ru-central1-c"
  type    = string
}

variable "protect" {
  default = true
  type = bool
}
