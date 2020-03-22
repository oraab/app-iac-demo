variable "role_name" {
	description = "The prefix for the role name of the role and instance profile that will be created for the launch configuration" 
	type = string 
	default = "launch_configuration"
}

variable "environment" {
	description = "The environment within which the ASG resources should be created - used to avoid name collision"
	type = string
	default = "staging"
}