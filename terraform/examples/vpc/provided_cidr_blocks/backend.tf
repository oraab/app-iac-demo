provider "aws" {
	region = "us-east-1" 

	version = "~> 2.0"
}

terraform {
    # backend config values provided from BackendConfig
	backend "s3" {}
}