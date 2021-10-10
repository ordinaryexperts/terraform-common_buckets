variable "enable_secrets_bucket" {
  default = "true"
}
variable "enable_chef_bucket" {
  default = "true"
}
variable "env" {}
variable "name" {}

resource "aws_cloudformation_stack" "common_buckets" {
  name = "${var.name}-${var.env}-common-buckets-stack"
  parameters = {
    EnableSecretsBucket = "${var.enable_secrets_bucket}"
    EnableChefBucket = "${var.enable_chef_bucket}"
    Env = "${var.env}"
    Name = "${var.name}"
  }
  template_body = file("${path.module}/template.yaml")
  on_failure = "DELETE"
}

output "secrets_bucket" {
  value = "${aws_cloudformation_stack.common_buckets.outputs["SecretsBucket"]}"
}

output "chef_bucket" {
  value = "${aws_cloudformation_stack.common_buckets.outputs["ChefBucket"]}"
}
