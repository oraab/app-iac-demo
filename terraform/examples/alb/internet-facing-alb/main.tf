module "internet_facing_alb" {
	source = "../../modules/alb"

	name = "internet-facing-alb-example"
	environment = "staging"
	subnet_cidr_block = "172.3.1.0"
	vpc_cidr_block = "172.3.0.0"
}

