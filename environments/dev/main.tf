provider "aws" {
  region = "eu-west-1"
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket         = "valassis-terraform-state-dev"
    key            = "dev"
    dynamodb_table = "valassis-terraform-lock-dev"
    region         = "eu-west-1"
  }
}

locals {
  environment = "dev"
}

module "eks" {
   source                 = "../../modules/eks"

   cidr                   = "${var.cidr}"
   availability_zones     = "${var.availability_zones}"
   private_subs           = "${var.private_subs}"
   public_subs            = "${var.public_subs}"
   cluster_name           = "${local.environment}-eks"
   cluster_version        = "${var.cluster_version}"
   environment            = "${local.environment}"
   instance_type          = "${var.instance_type}"
   asg_desired_capacity   = "${var.asg_desired_capacity}"
   asg_max_size           = "${var.asg_max_size}"
}

data "aws_eks_cluster" "working_cluster" {
  name = "${module.eks.cluster_id}"
}

data "aws_eks_cluster_auth" "working_cluster" {
  name = "${module.eks.cluster_id}"
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.working_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.working_cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.working_cluster.token
    load_config_file       = false
  }
}

module "helm" {
   source                         = "../../modules/helm"

   ingress_domain_name_suffix     = "${var.ingress_domain_name_suffix}"
   iam_role_arn                   = "${module.eks.custom_worker_iam_role_arn}"
   public_ingress_arn             = "${var.public_ingress_arn}"
   dns_zone_type                  = "${var.dns_zone_type}"
   helm_dns_version               = "${var.helm_dns_version}"
   helm_ingress_version           = "${var.helm_ingress_version}"
   kubernetes_namespace_dns       = "${module.eks.kubernetes_namespace_dns}"
   kubernetes_namespace_ingress   = "${module.eks.kubernetes_namespace_ingress}"

}
