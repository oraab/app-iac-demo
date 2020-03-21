output "target_group_arn" {
	value = aws_lb_target_group.app_iac_alb_target_group.arn
}

output "instance_security_group_id" {
	value = aws_security_group.instance_sg.id
}