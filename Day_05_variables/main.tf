# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
provider "aws" {
  # Configuration options
    region = "us-east-1"
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

variable "environment" {
  description = "The environment for which to create resources (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

locals {
  bucket_name = "${var.environment}-terraform-state-bucket-${random_string.bucket_suffix.result}"
}

# # backend configuration
# terraform {
#   backend "s3" {
#     bucket         = "dev-terraform-state-bucket-12345678" # Replace with your actual bucket name
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     use_lockfile  = "true"
#     encrypt        = true
#   }
# }


#create a simple S3 bucket
resource "aws_s3_bucket" "example" {
  bucket = local.bucket_name
  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}

# create vpc and subnet
resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name        = "${var.environment}-subnet"
    Environment = var.environment
  }
}

# create EC2 instance
resource "aws_instance" "example_instance" {
  ami           = "ami-0ed094fb1304fd857" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id

  tags = {
    Name        = "${var.environment}-instance"
    Environment = var.environment
  }
}

output "instance_name" {
  value = aws_instance.example_instance.tags["Name"]
}

output "bucket_name" {
  value = aws_s3_bucket.example.bucket
}