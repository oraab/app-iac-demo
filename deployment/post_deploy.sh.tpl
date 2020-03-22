#! /bin/bash 

# this script is used as a template for the launch configuration - it is run after the instance is created so that the server can be run

apt update
apt install htop docker.io awscli

aws ecr get-login --region us-east-1 --no-include-email | sh -

