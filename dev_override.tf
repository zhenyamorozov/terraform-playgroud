resource "aws_instance" "webserver" {
    tags = {
        Name = "Terraform instance but the name is new"
    }
}