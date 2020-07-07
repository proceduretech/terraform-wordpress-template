# Configuration Variables
variable "region" {
  description = "Region that the resources will be created"
}

variable "access-key" {
  description = "AWS access-key to be used by terraform"
}

variable "secret-key" {
  description = "AWS secret-key to be used by terraform"
}


variable "environment" {
  description = "Environment for the resources"
}

variable "organisation" {
  description = "Organisation name"
}

variable "domain" {
  description = "Domain"
}

variable "profile" {
  description = "Profile"
}

variable "project_name" {
  description = "Project name"
}

variable "state_bucket" {
  description = "S3 bucket name of terraform state"
}