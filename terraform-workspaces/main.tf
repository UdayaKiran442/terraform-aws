provider "aws" {
  region = "ap-south-1"
}

variable "ami" {
  description = ""
}


variable "instance_type" {
  description = ""
  type = map(string)

  default = {
    "dev" = "t2.micro"
    "stage" = "t2.medium"
    "prod" = "t2.xlarge"
  }
}



module "ec2_instance" {
  source = "./modules/ec2-instance"
  ami = var.ami
  instance_type = lookup(var.instance_type, terraform.workspace, "t2.micro")
}