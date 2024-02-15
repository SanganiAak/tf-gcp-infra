# tf-gcp-infra

## Infrastructure with Terraform

Prerequisites
Google Cloud Platform (GCP) account
Terraform installed on your local machine
gcloud CLI installed and configured on your local machine
Initial Setup
1. GCP Project
2. Enable APIs
3. Authentication
    `gcloud auth application-default login`
4. Terraform Variables
   check terraform variables in variables.tfvars file
   
## creation
    `terraform init`
    `terraform plan -var-file=variables.tfvars`
    `terraform apply -var-file=variables.tfvars`


# Destroy the Infrastructure

    `terraform destroy -var-file=variables.tfvars`


## Revoke authentication

`gcloud auth application-default revoke`