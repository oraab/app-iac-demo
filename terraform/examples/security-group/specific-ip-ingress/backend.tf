provider "aws" {
	region = "us-east-1" 

	version = "~> 2.0"
}

terraform {
    # provided from backend-config for reproducability
	backend "s3" {}
}