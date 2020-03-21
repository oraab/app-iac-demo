module "production_application" {
	# values are hard coded in these modules to provide clear documentation of changes
	source = "../../../modules/application"

	environment = "production"
    ami = var.ami
    min_size = 2
    max_size = 2 
    instance_type = "t2.micro"
    vpc_cidr_block_first_octets = "172.21"

    user_data = "${data.template_file.user_data.rendered}" 
}

data "template_file" "user_data" {
  template = "${file("${path.cwd}/post_deploy.sh")}"
  
   vars = {
    ecr_repo = "${var.ecr_repo}"
    image_tag = "${var.image_tag}"
  }
}