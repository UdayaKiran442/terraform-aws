provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "example" {
  ami = "ami-03f4878755434977f"
  instance_type = "t2.micro"
  key_name = "aws_login1"
  subnet_id = "subnet-02ad28cf875903ab9"
}