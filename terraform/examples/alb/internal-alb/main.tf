module "internal_alb" {
	source = "../../../modules/alb"
    
    # name should be internal-alb-example but internal ALB have the "internal" prefix by default
	name = var.name
	internal = true
	environment = "staging"
	ingress_cidr_block = var.ingress_cidr_block
	main_subnet_cidr_block = "172.23.1.0"
	alternate_az_subnet_cidr_block = "172.23.2.0"
	vpc_cidr_block = "172.23.0.0"
	vpc_name = var.vpc_name
}

