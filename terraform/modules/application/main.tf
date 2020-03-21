resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_listener_arn
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

module "asg" {
  source = "../asg"
  
  environment = var.environment
  ami = var.ami
  instance_type = var.instance_type 

  min_size = var.min_size 
  max_size = var.max_size 

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
}















