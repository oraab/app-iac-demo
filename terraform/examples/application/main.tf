module "application" {
	source = "../../modules/application"

    environment = var.environment
    ami = var.ami
    min_size = var.min_size 
    max_size = var.max_size 
    instance_type = "t2.micro"
    internal = var.internal

    user_data = data.template_file.user_data.rendered 

}

data "template_file" "user_data" {
  template = file("${path.cwd}/user-data.sh")
  
  vars = {
    server_port = "8080" 
  }
}