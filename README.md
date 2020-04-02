# Terraform for AWS EKS

We use Terraform to create new EKS from scratch.

## What Does the Code DO

* Create a new VPC
* Create a new AWS EKS cluster
* Generate Kube config for the cluster
* Install external-dns Helm chart
* Create External Ingress
* Create Internal Ingress

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
* Valid ACM certificate in that region

## How to setup a new environment:

* Navigate to cloned repo

* Run this create_new_env_files.sh like below
```
./create_new_env_files.sh dev eu-west-1
```
  * where dev is the new clusters environment name
  * where eu-west-1 is the region for the EKS cluster to be created

* Edit profile name in   initial-config/{env}/s3-dynamo.tf file . Add the AWS profile name eg: dev or prod with respect to ~/.aws/credentials file
```
provider "aws" {
  region = "eu-west-1"
  profile = ""
}
```

* Navigate to newly created initial config directory  and run below commands one by one

```
cd initial-config/{env}
terraform init
terraform plan
terraform apply
```

* Edit  environments/{env}/vars.tf and fill in all details required for creating a new environment .

* Navigate to newly created environment directory and run below commands one by one
```
cd environments/{env}
terraform init
terraform plan
terraform apply
```
The job will complete within 20 min

* After successful run we should find a file named “kubeconfig_dev-eks“ in present working directory. Copy the file to (~/.kube/config)
```
cp kubeconfig_dev-eks ~/.kube/config
```
