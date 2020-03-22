variable "environment" {
	description = "The environment within which the application is created"
	type = string
	default = "staging"
}

variable "ami" {
	description = "The AMI that should be deployed to the application's instances"
	type = string
}

variable "instance_type" {
	description = "The instance type for the instances of the application" 
	type = string
	default = "t2.micro"
}

variable "min_size" {
  description = "The minimum number of instances within the ASG of the application"
  type = number
}

variable "max_size" {
	description = "The maximum number of instances within the ASG of the application"
	type = number
}

variable "user_data" {
	description = "The information provided for the server within the application" 
	type = string
}

variable "internal" {
	description = "True indicates that the ALB created for this application will receive only internal requests from ingress specified IPs"
	type = bool
	default = false
}

variable "domain_name" {
	description = "The domain name for which a certificate is issued to provide HTTPS connection to the ALB."
	type = string
	default = "testing-placeholder.xyz"
}

variable "ingress_cidr_block" {
	description = "The ingress IP or CIDR block that is restricted to access the internal application - will only be used if internal is set to true"
	type = string
	default = "0.0.0.0/0"
}

variable "vpc_cidr_block_first_octets" {
	description = "The first two octets required for the VPC's CIDR block - the remaining CIDR block and the prefix (16) will be extended."
	type = string
	default = "172.20"
}

variable "role_name" {
	description = "The prefix for the name of the assume role and instance profile for the launch configuration" 
	type = string 
	default = "launch_configuration"
}