variable "environment" {
}

variable "cidr" {
}

variable "availability_zones" {
  type    = list(string)
}

variable "private_subs" {
  type    = list(string)
}

variable "public_subs" {
  type    = list(string)
}

variable "cluster_name" {
}
