# variables

variable "<name>" {
description = explain why used
type = string
default = value (Required)
sensetive = (true | false)
nullable = (true | false)
ephemeral = (true | false)

validation{
condition = <EXPRESSION>
error_message = "<message>"
}
}

# local - this are local to file its declaired in,

locals {
bucket_name = "${var.environment}-terraform-state-bucket-${random_string.bucket_suffix.result}"
}

# output a name of resource after creation, can be passsed to other resorces for referenace

output "instance_name" {
value = aws_instance.example_instance.tags["Name"]
}

# variable precedence
ENV VARS
terraform.tfvars
terraform.tfvars.json
*.auto.tfvars or *.auto.tfvars.json
ANY -var or -var-file option