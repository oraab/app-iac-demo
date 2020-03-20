variable "vpc_cidr_block" {
	description = "The required CIDR block for the VPC (prefix will be 16, no need to add it)"
	type = string
	default = "10.0.0.0"
}

variable "main_subnet_cidr_block" {
	description = "The required CIDR block for the main subnet within the VPC (prefix will be 24, no need to add it)" 
	type = string
	# the 10.0.1.0/32 IP address would be used by default as the DNS resolver, locking the third octet at 2 to avoid collisions
	default = "10.0.2.0"
}

variable "alternate_az_subnet_cidr_block" {
	description = "The required CIDR block for the alternate AZ subnet within the VPC (prefix will be 24, no need to add it)" 
	type = string
	# the 10.0.1.0/32 IP address would be used by default as the DNS resolver, locking the third octet at 3 to avoid collisions
	default = "10.0.3.0"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
}

variable "environment" {
	description = "The environment within which the VPC will be created"
	type = string
}