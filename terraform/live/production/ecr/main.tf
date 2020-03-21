module "production_ecr" {
	# values are hard coded in these modules to provide clear documentation of changes
	source = "../../../modules/ecr"

	name = "production-images"
}