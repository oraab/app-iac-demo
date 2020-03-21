module "internal_alb" {
	source = "../../../modules/alb"
    
    # name should be internal-alb-example but internal ALB have the "internal" prefix by default
	name = var.name
	internal = true
	environment = "staging"
	ingress_cidr_block = var.ingress_cidr_block
	vpc_cidr_block_first_octets = "172.23"
	vpc_name = var.vpc_name
	domain_name = "testing-placeholder.xyz"
}

