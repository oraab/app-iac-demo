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

variable "internal" {
	description = "True indicates that the ALB created by this application will only receive internal traffic from ingress specified IPs"
	type = bool
	default = false
}