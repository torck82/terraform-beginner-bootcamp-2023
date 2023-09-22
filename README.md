# Terraform Beginner Bootcamp 2023

## Semantic Versioning :mage:

This project is going to utilize semantic versioning for its tagging.
[senver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instruction have changed due to gpg keyring changes. So we needed refer to the latest install cli instructions via Terrfaform Documentation and change the scripting for install.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)


### Consideration for Linux distribution

This project is built against Ubuntu
Please consider checking your Linux Distribution and change 
accordingly to disbtribution needs.

[How to Check OS version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version.
```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
gitpod /workspace/terrafor
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI pgp depreciation issue we notice that bash scripts steps a considerable amount more code. So we decided to create a bash script to install the Terraform CLI.

This bash script is located here [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml].gitpod.yaml) tidy.
- This allow us an easier to debug and execute manually Terraform CLI install
- This will allow better portablity for other projects that need to install Terrfaform CLI.

### Shebang Considerations

A Shebang (pronouced sha-bang) tells the bash script what program that will interpret the scripts. eg.

ChatGPT recommended this format for bash `#!/usr/bin/env bash`

- for portability  for different OS distributions
- will search the user's PATH for the bash executable 

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execite the bash script.

eg. `./bin/install_ terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_ terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```


https://en.wikipedia.org/wiki/Chmod

### Github Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working  Env Vars

We can list out all Enviroment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS__`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world'`

In the terminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command wehn just running a command

```sh
HELLO='word' ./bin/print_message
```
Within a bash script we can set env var without writing export eg.

```sh
`./usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open up new bash terminals in VScode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

ALL future workspaces launched will set the env vars for all bash terminals opend in those workspaces

You can also set en vars in the `.gitpod.yml` but this can only contain non-senstive env vars.

### AWS CLI Installation

AWS CLI is installed for this project via bash script [`./bin/install_aws_cli'](./bin/install_awscli)


[Getting Started install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is successful you should see a json payload return that looks like this:

```json
{
    "UserId": "RHDAJOIH3JUC987Y3L5Y",
    "Account": "000000000000",
    "Arn": "arn:aws:iam::030618111236:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credential from IAM user in order to use the AWS CLI

# Terraform Basics

### Terraform Registry

Terraform source their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in Terraform [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

- **Modules** are a way to refactor large amount of terraform code modular, portable and sharable.

### Terraform Console

We can see a list of all the Terraform command by simply typing 'terraform'

#### Terraform Init

At the start of a new terraform project we will run 'terraform init' to download the binaries for the terraform providers that we'll use in this project


#### Terraform Plan

`terraform plan``

This will generate out a changeset, about the state of our infrastructure and what will be changed

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outpitting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by Terraform. Apply should prompt us yes or no.

If we want to automatically approve an apply we can provide the auto approve flag `terraform apply --auto-approve`

#### Terraform Destory

`terraform destroyed`
This will destroy resources 

You can also write `terraform destroy --auto-approve` to skip the Prompt 

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock file **should be committed** to your Version COntrol System (VSC) eg. Github

#### Terraform State Files

`.terraform.tfstate` contain information about the current state of your infrastructure.

This File ** should not be commited** to your VCS

This file can contain sensitive data.

if you lose this file, you lose knowning the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terrfaform` directory contains binaries of terraform providers

## Issue with Terraform cloud login and Gitpod Workspace

When attemping to run `terraform login` it will launch bash a wiswig view to generate a token. However it does not work expected in Gitpod VsCode in the browser.

The workaround is to manually generate a token in Terraform Cloud

```
https://app.terraform.io/app/settings/tokens?source=terraform-login

```

Then create and open the file manually here: 

```sh

touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json

```
Provide the following code (replace your token in the file):

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "your-terraform-cloud-api-token"
    }
  }
}
```
We have automated this workaround with the following bash script [bin/generate_tfcc/credentials](bin/generate_tfrc_credentials)
