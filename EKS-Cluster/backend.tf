terraform {
  backend "s3" {
    bucket = "cicd-terraform-eks" # replace with existing s3-bucket
    key = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}