module "vpc" {
  source                 = "../../modules/vpc"

  availability_zones     = "${var.availability_zones}"
  cluster_name           = "${var.cluster_name}"
  private_subs           = "${var.private_subs}"
  public_subs            = "${var.public_subs}"
  environment            = "${var.environment}"
  cidr                   = "${var.cidr}"
}

resource "random_string" "random" {
  length = 16
  special = false
}

module "security_groups" {
  source                 = "../../modules/security-groups"

  cluster_name           = "${var.cluster_name}"
  vpc_id                 = "${module.vpc.vpc_id}"
  environment            = "${var.environment}"
  random_string          = "${random_string.random.result}"
}

locals {
  custom_sg_id = "${module.security_groups.aws_security_group_worker_node_id}"
}

module "iam_assumable_role" {
  source                 = "../../modules/iam_assumable_role"

  cluster_name           = "${var.cluster_name}"
  random_string          = "${random_string.random.result}"
}

data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "${var.cluster_name}"
  cluster_version = "${var.cluster_version}"
  subnets         = "${module.vpc.private_subnets}"
  vpc_id          = "${module.vpc.vpc_id}"
  tags = {
    Terraform         = "true"
    Environment       = "${var.environment}"
  }
  manage_worker_iam_resources = false

  worker_groups = [
    {
      instance_type = "${var.instance_type}"
      asg_max_size  = "${var.asg_max_size}"
      asg_desired_capacity  = "${var.asg_desired_capacity}"
      bootstrap_extra_args  = "--enable-docker-bridge true"
      additional_security_group_ids = [local.custom_sg_id]
      iam_instance_profile_name  = "${module.iam_assumable_role.custom_worker_iam_profile_name}"
    }
  ]
}

resource "null_resource" "before" {
}

resource "null_resource" "delay" {
  provisioner "local-exec" {
    command = "sleep 360"
  }
  triggers = {
    "before" = "${null_resource.before.id}"
  }
  depends_on = [module.my-cluster.workers_asg_arns]
}

resource "kubernetes_namespace" "dns" {
  metadata {
    annotations = {
      name = "dns"
    }

    labels = {
      Name = "dns"
      ENV  = "${var.environment}"
    }

    name = "dns"
  }
  timeouts {
    delete = "2h"
  }
  depends_on = [null_resource.delay]
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    annotations = {
      name = "ingress"
    }

    labels = {
      Name = "ingress"
      ENV  = "${var.environment}"
    }

    name = "ingress"
  }
  timeouts {
    delete = "2h"
  }
  depends_on = [null_resource.delay]
}
