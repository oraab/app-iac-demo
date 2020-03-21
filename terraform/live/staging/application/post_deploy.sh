#! /bin/bash 

sudo apt-get install htop tcpdump 

sudo apt-get install awscli 

aws ecr get-login-password | docker login --username AWS --password-stdin ${ecr_repo}

docker pull ${ecr_repo}/${image_tag}

docker run -p 8080:8080 ${ecr_repo}/${image_tag}