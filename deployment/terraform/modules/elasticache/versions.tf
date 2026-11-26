terraform {
  # The variable validation blocks in this module reference other variables,
  # which Terraform only supports from 1.9 onwards.
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
