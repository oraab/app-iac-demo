locals {
  cluster_name = "app-iac-${var.environment}"
}

resource "aws_launch_configuration" "app_iac_launch_config" {
  image_id = var.ami
  instance_type = var.instance_type
  security_groups = ["${aws_security_group.instance_sg.id}"]
  # keypair is uploaded in init script
  key_name = "app_iac_demo_key"
  user_data = var.user_data
  iam_instance_profile = module.instance_profile.name
  
  lifecycle { 
    create_before_destroy = true
  }
}

module "instance_profile" {
  source = "../ec2-role"

  name = var.role_name
}

resource "aws_autoscaling_group" "app_iac_autoscaling_group" {
  name = "${local.cluster_name}-${aws_launch_configuration.app_iac_launch_config.name}"
  launch_configuration = aws_launch_configuration.app_iac_launch_config.name
  vpc_zone_identifier = var.subnet_ids

  target_group_arns = ["${aws_lb_target_group.app_iac_alb_target_group.arn}"]
  health_check_type = var.health_check_type
  
  min_size = var.min_size
  max_size = var.max_size

  min_elb_capacity = var.min_size

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name" 
    value = "${local.cluster_name}-instance"
    propagate_at_launch = true
  }

  tag {
    key = "deployedBy"
    value = "terraform"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "instance_sg" {
  name = "${local.cluster_name}-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "app-iac-instance-sg"
    DeployedBy = "terraform"
  }
}

resource "aws_security_group_rule" "instance_inbound_http_all" {
  description = "HTTP access to instance"
  type = "ingress"
  from_port = 8080
  to_port = 8080
  protocol = "tcp"
  cidr_blocks = ["${var.ingress_cidr_block}"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_security_group_rule" "instance_inbound_default_http" {
  description = "HTTP access to instance"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_security_group_rule" "instance_inbound_default_https" {
  description = "HTTPS access to instance"
  type = "ingress"
  from_port = 443
  to_port = 443
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_security_group_rule" "instance_inbound_ssh" {
  description = "SSH access to instance"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = var.environment == "staging" ? ["${var.ingress_cidr_block}"] : ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_security_group_rule" "instance_outbound_all" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.instance_sg.id}"
}

resource "aws_lb_target_group" "app_iac_alb_target_group" { 
  name = "${local.cluster_name}-tg" 
  port = var.server_port 
  protocol = "HTTP" 
  vpc_id = var.vpc_id
  
  health_check { 
    path = "/" 
    protocol = "HTTP"
    port = "8080" 
    matcher = "200" 
    interval = 35
    timeout = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
