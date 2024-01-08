terraform {
  backend "s3" {
    bucket = "gonuguntla-demo-remote-backend"
    key    = "uk/terraform.tfstate"
    region = "ap-south-1"
  }
}
