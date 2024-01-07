# Setting up AWS ec2 with vpc infrastructure using Terraform

### Architecture of infrastructure

![infra photo](/ec2-vpc/infra.png)

### Details of project

- As per above architecture contains two public subnets, two EC2 instances deployed in two subnets respectively, a load balancer, route table and an internet gateway.
- Internet gateway provides the internet to the load balancer and inturn load balancer forwards request to subnets.
- The above architecture is entirely automates and templates are written in HCL(Hashi corp language).

### Pre-requisites for the project

- Need to have aws cli installed in your local machine. [Refer to this documentation to install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
- Need to have terraform installed in your local machine. [Refer to this documentation to install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli).
- AWS account setup.
- Knowledge on implementation of VPC, subnets, load balancers and EC2.

### Details of implementation

- `aws configure` to connect aws to terraform.
- `provider.tf` file contains the details of cloud provider along with region.
- `variables.tf` file contains all the variables required in the template.
- `main.tf` file contains the template used for automation.
