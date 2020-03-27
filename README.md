# Terraform for AWS EKS

We use Terraform to create new EKS from scratch.

## Prequities
* Install terraform - v0.12.23 or above - https://learn.hashicorp.com/terraform/getting-started/install.html

* Install  aws-iam-authenticator - https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html

* AWS Credentials in below file

```
cat .aws/credentials

[default]
aws_access_key_id = XXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

[dev]
aws_access_key_id = XXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX

[prod]
aws_access_key_id = XXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

## How to setup a new environment:

* Navigate to below directory
```
cd terraform/initial-config
```

* Create a new directory with appropriate environment name and navigate inside it eg: prod
```
mkdir prod ; cd prod
```

* Copy “s3-dynamo.tf” file to new directory create before
```
cp ../dev/s3-dynamo.tf .
```

* Edit  “s3-dynamo.tf” file change the string “dev” in lines 3, 7 and 8 to our new environment name eg: prod
```
provider "aws" {
  region = "eu-west-1"
  profile = "prod"
}

locals {
  terra_bucket = "valassis-terraform-state-prod"
  terra_dynamo = "valassis-terraform-lock-prod"
}
```

* Navigate to below dir
```
cd terraform/environments/
```

* Create new directory with appropriate environment name and copy files as below from “dev-eks” directory
```
mkdir prod-eks
cp dev-eks/main.tf ; cp dev-eks/vars.tf; cp dev-eks/outputs.tf
cd prod-eks
```

* Edit  “vars.tf“ and fill in all details required for creating a new environment .

* Now we are ready to create new AWS EKS cluster with below commands
```
terraform init
terraform plan
terraform apply
```
The job will complete within 20 min

* After successful run we should find a file named “kubeconfig_dev-eks“ in present working directory. Copy the file to (~/.kube/config)
```
cp kubeconfig_dev-eks ~/.kube/config
```
