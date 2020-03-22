resource "aws_security_group" "alb" {
	name = var.name
	description = "${var.name} ALB security group"
	vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "alb_internal_inbound_http_restricted" {
	count = var.internal ? 1 : 0

	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["${var.ingress_cidr_block}"]	
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_internal_inbound_http_all" {
	count = var.internal ? 0 : 1

	type = "ingress"
	from_port = 80
	to_port = 80
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]	
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_internal_inbound_8080_all" {
	count = var.internal ? 0 : 1

	type = "ingress"
	from_port = 8080
	to_port = 8080
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]	
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_internal_inbound_ssh" {
	count = var.internal ? 1 : 0

	type = "ingress" 
	from_port = 22
	to_port = 22
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_external_inbound_https" {
	count = var.internal ? 0 : 1

	type = "ingress" 
	from_port = 443
	to_port = 443
	protocol = "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "alb_egress" {
	type = "egress"
	from_port = 0
	to_port = 0
	protocol = "-1"
	cidr_blocks = ["0.0.0.0/0"]
	security_group_id = aws_security_group.alb.id
}