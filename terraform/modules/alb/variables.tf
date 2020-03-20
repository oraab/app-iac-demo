variable "name" {
  description = "The name of the ALB and its resources" 
  type = string 
}

variable "internal" {
  description = "Is the ALB internal or internet facing? (optional - default=false)"
  type = bool 
  default = false 
}

variable "environment" {
	description = "The environment within which the ALB is created"
	type = string
}

variable "ingress_cidr_block" {
	description = "A CIDR block from which the ALB will receive incoming traffic over HTTP port (optional - will not be used if the internal variable is not set)"
	type = string 
	default = "0.0.0.0/0"
}

variable "vpc_cidr_block" {
	description = "The required CIDR block for the VPC (prefix will be 16, no need to add it)"
	type = string
	default = "10.0.0.0"
}

variable "main_subnet_cidr_block" {
	description = "The required CIDR block for the main subnet within the VPC (prefix will be 24, no need to add it)" 
	type = string
	default = "10.0.1.0"
}

variable "alternate_az_subnet_cidr_block" {
	description = "The required CIDR block for the alternate AZ subnet within the VPC (prefix will be 24, no need to add it)"
	type = string
	default = "10.0.2.0"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
}