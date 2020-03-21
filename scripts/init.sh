#! /bin/sh 

# this script verifies and/or initializes everything the local environment expects in order to run the automated processes to generate the infrastructure, testing harness and deployment pipeline

SCRIPT_HOME=$(pwd)

# verify docker is installed and fail if not
if [[ $(docker) == *"command not found"* ]]
then
  echo "docker not installed on host and cannot be installed with homebrew - halting script.";
  exit 1
fi

if [[ $(less $HOME/.docker/config.json | grep "ecr-login") == *"ecr-login"* ]]
then
  echo "amazon-ecr-credential-helper installed on host; moving on."
else 
  echo "amazon-ecr-credential-helper not installed on host - installing."
  brew update && brew install docker-credential-helper-ecr
  echo "docker-credential-helper-ecr installed on host - note that this will require an additional config change that will need to be done manually. \
        switch `credStore` in your docker `config.json` file to `ecr-login`.  Additionally you can add specific repo login credHelpers as indicated \
        here: https://github.com/awslabs/amazon-ecr-credential-helper#Configuration.  Then run this script again."
  exit 1;
fi

# verify terraform is installed and install if not 
if [[ $(terraform) == *"init"* ]]
then 
  echo "terraform installed on host; moving on."
else
  echo "terraform not installed on host - installing.";
  brew update && brew install terraform 
  cat "plugin_cache_dir   = \"$HOME/.terraform.d/plugin-cache\"" > $HOME/.terraformrc
  cat "disable_checkpoint = true" >> $HOME/.terraformrc
fi


# verify aws CLI is intalled and install if not 
if [[ $(aws --version) == *"aws-cli"* ]]
then
  echo "aws cli installed on host; moving on."
else 
  echo "aws cli not installed on host - installing."
  if [[ $(python --version) == *"2.7"* ]]
  then
    brew update && brew install awscli
  else 
    echo "host does not have correct version of python for AWS CLI - halting script, please install manually."
    exit 1
  fi
fi

# verify go is installed and install if not
if [[ $(go 2>&1) == *"command not found"* ]]
then 
  echo "go not installed on host - installing."
  brew update && brew install go 
else 
  echo "go installed on host; moving on."
fi

# create keypair for the application instances 
cd $HOME/.ssh/
PUBKEY=$(pwd)/app_iac_demo_key.pem.pub
if [ -z ${PUBKEY} ]
then
  echo "generating key pair for EC2 instances"
  ssh-keygen -t rsa -C app_iac_demo_key -f app_iac_demo_key.pem
  aws ec2 import-key-pair --key_name app_iac_demo_key --public_key_material $(cat ${PUBKEY} | base64)
else 
  echo "key pair already exists - moving on."
fi

# verify the env variables required for the state bucket and state lock
if [ -z "$TF_VAR_tf_state_bucket" ]
then
  echo "environment variable for state bucket not set - halting script. Please set manually (preferably in your shell config file).";
  exit 1
fi

if [ -z "$TF_VAR_tf_state_lock" ]
then
  echo "enviornment variable for state lock not set - halting script. Please set manually (preferably in your shell config file).";
  exit 1
fi

# applying bucket and table lock resources to AWS
if [[ $(aws s3api head-bucket --bucket $TF_VAR_tf_state_bucket) == *"200 OK"* ]]
then 
  echo "state bucket already exists; moving on."
else 
  echo "initializing terraform state (this will take a while if you don't have the AWS provider installed yet)";
  cd $SCRIPT_HOME/../terraform/live/global/s3/;
  terraform init;
  echo "running terraform plan to verify resources creation";
  if [[ $(terraform plan) == *"2 to add, 0 to change, 0 to destroy"* ]]
  then
    echo "terraform plan succeeded, continuing to apply."; 
    terraform apply
  else 
    echo "errors in terraform plan - halting init script.";
    exit 1
  fi
fi

  
