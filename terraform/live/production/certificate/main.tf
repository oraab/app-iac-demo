module "prod_certificate" {
	# values are hard coded in these modules to provide clear documentation of changes
	source = "../../../modules/certificate"

	domain_name = "testing-placeholder.xyz" # replace this with your registered domain
	environment = "production"
}