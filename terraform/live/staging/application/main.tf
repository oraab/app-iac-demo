module "staging_application" {
	source = "../../../modules/application"

	environment = "staging"
    ami = "ami-04ac550b78324f651" # replace this with a different var if you need 
    min_size = 1 
    max_size = 1 
    instance_type = "t2.micro"
    internal = true
    ingress_cidr_block = "141.226.14.213/32" # replace this with your own IP if you need

    user_data = data.template_file.user_data.rendered 
}

data "template_file" "user_data" {
  template = file("${path.cwd}/post_deploy.sh")
  
  vars = {
    ecr_repo = var.ecr_repo
    image_tag = var.image_tag
  }
}