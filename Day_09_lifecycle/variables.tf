# variable using list type
variable "s3_names_list" {
  type = list(string)
  default = ["my-tf-test-amol-bucket-101", "my-tf-test-amol-bucket-102", "my-tf-test-amol-bucket-103"]
}

# variable using set type
variable "s3_names_set" {
  type = set(string)
  default = ["my-tf-test-amol-bucket-104", "my-tf-test-amol-bucket-105", "my-tf-test-amol-bucket-106"]
}

# variable using map type
variable "s3_names_map" {
  type = map(string)
  default = {
    bucket1 = "my-tf-test-amol-bucket-107"
    bucket2 = "my-tf-test-amol-bucket-108"
    bucket3 = "my-tf-test-amol-bucket-109"
  }
}

variable "instance_type" {
  description = "Type of instance to use"
  type        = string
  default     = "t2.micro"
}