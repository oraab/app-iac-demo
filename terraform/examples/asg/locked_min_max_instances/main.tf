module "asg" {
	source = "../../../modules/asg"

    ami = "ami-0f1a497415643bcbd" # AMI for Ubuntu 18.04 with k8s 1.16.2
    subnet_ids = data.aws_subnet_ids.default.ids
    min_size = 1
    max_size = 1
    vpc_id = data.aws_vpc.default.id

    user_data = data.template_file.user_data.rendered 

}

data "aws_vpc" "default" {
	default = true
}

data "aws_subnet_ids" "default" {
	vpc_id = "${data.aws_vpc.default.id}"
}


data "template_file" "user_data" {
  template = file("${path.cwd}/user-data.sh")
  
  vars = {
    server_port = "8080" 
  }
}