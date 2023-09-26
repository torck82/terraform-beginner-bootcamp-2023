# Terraform Beginner Bootcamp 2023 - Week 1

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

- TODO: document this flag funcionality for terraform cloud

### terraform.tfvars

This is the default file to load in terraform variables in blulk 

### auto.tfvars

- TODO: document this flag funcionality for terraform cloud

### order of terraform variables 

- TODO: Document which terraform variables takes precedence






