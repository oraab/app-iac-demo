provider "aws" {
	region = "us-east-1" 
}

terraform {
    # backend values will be provided from BackendConfig
	backend "s3" {}
}