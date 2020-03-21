provider "aws" {
	region = "us-east-1"

	version = "~> 2.0"
}

terraform {
    # backend values will be provided from BackendConfig
	backend "s3" {}
}