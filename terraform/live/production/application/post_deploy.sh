#! /bin/bash 

# this script is used as a template for the launch configuration - it is run after the instance is created so that the server can be run

sudo apt update
sudo apt install htop docker.io awscli

aws ecr get-login --region us-east-1 --no-include-email | sudo sh -

sudo docker pull ${ecr_repo}/${image_tag}

sudo docker run -p 8080:8080 ${ecr_repo}/${image_tag}