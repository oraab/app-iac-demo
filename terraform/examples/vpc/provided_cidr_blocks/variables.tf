# all variables provided here with defaults so that tests can run with different values if required 

variable "vpc_cidr_block" {
	description = "The required CIDR block for the VPC (prefix will be 16, no need to add it)"
	type = string
	default = "10.2.0.0"
}

variable "main_subnet_cidr_block" {
	description = "The required CIDR block for the main subnet within the VPC (prefix will be 24, no need to add it)" 
	type = string
	default = "10.2.30.0"
}

variable "alternate_az_subnet_cidr_block" {
	description = "The required CIDR block for the alternate AZ subnet within the VPC (prefix will be 24, no need to add it)" 
	type = string
	default = "10.2.40.0"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
	default = "test_vpc_name"
}

variable "environment" {
	description = "Environment within which the VPC will be created - used in conjunction with vpc_name for uniqueness"
	type = string
	default = "staging"
}