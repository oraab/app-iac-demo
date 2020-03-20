module "internal_alb" {
	source = "../../../modules/alb"
    
    # name should be internal-alb-example but internal ALB have the "internal" prefix by default
	name = "alb-example"
	internal = true
	environment = "staging"
	ingress_ip = "12.4.56.78"
	main_subnet_cidr_block = "172.3.1.0"
	alternate_az_subnet_cidr_block = "172.3.2.0"
	vpc_cidr_block = "172.3.0.0"
	vpc_name = var.vpc_name
}

