# two subnets in two availability zones are created for redundancy

resource "aws_subnet" "us-east-1a" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.0.0/20"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "us-east-1b" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.16.0/20"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "us-east-1c" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.32.0/20"
    availability_zone = "us-east-1c"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "us-east-1d" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.48.0/20"
    availability_zone = "us-east-1d"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "us-east-1e" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.64.0/20"
    availability_zone = "us-east-1e"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "us-east-1f" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.vpc_cidr_block_first_octets}.80.0/20"
    availability_zone = "us-east-1f"
    map_public_ip_on_launch = true
}

resource "aws_vpc" "main" {
	cidr_block = "${var.vpc_cidr_block_first_octets}.0.0/16"

	tags = {
		Name = "${var.environment}-${var.vpc_name}"
	}
}

resource "aws_internet_gateway" "main_ig" {
	vpc_id = "${aws_vpc.main.id}"

	tags = {
	  Name = "main_ig"
	  deployedBy = "terraform"
	}
}

resource "aws_route" "ig_route_to_main" {
	route_table_id = aws_vpc.main.main_route_table_id
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.main_ig.id
}