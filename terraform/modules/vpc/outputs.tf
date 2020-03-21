output "vpc_id" {
	value = aws_vpc.main.id
}

output "subnet_ids" {
	value = [aws_subnet.us-east-1a.id, aws_subnet.us-east-1b.id, aws_subnet.us-east-1c.id, aws_subnet.us-east-1d.id, aws_subnet.us-east-1e.id, aws_subnet.us-east-1f.id]
}