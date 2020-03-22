#! /bin/bash 

# this script is used as a template for the launch configuration - it is run after the instance is created so that the server can be run

apt update
apt install htop docker.io awscli

aws ecr get-login --region us-east-1 --no-include-email | sh -

docker pull 644153620103.dkr.ecr.us-east-1.amazonaws.com/production-images:v20200322-021337-f0a6170

nohup docker run -p 8080:8080 644153620103.dkr.ecr.us-east-1.amazonaws.com/production-images:v20200322-021337-f0a6170 &