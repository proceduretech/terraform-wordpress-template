# AWS Provider
provider "aws" {
  profile    = var.profile
  access_key = var.access-key
  secret_key = var.secret-key
  region     = var.region
}

resource "aws_s3_bucket" "tf_state_bucket" {
  bucket = var.state_bucket
  region = var.region

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Terraform Settings
terraform {
  backend "s3" {
    bucket = "state-bucket-name-sample"
    key    = "staging.tfstate"
    region = "ap-southeast-2"
  }
}


module "staging" {
  source = "./modules"
  environment = var.environment
  organisation = var.organisation
  region = var.region
  project_name = var.project_name
}