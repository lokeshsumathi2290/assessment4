variable "aws_profile" {
  default = ""
}

variable "instance_type" {
  default = "m4.large"
}

// Autoscaling desired capacity
variable "asg_desired_capacity" {
  default = "3"
}

// Autoscaling maximum capacity
variable "asg_max_size" {
  default = "10"
}

// VPC cidr
variable "cidr" {
  default = "172.19.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "private_subs" {
  type    = list(string)
  default = ["172.19.1.0/24", "172.19.2.0/24", "172.19.3.0/24"]
}

variable "public_subs" {
  type    = list(string)
  default = ["172.19.4.0/24", "172.19.5.0/24", "172.19.6.0/24"]
}

// Kubernetes version
variable "cluster_version" {
  default = "1.15"
}

// Domain to add dns entries
variable "ingress_domain_name_suffix" {
  default = ""
}

// ACM certificate
variable "public_ingress_arn" {
  default = ""
}

// DNS zone type (public or private)
variable "dns_zone_type" {
  default = "public"
}

// DNS helm chart version
variable "helm_dns_version" {
  default = "2.20.3"
}

// Ingress helm chart version
variable "helm_ingress_version" {
  default = "1.34.2"
}
