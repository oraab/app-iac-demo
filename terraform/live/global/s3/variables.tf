variable "tf_state_bucket" {
	description = "The name of the state bucket"
	type = string
}

variable "tf_state_lock" {
	description = "The name of the lock table in DynamoDB for the state bucket" 
	type = string
}