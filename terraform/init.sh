#! /bin/sh 

# this script verifies and/or initializes everything the local environment expects in order to run the automated processes to generate the infrastructure, testing harness and deployment pipeline

# verify terraform is installed and install if not 
if [[ $(terraform) == *"init"* ]]
then 
  echo "terraform installed on host; moving on."
else
  echo "terraform not installed on host - installing."
  brew update && brew install terraform 
fi

# verify aws CLI is intalled and install if not 
if [[ $(aws --version) == *"aws-cli"* ]]
then
  echo "aws cli installed on host; moving on."
else 
  echo "aws cli not installed on host - installing."
  if [[ $(python --version) == *"2.7"* ]]
    brew update && brew install awscli
  else 
    echo "host does not have correct version of python for AWS CLI - halting script, please install manually."
    exit 1
fi

# create the env variables required by terraform to set up the state bucket and lock mechanism
curr_date=$(date "+%Y-%m-%d")
if [ -z "$TF_VAR_tf_state_bucket" ]
then
  echo "environment variable for state bucket not set - setting default."
  export TF_VAR_tf_state_bucket="app-iac-demo-state-${curr_date}";
fi

if [ -z "$TF_VAR_tf_state_lock" ]
then
  echo "enviornment variable for state lock not set - setting default."
  export TF_VAR_tf_state_lock="app-iac-demo-lock-${curr_date}";
fi

# applying bucket and table lock resources to AWS
echo "initializing terraform state (this will take a while if you don't have the AWS provider installed yet)"
cd live/global/s3/
terraform init 
echo "running terraform plan to verify resources creation"
if [[ $(terraform plan) == *"Plan: 2 to add, 0 to change, 0 to destroy"* ]]
then
  echo "terraform plan succeeded, continuing to apply." 
  terraform apply
else 
  echo "errors in terraform plan - halting init script."
  exit 1
fi  
  
