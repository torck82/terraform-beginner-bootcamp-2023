## Terrahouse AWS


```tf
    module "Home_arcanum" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherseat_user_uuid
    public_path = var.arcanum_public_path
    content_version = var.content_version
    }
 ```

 The public directory expects the following:

- index.html
- error.html
- assets

All top level files in assets will be copied, but not any subdirectories.