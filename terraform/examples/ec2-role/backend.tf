provider "aws" {
	region = "us-east-1"

	version = "~> 2.0"
}

terraform {
    # backend values will be provided through BackendConfig
	backend "s3" {}
}