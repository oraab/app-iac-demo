variable "vpc_cidr_block_first_octets" {
	description = "The required first two octets for the CIDR block of the VPC (CIDR block will be extended to full representation with 16 prefix)"
	type = string
	default = "10.0"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
}

variable "environment" {
	description = "The environment within which the VPC will be created"
	type = string
}