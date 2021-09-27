
  data "aws_vpc" "my-vpc" {
    id = var.vpc_id
  }


data "aws_ami" "slacko-app"  {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amazon*"]
    }
    
    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

data "aws_subnet" "subnet_public" {
    cidr_block = var.subnet_cidr    
}



#data "aws_vpc" "my-vpc" {
#    filter {
#      name ="tag:Name"
#      values = ["my-vpc"]
#    } 
#}

