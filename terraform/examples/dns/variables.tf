variable "domain_name" {
	description = "The domain name for which the Route53 zone is created"
	type = string 
	default = "app-iac-demo.tf.testing.com"
}