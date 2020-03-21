module "internet_facing_alb" {
	source = "../../../modules/alb"

	name = "internet-facing-alb-example"
	environment = "staging"
	vpc_cidr_block_first_octets = "172.24"
	vpc_name = var.vpc_name
	domain_name = "testing-placeholder.xyz" # replace this with another registered domain which has a cert in ACM if needed
}

