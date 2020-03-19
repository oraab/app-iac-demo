module "security_group_with_specific_ip_ingress" {
 	source = "../../../modules/security-group"
	name = "security_group_with_public_access"
	# vpc_id is provided as a variable for testing purposes, the default is the default VPC of the account that is used to deploy these changes
	vpc_id = var.vpc_id == "" ? data.aws_vpc.default.id : var.vpc_id
}

data "aws_vpc" "default" {
	default = true
}