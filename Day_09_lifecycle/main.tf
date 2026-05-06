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

# life cycle block with create_before_destroy set to false (default) - will destroy the existing resource before creating a new one
resource "aws_instance" "web_server" {
  ami           = "ami-0c94855ba95c71c99" # Amazon Linux 2 AMI ami-0ed094fb1304fd857
  instance_type = var.instance_type

  lifecycle {
    create_before_destroy = true # Create new instance before destroying the old one to ensure zero downtime during updates
  }

}

# life cycle block with prevent_destroy set to true - will prevent the resource from being destroyed and throw an error if a destroy action is attempted
resource "aws_s3_bucket" "critical_data" {
  bucket = "production-data-amol"

  lifecycle {
    prevent_destroy = false  # Prevents accidental deletion of critical data
  }

}# Launch template required by the autoscaling group
resource "aws_launch_template" "app_servers" {
  name_prefix   = "app-servers-"
  image_id      = "ami-0c94855ba95c71c99"
  instance_type = var.instance_type
}

# life cycle block with ignore_changes - will ignore changes to specified attributes and not trigger a destroy/create or update action for those attributes
resource "aws_autoscaling_group" "app_servers" {
  desired_capacity          = 2 # desired capacity changed on aws console
  min_size                  = 1
  max_size                  = 5
  availability_zones        = ["us-east-1a"]

  launch_template {
    id      = aws_launch_template.app_servers.id
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [
      desired_capacity,  # Ignore capacity changes by auto-scaling
      load_balancers,    # Ignore if added externally
    ]
  }
}

# life cycle block with replace_triggered_by - will trigger a replacement of the resource when the specified resource changes
resource "aws_security_group" "app_sg" {
  name = "app-security-group"
  # ... security rules ...
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  tags = {
    Name = "SG-my-web-server"
  }
}

resource "aws_instance" "app_with_sg" {
  
  ami           = "ami-0ff8a91507f77f867" # Amazon Linux AMI
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
    Name = "my-web-server"
  }

  lifecycle {
    create_before_destroy = true
    replace_triggered_by = [
      aws_security_group.app_sg.tags  # Replace instance when SG changes
    ]
  }
}