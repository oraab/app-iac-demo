output "alb_dns_name" {
	value = aws_lb.alb.dns_name
}

output "alb_http_listener_arn" {
	value = length(aws_lb_listener.http_external) > 0 ? aws_lb_listener.http_external[0].arn : aws_lb_listener.http_internal[0].arn
}

output "alb_https_listener_arn" {
	value = aws_lb_listener.https[0].arn
}

output "subnet_ids" {
	value = module.main_vpc.subnet_ids
}

output "vpc_id" {
	value = module.main_vpc.vpc_id
}

output "lb_security_group_id" {
	value = module.alb_security_group.security_group_id
}
