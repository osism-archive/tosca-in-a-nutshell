variable "project" {}

variable "from_port" {
  default = "1"
}

variable "to_port" {
  default = "65535"
}

variable "ip_protocol" {
  default = "tcp"
}

variable "cidr" {
  default = "0.0.0.0/0"
}
