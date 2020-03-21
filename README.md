# app-iac-demo

Demo of IaC automated process for creation of app based on provided requirements. 
Performs the following: 

1. Creates infrastructure for deployment of app: VPC and subnets, ASG with launch configuration, ALB and target groups based on the separate requirements for staging and production.
1. provides a build and deployment pipeline through `makefile` and `docker push/pull` to/from ECR.  The deployment is done through template on the launch configurations which runs a post deploy script that pulls the docker image from ECR and runs it, deploying a small web server (as demo, can be replaced by anything with `Dockerfile`).  The launch configuration and ASG are set up to change and be recreated with every deployment. 

## pre-requisites 
1. *AWS IAM user* that has the relevant permissions to create resources for this app.  A user can be created for you when you run `create_aws_user.sh` from the root, but it also assumes that you have an AWS IAM user with relevant credentials on your machine that can create a user with relevant permissions on IAM.
1. *`docker` and `amazon-ecr-credential-helper`*: docker is required to maintain this build/deploy pipeline.  It is not installed automatically with the init script because of too much special snowflakery in the `brew install` process. The `amazon-ecr-credential-helper` will be installed for you using the init script, but some manual action will need to be done on the docker `config.json` before continuing with the initialization. The script will prompt you, and also see [https://github.com/awslabs/amazon-ecr-credential-helper#configuration] for more information.
1. *`terraform` and `awscli`*: the init script will install these for you if you don't have them. 
1. *The name of the required state bucket and state table lock should be set up in the env vars `TF_VAR_tf_state_bucket` and `TF_VAR_tf_state_lock` (see example below), respectively.  The init script will check if they exist (and will create the bucket and table lock for you) and will fail if they don't exist.  These are not added automatically so as not to mess with your shell profile.
1. A registered domain which an ACM certificate can be issued for. 

save these to your profile (e.g. `bash_profile`) and run `source ~/.bash_profile` (or the relevant equivalent) to set the vars globally: 

```
export TF_VAR_tf_state_bucket=<the name you want to call the terraform state bucket>
export TF_VAR_tf_state_lock=<the name you want to call the dynamodb lock table>
```

## initialization 
1. `init.sh` - this script will verify you have the releant binaries and install them (or warn you and die) if not.
1. `cd deployment; make build-infra` - this will build the ECR repo and will issue an ACM certificate for the registered domain you've chosen. This will also build the infra for the application with a demo application. 

## deployment
`cd deployment; make deploy-<environment> APP_NAME=<give a name to the application - this is only for the docker image> ECR_REPO=<ecr repo - available to you as env var REPOSITORY_URL after running make build-infra>`

## testing harness (for terraform)
`cd deployment; make test-infra`

## future improvements  
1. CI/CD through Github Actions 



