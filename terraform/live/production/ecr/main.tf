module "staging_ecr" {
	source = "../../../modules/ecr"

	name = "production-images"
}