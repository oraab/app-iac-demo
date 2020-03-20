module "main_vpc" {
	source = "../../../modules/vpc"

    # all values provided here as input variables with defaults to allow testing of different values 
	vpc_name = var.vpc_name
	vpc_cidr_block = var.vpc_cidr_block
	main_subnet_cidr_block = var.main_subnet_cidr_block
	alternate_az_subnet_cidr_block = var.alternate_az_subnet_cidr_block
	environment = var.environment
}