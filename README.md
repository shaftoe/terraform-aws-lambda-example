# AWS Lambda function with Terraform

Example of Terraform configuration that showcase a two-steps (Go `1.1x`) AWS Lambda function deployment

## Why two steps

The main reason is to avoid shipping the archive together with the configuration (that is, in Git). We only store the hash(es) of the last-built archive instead.

Might be useful when Terraform configuration is shared by multiple users.

## Usage

1. clone this repository and `cd` into its working directory
1. optional: edit `lambda/main.go`
1. run `make build` to create the build archive
1. setup your AWS environment (e.g. `export AWS_PROFILE=my-profile`)
1. run `terraform init`
1. run `terraform apply`: will prompt for

    - the bucket name to be created and used to host the build archive
    - the AWS region where the resources will be created

## TODOs

- complete README
- add links and references
- add pros and cons

[1]: <https://johnroach.io/2020/09/04/deploying-lambda-functions-with-terraform-just-dont/>
