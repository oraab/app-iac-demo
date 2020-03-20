# zone created in a separate module in order to be provided as a data source to certificate creation
resource "aws_route53_zone" "alb_zone" {
	name = "${var.domain_name}"
}