resource "aws_acm_certificate" "alb_default_cert" {
	domain_name = "${var.domain_name}" 
	subject_alternative_names = ["*.${domain_name}"]
	validation_method = "DNS"

	tags = {
	  Environment = var.environment 
	  createdBy = "terraform"
	}

	lifecycle {
	  create_before_destroy = true
	}
}

resource "aws_acm_certificate_validation" "alb_default_cert_validation" {
  certificate_arn         = "${aws_acm_certificate.alb_default_cert.arn}"
  validation_record_fqdns = ["${aws_route53_record.alb_default_cert_validation_record.fqdn}"]
}

resource "aws_route53_record" "alb_default_cert_validation_record" {
  name    = "${aws_acm_certificate.alb_default_cert.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.alb_default_cert.domain_validation_options.0.resource_record_type}"
  zone_id = "${module.alb_zone.id}"
  records = ["${aws_acm_certificate.alb_default_cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

module "alb_zone" {
	source = "../dns"

	domain_name = "${var.domain_name}"
}