variable "name" {
	description = "The name of the ALB"
	type = string
	default = "alb-example"
}

variable "vpc_name" {
	description = "Unique identifier for the VPC - will be used alognside environment to prevent name colission"
	type = string
}

variable "internal" {
	description = "True for an ALB that would only have internal access through specific IP ingress rules" 
	type = bool
	default = false
}

variable "ingress_cidr_block" {
	description = "A CIDR block from which the ALB will receive traffic when set as internal - optional, will not be used if internal is set to false"
	type = string
	default = "12.34.56.78/32"
}