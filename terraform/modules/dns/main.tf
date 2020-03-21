resource "aws_route53_zone" "alb_zone" {
	name = "${var.domain_name}"
}