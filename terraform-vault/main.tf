provider "aws" {
  region = "ap-south-1"
}

provider "vault" {
  address = "http://15.206.195.141:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "c69e3a2f-e16e-7d43-c932-0231a6617280"
      secret_id = "8a874261-c159-30a3-b3b5-7df7f100f05f"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"
  name = "test-secret"
}

resource "aws_instance" "example" {
  ami = ""
  instance_type = "t2.micro"
  tags = {
    secret = data.vault_kv_secret_v2.example.data["username"]
  }
}