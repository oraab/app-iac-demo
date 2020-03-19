# app-iac-demo

demo of IaC automated process for creation of app based on provided requirements. 

## initialization 
The following assumptions are made about your system when initializing and running this process to create the infrastructure and CI/CD pipelines for an app: 

1. You have an AWS IAM user that has the relevant permissions to create resources for this app.  If you don't, you can run `scripts/create_aws_user.sh` in order to create that user. Note that you will obviously need an AWS IAM user with permissions to create that resource using terraform, and will then need to retrieve the user's `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` and store them as env vars before generating the required resources. 
1. You have `terraform` and `awscli` installed on your computer.  For Mac OS, you can run `scripts/init.sh` which will verify you do and/or install these for you using `homebrew`.
1. You have the names of the state bucket and state table lock set up as env vars in `TF_VAR_tf_state_bucket` and `TF_VAR_tf_state_lock`.  `scripts/init.sh` will verify they exist and will fail if they don't. It will not set them automatically in order to avoid messing with users' shell config files for global env persistence.

