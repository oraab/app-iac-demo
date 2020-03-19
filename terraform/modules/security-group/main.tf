resource "aws_security_group" "alb" {
	name = var.name
	description = "${var.name} ALB security group"
	vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "alb_internal_ingress_rule" {
	count = var.internal ? 1 : 0

	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["${var.ingress_ip}/32"]	
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_external_ingress_rule" {
	count = var.internal ? 0 : 1

	type = "ingress" 
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.alb.id
}