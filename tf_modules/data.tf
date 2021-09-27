
  data "aws_vpc" "my-vpc" {
    id = var.vpc_id
  }

data "aws_subnet" "subnet_public" {
    cidr_block = var.subnet_cidr    
}
