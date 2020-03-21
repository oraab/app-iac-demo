provider "aws" {
	region = "us-east-1"

	version = "~> 2.0"
}

terraform {
	required_version = ">= 0.12, < 0.13"

    # backend values provided from BackendConfig
	backend "s3" {}
}