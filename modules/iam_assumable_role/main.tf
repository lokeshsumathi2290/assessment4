module "iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "~> 2.0"

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  create_role = true
  create_instance_profile	= true

  role_name         = "${var.cluster_name}-custom-role-${var.random_string}"
  role_requires_mfa = false

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
  ]
}
