# two subnets in two availability zones are created for redundancy

resource "aws_subnet" "us-east-1a" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.0.0/20"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "us-east-1b" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.16.0/20"
    availability_zone = "us-east-1b"
}

resource "aws_subnet" "us-east-1c" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.32.0/20"
    availability_zone = "us-east-1c"
}

resource "aws_subnet" "us-east-1d" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.48.0/20"
    availability_zone = "us-east-1d"
}

resource "aws_subnet" "us-east-1e" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.64.0/20"
    availability_zone = "us-east-1e"
}

resource "aws_subnet" "us-east-1f" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.80.0/20"
    availability_zone = "us-east-1f"
}

resource "aws_vpc" "main" {
	cidr_block = "${var.vpc_cidr_block_first_octets}.0.0/16"

	tags = {
		Name = "${var.vpc_name}-${var.environment}"
	}
}

resource "aws_internet_gateway" "main_ig" {
	vpc_id = "${aws_vpc.main.id}"

	tags = {
	  Name = "main_ig"
	  deployedBy = "terraform"
	}
}

resource "aws_route_table" "main_rt" {
	vpc_id = "${aws_vpc.main.id}"

	route {
	  cidr_block = "0.0.0.0/0"
	  gateway_id = "${aws_internet_gateway.main_ig.id}"
	}
}

resource "aws_route_table_association" "us-east-1a" {
	subnet_id = aws_subnet.us-east-1a.id
	route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "us-east-1b" {
	subnet_id = aws_subnet.us-east-1b.id
	route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "us-east-1c" {
	subnet_id = aws_subnet.us-east-1c.id
	route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "us-east-1d" {
	subnet_id = aws_subnet.us-east-1d.id
	route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "us-east-1e" {
	subnet_id = aws_subnet.us-east-1e.id
	route_table_id = aws_route_table.main_rt.id
}

resource "aws_route_table_association" "us-east-1f" {
	subnet_id = aws_subnet.us-east-1f.id
	route_table_id = aws_route_table.main_rt.id
}