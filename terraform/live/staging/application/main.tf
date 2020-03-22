module "staging_application" {
	# values are hard coded in these modules to provide clear documentation of changes
	source = "../../../modules/application"

	environment = "staging"
    ami = "ami-0f1a497415643bcbd" # replace this with a different var if you need 
    min_size = 1 
    max_size = 1 
    instance_type = "t2.micro"
    internal = true
    role_name = "staging"
    ingress_cidr_block = "141.226.14.213/32" # replace this with your own IP if you need
	vpc_cidr_block_first_octets = "172.20"
    user_data = templatefile("${path.cwd}/rendered_post_deploy.sh", { ecr_repo = var.ecr_repo, image_tag = var.image_tag })
}