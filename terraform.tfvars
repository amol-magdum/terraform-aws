# Example terraform.tfvars file
# Copy this file to terraform.tfvars and update with your values

primary_region   = "us-east-1"
secondary_region = "us-west-2"

primary_vpc_cidr   = "10.0.0.0/16"
secondary_vpc_cidr = "10.1.0.0/16"

primary_subnet_cidr   = "10.0.1.0/24"
secondary_subnet_cidr = "10.1.1.0/24"

instance_type = "t2.micro"

# Optional: set EC2 key pair names if you want SSH access.
# Leave empty to create instances without key pairs.
primary_key_name   = ""
secondary_key_name = ""