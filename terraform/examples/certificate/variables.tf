variable "domain_name" {
	description = "The domain name for which the certificate is created"
	type = string
}

variable "environment" {
	description = "The environment within which the ACM certificate should be created"
	type = string
	default = "staging"
}
