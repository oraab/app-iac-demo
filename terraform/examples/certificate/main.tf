module "alb_cert" {
	source = "../../modules/certificate"

	domain_name = var.domain_name
	environment = var.environment
}