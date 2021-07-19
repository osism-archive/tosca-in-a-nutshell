variable "project" {}
variable "pubkey" {}
variable "network" {}

variable "counter" {
  default = 1
}

variable "flavor" {
  default = "1C-1GB-10GB"
}

variable "image" {
  default = "Ubuntu 20.04"
}

variable "zone" {
  default = null
}

variable "fip_pool" {
  default = "external"
}

variable "secgroups" {
  default = []
}

variable "disk_size" {
  default = 10
}
