resource "aws_lb_listener_rule" "asg_http" {
  listener_arn = module.alb.alb_http_listener_arn
  priority = 100 

  condition { 
    path_pattern {
      values = ["*"]
    }
  }

  action { 
    type = "forward" 
    target_group_arn = module.asg.target_group_arn
  }
}

resource "aws_lb_listener_rule" "asg_https" {
  listener_arn = module.alb.alb_https_listener_arn
  priority = 100 

  condition { 
    path_pattern {
      values = ["*"]
    }
  }

  action { 
    type = "forward" 
    target_group_arn = module.asg.target_group_arn
  }
}

resource "aws_route53_record" "lb_friendly_dns" {
  count = var.environment == "production" ? 1 : 0

  zone_id = data.aws_route53_zone.alb_zone.zone_id
  name = "test.${var.domain_name}"
  type = "CNAME"
  ttl = "300"
  records = ["${module.alb.alb_dns_name}"]
}

module "asg" {
  source = "../asg"
  
  environment = var.environment
  ami = var.ami
  instance_type = var.instance_type 

  min_size = var.min_size 
  max_size = var.max_size 

  role_name = var.role_name

  user_data = var.user_data
  vpc_id = module.alb.vpc_id
  ingress_cidr_block = var.ingress_cidr_block
  
  subnet_ids = module.alb.subnet_ids
  health_check_type = "ELB"

}

module "alb" {
  source = "../alb"

  name = "app-iac-${var.environment}"
  vpc_name = "${var.environment}-main"
  environment = var.environment
  internal = var.internal
  domain_name = var.domain_name
  ingress_cidr_block = var.ingress_cidr_block
  vpc_cidr_block_first_octets = var.vpc_cidr_block_first_octets
}

data "aws_route53_zone" "alb_zone" {
  name = "${var.domain_name}."
}