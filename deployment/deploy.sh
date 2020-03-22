#! /bin/sh 

environment=$1
ecr_repo=$2
tag_name=$3
domain_name=$4

# copying post_deploy script to the live folder (instead of multiple copies) so that there's only one source of truth for this script
cp post_deploy.sh.tpl rendered_post_deploy.sh
cat "docker pull ${ecr_repo}/${image_tag}" >> rendered_post_deploy.sh
cat "nohup docker run -p 8080:8080 ${ecr_repo}/${image_tag} &" >> rendered_post_deploy.sh
cp rendered_post_deploy.sh $(pwd)/../terraform/live/${environment}/application/
cd $(pwd)/../terraform/live/${environment}/application/

echo "Deploying application to ${environment}"
terraform init -upgrade=false \
   -backend-config=bucket=${TF_VAR_tf_state_bucket} \
   -backend-config=key=${environment}/application/terraform.tfstate \
   -backend-config=region=us-east-1 \
   -backend-config=dynamodb_table=${TF_VAR_tf_state_lock} \
   -backend-config=encrypt=true
# depending on changes made to the relevant environment's infrastructure we may have multiple permutations of resources added/changed/deleted.
#  we want to know that the terraform plan process reached the end, where it declares how many resources it's going to add
if [[ $(terraform plan -var 'ecr_repo=${ecr_repo}' -var 'image_tag=${tag_name}' -var 'domain_name=${domain_name}') == *"to add"* ]]
then
  echo "terraform plan succeeded, continuing to apply."; 
  terraform apply -auto-approve -var 'ecr_repo=${ecr_repo}' -var 'image_tag=${tag_name}' -var 'domain_name=${domain_name}'
else 
  echo "errors in terraform plan - halting deploy script.";
  exit 1
fi
