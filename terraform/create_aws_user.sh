#! /bin/sh 

requested_user_name=$1

if [ $requested_user_name ]
then
  export TF_VAR_user_name=$requested_user_name
else 
  export TF_VAR_user_name="iam-demo-runner"
fi
echo "${TF_VAR_user_name}"

get_user_response=$(aws iam get-user --user-name $TF_VAR_user_name 2>&1)
if [[ $get_user_response == *"NoSuchEntity"* ]]
then 
  echo "creating user.";
  cd live/global/iam/;
  terraform init;
  echo "running terraform plan to verify resources creation";
  if [[ $(terraform plan) == *"10 to add, 0 to change, 0 to destroy"* ]]
  then
    echo "terraform plan succeeded, continuing to apply."; 
    terraform apply
  else 
    echo "errors in terraform plan - halting user creation script.";
    exit 1
  fi
elif [[ $get_user_response == *"AccessDenied"* ]]
then 
  echo "the IAM user that is currently configured does not have permissions to create other users - please verify and rerun."
else 
  echo "user already exists; not recreating."
fi

echo "now that your user has been created, log in to the console, retrieve the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY and cofigure them to be used when running Terraform configurations."

