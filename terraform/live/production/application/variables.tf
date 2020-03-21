variable "ami" {
	description = "The AMI that should be installed on the application servers"
	type = string
	default = "ami-0f1a497415643bcbd"
}

variable "ecr_repo" {
	description = "The URL for the ECR repo from which the image should be pulled in the application"
	type = string
}

variable "image_tag" {
	description = "The tag name for the image that should be pulled for the application"
	type = string
}