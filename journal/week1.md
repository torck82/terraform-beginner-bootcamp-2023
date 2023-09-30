# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to delete local and remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

locally delete a tag
```
git tag -d <tag_name>
```
Remote delete a tag
```
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git chechout <sha>
get tag M.M.P
git push --tags
git checkout main
```

## Root Module Structure

Our root module structure is as follows:

```
PROJECT_ROOT
|
|-- main.tf                # everything else
|-- variables.tf            # stores the structure of input variables
|-- terraform.tfvars       # the data of variables we want to load into our terraform project
|-- providers.tf           # defines required providers and their configuration
|-- outputs.tf             # store our outputs
|-- README.md              # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables
### Terraform Cloud Variables

In Terraform we can set two kinds of variables"
- Emviroment Variables - those you set in your bash terminal eg. AWS credentials 
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they care not shown visibly in the UI


### Loading Terraform Input Variables
[Terraform input variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Var Flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_ID"`


### Var-file flag

- TODO: document this flag 

### terraform.tfvars

This is the default file to load in terraform variables in bulk 

### auto.tfvars

- TODO: document this flag funcionality for terraform cloud

### order of terraform variables 

- TODO: Document which terraform variables takes precedence

## Dealing with Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likly have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resouces. You need to check the terraform providers documentation for which resources supoort import.
### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`


[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through clickOps.

If we run terraform plan again it will attemp to put our infrastructure back into the expected state fixing 
Configuration Drift 

## fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally
developing modules but can name it whatever you like

## Passing Input Variables


We can pass input variables to our modules
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid =var.user_uuid
    bucket_name = var.bucket.name

}
```

### Module Sources

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

Using the source we can import the modules from various places eg: 
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
   
}
```

## Consideration when using ChatGPT to write Terraform

LLMs such as Chatgpt may not be trained on the lasted documenation or information about terraform

It may likely produce older example that could be deprecate. Often affecting providers.

## Working with files in Terraform

### Filee xists function

This is to check if the file exist

```tf
variable "error_html_filepath" {
  description = "Path to the error.html file"
  type        = string
}
    validation {
    condition     = fileexists(var.error_html_filepath)
    error_message = "The specified error.html path is not valid or the file does not exist."
  
}
```
[Filexists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### FileMD5

Check if the file changed and update the file

[check if the file changed](https://developer.hashicorp.com/terraform/language/functions/md5)


### Path Variable

In terraform there is a special vaiable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root of the project
[Speical Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references)

```tf
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "index.html"
  source = ${path.root}/public/index.html

}
```

## Terraform Locals

Locals allows us to define local variables.
It can be very useful when we need to transform data into another format and have it referenced as a variable

[local values](https://developer.hashicorp.com/terraform/language/values/locals)

### Terraform Data Source

This allow use to source data from cloud resources.

This is useful when we want to reference cloud resources without inporting them.


```tf
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Data Source](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON
 

 ```tf
 > jsonencode({"hello"="world"})
{"hello":"world"}
```
 []jasonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

 ### Chaning the lifecycle of Resources

 [Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)


 ## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

 [Terraform Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

 ## Provisioners

Provisioners allow you to execute commands 
on computer instances eg. a AWS CLI commands

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but functionality exists 
[Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
 ### Local-exec

 This will execute a command on the machine running the terraform commands eg plans apply

 ```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}

 ```
https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec

 ### Remote-exec

 This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine 


```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec

## For Each Expressions

For each allows us to enumerate over complex data types

```
[for s in var.list : upper(s)]
```
This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

[For +Each Expression](https://developer.hashicorp.com/terraform/language/expressions/for)