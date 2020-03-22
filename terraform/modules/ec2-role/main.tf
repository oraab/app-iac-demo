resource "aws_iam_instance_profile" "launch_configuration_instance_profile" {
  name = "${var.name}_instance_profile"
  role = aws_iam_role.launch_configuration_assume_role.id
}

resource "aws_iam_role" "launch_configuration_assume_role" {
	name = "${var.name}_assume_role"
	path = "/"

	assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
	statement {
	  actions = ["sts:AssumeRole"]

	  principals {
	    type = "Service"
	    identifiers = ["ec2.amazonaws.com"]
	  }
	}
}

resource "aws_iam_role_policy" "launch_configuration_role_policy" {
	name = "launch_configuration_role_policy"
	role = aws_iam_role.launch_configuration_assume_role.id
	policy = "${data.aws_iam_policy_document.role_policy.json}"
}

data "aws_iam_policy_document" "role_policy" {
	statement {
	  actions = [
        "ecr:BatchCheckLayerAvailabiliy",
        "ecr:BatchGetImage",
        "ecr:Describe*",
        "ecr:Get*",
        "ecr:List*",
        "ecr:StartImageScan"
	  ]

	  resources = ["*"]
	}
}