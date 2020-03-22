module "asg" {
	source = "../../../modules/asg"

	environment = var.environment
    ami = "ami-0f1a497415643bcbd" # AMI for Ubuntu 18.04 with k8s 1.16.2
    subnet_ids = data.aws_subnet_ids.default.ids
    min_size = 1
    max_size = 1
    vpc_id = data.aws_vpc.default.id

    role_name = var.role_name

    user_data = templatefile("${path.cwd}/user-data.sh", { server_port = "8080" })

}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnet_ids" "default" {
	vpc_id = "${data.aws_vpc.default.id}"
}