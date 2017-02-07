variable "env" {}
variable "name" {}

resource "aws_cloudformation_stack" "common_buckets" {
  name = "${var.name}-${var.env}-common-buckets-stack"
  parameters {
    Env = "${var.env}"
    Name = "${var.name}"
  }
  template_body = "${file("${path.module}/template.yaml")}"
  on_failure = "DELETE"
}  

output "secrets_bucket" {
  value = "${aws_cloudformation_stack.common_buckets.outputs["SecretsBucket"]}"
}

output "chef_bucket" {
  value = "${aws_cloudformation_stack.common_buckets.outputs["ChefBucket"]}"
}
