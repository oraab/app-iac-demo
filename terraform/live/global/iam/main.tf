provider "aws" {
	region = "us-east-1"

	version = "~> 2.0"
}

resource "aws_iam_user" "app_iac_demo_runner" {
	name = var.user_name
}

resource "aws_iam_group" "app_iac_demo_runner_group" {
	name = "app_iac_demo_runner_group"
}

resource "aws_iam_group_membership" "app_iac_demo_runner_group_membership" {
	name = "app_iac_demo_runner_group_membership"

	users = ["${aws_iam_user.app_iac_demo_runner.name}"]

	group = "${aws_iam_group.app_iac_demo_runner_group.name}"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_ec2_full_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_s3_full_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_iam_full_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_dynamodb_full_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_certificate_limited_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "${aws_iam_policy.app_iac_demo_runner_certificate_limited_access.arn}"
}

resource "aws_iam_group_policy_attachment" "app_iac_demo_runner_group_route53_limited_access" {
  group      = "${aws_iam_group.app_iac_demo_runner_group.name}"
  policy_arn = "${aws_iam_policy.app_iac_demo_runner_route53_limited_access.arn}"
}

resource "aws_iam_policy" "app_iac_demo_runner_certificate_limited_access" {
	name = "app_iac_demo_runner_certificate_limited_access"
	policy = "${data.aws_iam_policy_document.certificate_limited_access.json}"
}

data "aws_iam_policy_document" "certificate_limited_access" {
	statement {
	  actions = [
	    "acm:Describe*",
	    "acm:List*",
        "acm:RequestCertificate",
        "acm:DeleteCertificate",
        "acm:AddTagsToCertificate"
	  ]
	  resources = ["*"]
	}
}

resource "aws_iam_policy" "app_iac_demo_runner_route53_limited_access" {
	name = "app_iac_demo_runner_route53_limited_access"
	policy = "${data.aws_iam_policy_document.route53_limited_access.json}"
}

data "aws_iam_policy_document" "route53_limited_access" {
	statement {
	  actions = [
        "route53:Get*",
        "route53:List*",
        "route53:CreateHostedZone",
        "route53:DeleteHostedZone",
        "route53:ChangeResourceRecordSets"
	  ]
	  resources = ["*"]
	}
}
