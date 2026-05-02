# saving tfstate file to remote backend aws S3 execute on windows

aws configure
execute create_backend_S3.bat file first and use S3 name in terraform script

# backend S3 should be created before terraform apply used as it read and save tfstate file else will error S3 not found error

# enable encryption on S3

# make sure to change backend S3 name in main.tf file

# on terraform init - message shows initialising backend successfully

# Backend Migration

# Initialize with new backend configuration

terraform init

# Terraform will prompt to migrate existing state

# Answer 'yes' to copy existing state to new backend

# Verify state is now remote

terraform state list

State Commands

# List resources in state

terraform state list

# Show detailed state information

terraform state show <resource_name>

# Remove resource from state (without destroying)

terraform state rm <resource_name>

# Move resource to different state address

terraform state mv <source> <destination>

# Pull current state and display

terraform state pull
