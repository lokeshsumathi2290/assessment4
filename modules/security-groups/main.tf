resource "aws_security_group" "worker-node" {
  name        = "${var.cluster_name}-custom-eks-${var.random_string}"
  description = "Security group for all worker nodes in the cluster"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.cluster_name}-custom-eks"
    Environment  = "${var.environment}"
    Terraform  = "true"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker-node.id
  source_security_group_id = aws_security_group.worker-node.id
  to_port                  = 65535
  type                     = "ingress"
}
