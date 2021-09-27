module "slackoapp" {
    source = "./modules/slacko"
    vpc_id = data.aws_vpc.my-vpc.id
    subnet_cidr = var.subnet_cidr


} 

