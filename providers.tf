terraform {

#cloud {
 #  organization = "Terraform-bootcamp-2023"

 #   workspaces {
  #    name = "Terra-house-1"
   # }
 #}
  required_providers {
     aws = {
      source = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}


provider "aws" {
  # Configuration options
}

provider "random" {
  # Configuration options
}