provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2" {
  instance_type = "t2.micro"
  ami = "ami-03f4878755434977f"
  key_name = "aws-login1"
}

resource "aws_s3_bucket" "name" {
  bucket = "gonuguntla-demo-remote-backend"
}