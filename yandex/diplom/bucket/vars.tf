variable "folder-id" {
  type = string
}

variable "zone" {
  default = "ru-central1-c"
  type    = string
}

variable "bucket" {
  default = "terraform-states-88ee55"
  type    = string
}


variable "protect" {
  default = true
  type    = bool
}
