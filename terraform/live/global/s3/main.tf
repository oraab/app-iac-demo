provider "aws" {
	region = "us-east-1"

	version = "~> 2.0"
}

resource "aws_s3_bucket" "state" {
	bucket = "${var.tf_state_bucket}"

	versioning {
	  enabled = true 
	}

	server_side_encryption_configuration {
	  rule {
        apply_server_side_encryption_by_default { 
          sse_algorithm = "AES256"
        }
      }
	}

	lifecycle {
	  prevent_destroy = true
	}
}

resource "aws_dynamodb_table" "lock" {
  name = "${var.tf_state_lock}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }	
}