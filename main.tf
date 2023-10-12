terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
   # backend "remote {
       # hostname = "app.terraform.io"
       # organiztion = "Terraform-bootcamp-2023"
        
       # workspace {
            #name ="terra-house-1"
      #  }
  #  }"

cloud {
   organization = "Terraform-bootcamp-2023"

    workspaces {
     name = "Terra-house-1"
    }
 }
 
}

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}


 module "home_arcanum_hosting" {
    source = "./modules/terrahome_aws"
    user_uuid = var.teacherseat_user_uuid
    public_path = var.arcanum.public_path
    content_version = var.arcanum.content_version

 }

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023!"
  description = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with alot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  domain_name = module.home_arcanum_hosting.domain_name
  town = "missingo"
  content_version = var.arcanum.content_version
}

  module "home_gaming_hosting" {
    source = "./modules/terrahome_aws"
    user_uuid = var.teacherseat_user_uuid
    public_path = var.gaming.public_path
    content_version = var.gaming.content_version
    

 }

resource "terratowns_home" "home_gaming" {
  name = "I'm keeping it simple!"
  description = <<DESCRIPTION
I don't have much time to spend on this bootcamp so, I'm going to keep it simple. Don't judge me!!!
DESCRIPTION
  #domain_name = module.home_gaming.domain_name
  domain_name = module.home_gaming_hosting.domain_name
  town = "gamers-grotto"
  content_version = 1
} 