module "vpc" {
  source              = "terraform-aws-modules/vpc/aws"

  name                = "${var.cluster_name}"
  cidr                = "${var.cidr}"

  azs                 = "${var.availability_zones}"
  private_subnets     = "${var.private_subs}"
  public_subnets      = "${var.public_subs}"

  enable_nat_gateway  = true
  single_nat_gateway  = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform         = "true"
    KubernetesCluster = "${var.cluster_name}"
    Environment       = "${var.environment}"
  }

  vpc_tags = {
     Name                             = "${var.cluster_name}"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
     Name                             = "private-${var.cluster_name}"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb"          = "1"
     Name                             = "public-${var.cluster_name}"
  }
}
