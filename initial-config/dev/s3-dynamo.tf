provider "aws" {
  region = "eu-west-1"
  profile = "dev"
}

locals {
  terra_bucket = "valassis-terraform-state-dev"
  terra_dynamo = "valassis-terraform-lock-dev"
}

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "s3_bucket" {
    bucket = local.terra_bucket

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }

    tags = {
      Name = "${local.terra_bucket}"
    }
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "db_lock" {
  name = local.terra_dynamo
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${local.terra_dynamo}"
  }
}
