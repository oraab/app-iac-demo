module "main_vpc" {
	source = "../../../modules/vpc"

    # all values provided here as input variables with defaults to allow testing of different values 
	environment = var.environment
}
