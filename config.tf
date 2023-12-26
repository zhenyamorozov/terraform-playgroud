### variables definition
# variable "aws_access_key" {}
# variable "aws_secret_key" {}

provider "aws" {
    # access_key = "${var.aws_access_key}"
    # secret_key = "${var.aws_secret_key}"
    # shared_credentials_file = "~/.aws/credentials"

    # rather take the local AWS credentials
    region = "ap-south-1"
    profile = "default"
}

# data store to read the list of AZs
data "aws_availability_zones" "available" {}

# output AZ names to console
output "azs" {
    value = data.aws_availability_zones.available.names
}

# create an EC2 instance
resource "aws_instance" "webserver" {
    ami = "ami-08c3ab3001b28e2ac"
    instance_type = "t3a.nano"
    # key_name = "no_key"
    tags = {
        Name = "Terraform instance" # this name should be replaced by the _override.tf
    }
}

# create 3 EC2 instances
resource "aws_instance" "three_webservers" {
    count = "3" # number of instances to spin up
    ami = "ami-08c3ab3001b28e2ac"
    instance_type = "t3a.nano"  
    associate_public_ip_address = false # no need for a public IP
    # availability_zone = "${lookup(data.aws_availability_zones.available.names, count.index)}"   # lookup() used to get a value from a map
    # availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"  # element() is used to extract a value from list
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"             # or simply like that
    user_data =  join("\n", [
        "sudo apt-get update",
        "sudo apt-get install Nginx -y",
        "sudo service nginx start",
    ])

    # execute this command set upon startup (install and start nginx)
    # provisioners are not recommended, it's better to use user_data
    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo apt-get update",
    #         "sudo apt-get install Nginx -y",
    #         "sudo service nginx start",
    #      ]
    # }
    # connection {
    #     user = "user"
    #     private_key = ""
    # }

    tags = {
        Name = "Terraform instance ${count.index+1} new"    # instances will have numbers in the name
    }

    lifecycle {
        create_before_destroy = true    # first spin up new instances, then destroy old ones
    }
}

# output "instances" {
#     value = aws_instance.three_webservers
# }
