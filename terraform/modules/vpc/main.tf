# two subnets in two availability zones are created for redundancy

resource "aws_subnet" "main" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.main_subnet_cidr_block}/24"
    availability_zone = "us-east-1a"
}

resource "aws_subnet" "alternate_az" {
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "${var.alternate_az_subnet_cidr_block}/24"
    availability_zone = "us-east-1e"
}

resource "aws_vpc" "main" {
	cidr_block = "${var.vpc_cidr_block}/16"

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