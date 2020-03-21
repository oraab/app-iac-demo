variable "ami" {
  description = "The ID of the AMI that should be deployed inside each instance of the ASG"
  type = string
} 

variable "instance_type" {
  description = "The instance type for each instance of the ASG"
  type = string
  default = "t2.micro"
}

variable "subnet_ids" {
  description = "The subnet IDs within which the instances of the ASG should be created"
  type = list(string)
}

variable "health_check_type" {
  description = "the type of health check to perform. Must be one of: EC2, ELB"
  type = string
  default = "EC2"
}

variable "min_size" {
  description = "The minimum amount of instances that should be within the ASG at any given time"
  type = number
}

variable "max_size" {
  description = "The maximum amount of instances that should be within the ASG at any given time"
  type = number
}

variable "environment" {
  description = "The environment within which the ASG should be created"
  type = string 
  default = "staging"
}

variable "server_port" {
  description = "the port the server will use for HTTP request" 
  type = number
  default = 8080
}

variable "vpc_id" {
  description = "The ID of the VPC within which the ASG should be created"
  type = string
}

variable "user_data" {
  description = "The server content that will upload onto the instances of the ASG"
  type = string 
}

variable "ingress_cidr_block" {
  description = "The IP or CIDR block which is restricted to access the application - only used when internal is true"
  type = string
  default = "0.0.0.0/0"
}