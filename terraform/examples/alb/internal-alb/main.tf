module "internal_alb" {
	source = "../../modules/alb"

	name = "internal-alb-example"
	internal = true
	environment = "staging"
	ingress_ip = "12.4.56.78"
	subnet_cidr_block = "172.3.1.0"
	vpc_cidr_block = "172.3.0.0"
}

