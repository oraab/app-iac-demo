locals {
	page_not_found_status_code = "404"
}

resource "aws_lb" "alb" {
	name = var.name
	internal = var.internal
	load_balancer_type = "application" 
	security_groups = ["${module.alb_security_group.security_group_id}"]
	subnets = module.main_vpc.subnet_ids
    # this is in order to allow easy creation and destruction of this resource in tests
	enable_deletion_protection = false

	tags = {
	  Environment = var.environment 
	  deployedBy = "terraform"
	}

}

resource "aws_lb_listener" "http_internal" {
	count = var.internal ? 1 : 0
    
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = "8080"
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "${local.page_not_found_status_code}: Page not found"
        status_code = "${local.page_not_found_status_code}"
      }
    }
}

resource "aws_lb_listener" "http_reroute" {
	count = var.internal ? 0 : 1
    
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "redirect"

      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
}

resource "aws_lb_listener" "https" {
	count = var.internal ? 0 : 1
    
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = "443"
    protocol = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-2016-08" # default - added it for explicitness
    certificate_arn = data.aws_acm_certificate.cert.arn

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "${local.page_not_found_status_code}: Page not found"
        status_code = "${local.page_not_found_status_code}"
      }
    }
}

resource "aws_lb_listener" "http_external" {
	count = var.internal ? 0 : 1
    
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = "8080"
    protocol = "HTTP"
    
    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "${local.page_not_found_status_code}: Page not found"
        status_code = "${local.page_not_found_status_code}"
      }
    }
}

module "alb_security_group" {
 	source = "../security-group"
	name = var.name
	vpc_id = module.main_vpc.vpc_id
	ingress_cidr_block = var.ingress_cidr_block
	internal = var.internal
}

module "main_vpc" {
	source = "../vpc"
	vpc_name = var.vpc_name
	environment = var.environment
	vpc_cidr_block_first_octets = var.vpc_cidr_block_first_octets
}

data "aws_acm_certificate" "cert" {
	domain = var.domain_name
	types = ["AMAZON_ISSUED"]
	most_recent = true
}
