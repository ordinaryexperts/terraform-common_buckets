variable "env" {}
variable "name" {}

resource "aws_s3_bucket" "log_bucket" {
   acl = "log-delivery-write"
   bucket = "${var.name}-${var.env}-logs"
}

data "template_file" "policy" {
  template = "${file("${path.module}/policy.json.tpl")}"
  vars {
    bucket = "${var.name}-${var.env}-secrets"
  }
}

resource "aws_s3_bucket" "secrets_bucket" {
  acl = "private"
  bucket = "${var.name}-${var.env}-secrets"
  logging {
    target_bucket = "${aws_s3_bucket.log_bucket.id}"
    target_prefix = "secrets/"
  }

  policy = "${data.template_file.policy.rendered}"
  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "chef_bucket" {
  acl = "private"
  bucket = "${var.name}-${var.env}-chef"
  versioning {
    enabled = true
  }
}

output "secrets_bucket" {
  value = "${var.name}-${var.env}-secrets"
}

output "chef_bucket" {
  value = "${var.name}-${var.env}-chef"
}
