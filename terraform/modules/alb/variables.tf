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

variable "vpc_cidr_block_first_octets" {
	description = "The first two octets required for the CIDR block of the VPC (CIDR block with 16 prefix will be extended)"
	type = string
	default = "172.20"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
}

variable "domain_name" {
	description = "The domain name for which a certificate was issued to allow HTTPS connection to the ALB"
	type = string
}