### variables definition
// variable "aws_access_key" {}
// variable "aws_secret_key" {}

provider "aws" {
//   access_key = "${var.aws_access_key}"
//   secret_key = "${var.aws_secret_key}"
//   shared_credentials_file = "~/.aws/credentials"

//   rather take the local AWS credentials
  region = "ap-south-1"
  profile = "default"
}

// data store to read the list of AZs
data "aws_availability_zones" "available" {}

// output AZ names to console
output "azs" {
    value = data.aws_availability_zones.available.names
}

// create an EC2 instance
resource "aws_instance" "webserver" {
    ami = "ami-08c3ab3001b28e2ac"
    instance_type = "t3a.nano"
    tags = {
        Name = "Terraform instance 1"
    }
}
