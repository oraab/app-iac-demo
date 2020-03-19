resource "aws_lb" "alb" {
	name = var.name
	internal = var.internal
	load_balancer_type = "application" 
	security_groups = ["${module.alb_security_group.security_group_id}"]
	subnets = ["${aws_subnet.main.id}"]

    # this is in order to allow easy creation and destruction of this resource in tests
	enable_deletion_protection = false

	tags = {
	  Environment = var.environment 
	  deployedBy = "terraform"
	}

}

module "alb_security_group" {
 	source = "../security-group"
	name = var.name
	vpc_id = aws_vpc.main.id
	ingress_ip = var.ingress_ip
}

resource "aws_subnet" "main" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = var.subnet_cidr_block
}

resource "aws_vpc" "main" {
	cidr_block = var.vpc_cidr_block

	tags = {
		Name = "${var.vpc_name}-${var.environment}"
	}
}
