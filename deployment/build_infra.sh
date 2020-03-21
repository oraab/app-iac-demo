#! /bin/sh

if [ -z $1 ]
then
	echo "./build_infra [environment] [domain_name]";
    exit 1
fi 

environment=$1
domain_name=$2

root_dir=$(pwd)

# checking if ECR repo exists and creating if not
if [[ $(aws ecr list-images --repository-name ${environment}-images 2>&1) == *"does not exist"* ]]
then 
  echo "ECR repo does not exist - creating.";
  cd ${root_dir}/../terraform/live/${environment}/ecr/
  terraform init -upgrade=false \
    -backend-config=bucket=${TF_VAR_tf_state_bucket} \
    -backend-config=key=${environment}/ecr/terraform.tfstate \
    -backend-config=region=us-east-1 \
    -backend-config=dynamodb_table=${TF_VAR_tf_state_lock} \
    -backend-config=encrypt=true
  if [[ $(terraform plan) == *"1 to add, 0 to change, 0 to destroy"* ]]
  then
    echo "terraform plan succeeded, continuing to apply."; 
    terraform apply -auto-approve
  else 
    echo "errors in terraform plan - halting init script.";
    exit 1
  fi
else 
  echo "ECR repo already exists - moving on."
fi

repository_url=$(terraform output repository_url)
export REPOSITORY_URL=$repository_url 
echo "Repository URL: ${REPOSITORY_URL}"

# checking if certificate for HTTPS connection ecists and creating if not
if [[ $(aws acm list-certificates) == *"${domain_name}"* ]]
then 
  echo "certificate for domain ${domain_name} exists - moving on."
else 
  echo "certificate for domain ${domain_name} does not exist - creating.";
  cd ${root_dir}/../terraform/live/${environment}/certificate/
  terraform init -upgrade=false \
    -backend-config=bucket=${TF_VAR_tf_state_bucket} \
    -backend-config=key=${environment}/certificate/terraform.tfstate \
    -backend-config=region=us-east-1 \
    -backend-config=dynamodb_table=${TF_VAR_tf_state_lock} \
    -backend-config=encrypt=true
  if [[ $(terraform plan) == *"4 to add, 0 to change, 0 to destroy"* ]]
  then
    echo "terraform plan succeeded, continuing to apply."; 
    terraform apply -auto-approve
  else 
    echo "errors in terraform plan - halting init script.";
    exit 1
  fi
fi

# running the application infra for the environment
echo "creating the application infra for environment ${environment} using the demo application"
cd ${root_dir}/../terraform/live/${environment}/application/
terraform init -upgrade=false \
    -backend-config=bucket=${TF_VAR_tf_state_bucket} \
    -backend-config=key=${environment}/application/terraform.tfstate \
    -backend-config=region=us-east-1 \
    -backend-config=dynamodb_table=${TF_VAR_tf_state_lock} \
    -backend-config=encrypt=true
if [[ $(terraform plan) == *"29 to add, 0 to change, 0 to destroy"* ]]
then
  echo "terraform plan succeeded, continuing to apply."; 
  terraform apply -auto-approve
else 
  echo "errors in terraform plan - halting init script.";
  exit 1
fi 
