module "staging_ecr" {
	source = "../../../modules/ecr"

	name = "staging-images"
}