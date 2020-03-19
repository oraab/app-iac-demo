variable "name" {
  description = "The name of the security group" 
  type = string 
}

variable "vpc_id" {
	description = "The ID of the VPC the security group is included in"
	type = string
}

variable "internal" {
  description = "Is the ALB internal or internet facing? (optional - default=false)"
  type = bool 
  default = false 
}

variable "ingress_ip" {
	description = "An IP from which the ALB will receive incoming traffic over HTTP port (optional - will not be used if the internal variable is not set)"
	type = string 
	default = "0.0.0.0"
}