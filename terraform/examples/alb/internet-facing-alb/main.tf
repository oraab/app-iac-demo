module "internet_facing_alb" {
	source = "../../../modules/alb"

	name = "internet-facing-alb-example"
	environment = "staging"
	main_subnet_cidr_block = "172.3.1.0"
	alternate_az_subnet_cidr_block = "172.3.2.0"
	vpc_cidr_block = "172.3.0.0"
	vpc_name = var.vpc_name
}

