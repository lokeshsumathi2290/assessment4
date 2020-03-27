variable "environment" {
}

variable "instance_type" {
}

variable "asg_desired_capacity" {
}

variable "asg_max_size" {
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

variable "cluster_version" {
}
