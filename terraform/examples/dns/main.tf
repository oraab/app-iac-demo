module "rout53_zone" {
    source = "../../modules/dns"
	domain_name = var.domain_name
}