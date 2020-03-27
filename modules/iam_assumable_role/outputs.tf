output "custom_worker_iam_profile_name" {
  value       = "${module.iam_assumable_role.this_iam_instance_profile_name}"
}

output "custom_worker_iam_role_arn" {
  value       = "${module.iam_assumable_role.this_iam_role_arn}"
}
