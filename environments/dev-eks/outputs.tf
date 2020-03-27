output "private_subnets_ids" {
  value = "${module.eks.private_subnets_ids}"
}

output "public_subnets_ids" {
  value = "${module.eks.public_subnets_ids}"
}

output "vpc-id" {
  value = "${module.eks.vpc-id}"
}

output "custom_worker_iam_role_arn" {
  value = "${module.eks.custom_worker_iam_role_arn}"
}

output "cluster_security_group_id" {
  value = "${module.eks.cluster_security_group_id}"
}

output "kubectl_config" {
  value = "${module.eks.kubectl_config}"
}
