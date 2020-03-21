module "production_application" {
	source = "../../../modules/application"

	environment = "production"
    ami = var.ami
    min_size = 2
    max_size = 2 
    instance_type = "t2.micro"

    user_data = data.template_file.user_data.rendered 
}

data "template_file" "user_data" {
  template = file("${path.cwd}/user-data.sh")
  
  vars = {
    server_port = "8080" 
  }
}