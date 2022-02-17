variable "name" {
  type = string
}

variable "env" {
  type    = string
  default = "PRESTABLE"

  validation {
    condition     = var.env == "PRESTABLE" || var.env == "STABLE"
    error_message = "Env only PRESTABLE or STABLE."
  }
}

variable "db_version" {
  default = "8.0"
  type    = string
}

variable "resource" {
  type = map(string)
}

variable "db_name" {
  type = string
}

variable "backup_time" {
  type = map(number)
}

variable "protect" {
  default = false
  type    = bool
}

variable "credentials" {
  type      = map(string)
  sensitive = true
}

variable "network" {
}

variable "host" {
}