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
    region                      = "us-east-1"
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
}

# Create a S3 bucket
resource "aws_s3_bucket" "bucket_1" {
  count = 2
  bucket = var.s3_names_list[count.index]

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "bucket_2" {
    for_each = var.s3_names_set
    bucket = each.value # each.key can also be used as the value is same as key in this case
    
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  depends_on = [ aws_s3_bucket.bucket_1 ]
}

resource "aws_s3_bucket" "bucket_3" {
    for_each = var.s3_names_map
    bucket = each.value
    
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  depends_on = [ aws_s3_bucket.bucket_2 ]
}