module "staging_certificate" {
	source = "../../../modules/certificate"

	domain_name = "testing-placeholder.xyz" # replace this with your registered domain
	environment = "staging"
}