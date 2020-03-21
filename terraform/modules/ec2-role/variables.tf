variable "name" {
	description = "The name of the instance profile and assume role - provided to avoid collisions"
	type = string
	default = "launch_configuration"
}