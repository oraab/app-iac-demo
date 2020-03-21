module "staging_application" {
	source = "../../../modules/application"

	environment = "staging"
    ami = var.ami
    min_size = 1 
    max_size = 1 
    instance_type = "t2.micro"
    internal = true

    user_data = data.template_file.user_data.rendered 
}

data "template_file" "user_data" {
  template = file("${path.cwd}/user-data.sh")
  
  vars = {
    server_port = "8080" 
  }
}