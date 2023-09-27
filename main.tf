terraform {
    #backend "remote {
        #hostname = "app.terraform.io"
       # organiztion = "Terraform-bootcamp-2023"
        
        #workspace {
          #  name ="terra-house-1"
      #  }
  #  }"

#cloud {
 #  organization = "Terraform-bootcamp-2023"

 #   workspaces {
  #    name = "Terra-house-1"
   # }
 #}
 
}



module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid =var.user_uuid
    bucket_name = var.bucket_name

}