locals {
	page_not_found_status_code = "404"
	http_port = "80"
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

resource "aws_lb_listener" "http" {
	count = var.internal ? 1 : 0
    
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = "80"
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

# TODO: add HTTPS listener after having the certificates

module "alb_security_group" {
 	source = "../security-group"
	name = var.name
	vpc_id = module.main_vpc.vpc_id
	ingress_ip = var.ingress_ip
}

module "main_vpc" {
	source = "../vpc"
	vpc_name = var.vpc_name
	environment = var.environment
	vpc_cidr_block = var.vpc_cidr_block
	main_subnet_cidr_block = var.main_subnet_cidr_block
	alternate_az_subnet_cidr_block = var.alternate_az_subnet_cidr_block
}
