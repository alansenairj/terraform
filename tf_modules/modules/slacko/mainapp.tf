

resource "aws_key_pair" "slacko-sshkey"{
    key_name = "slacko-app-key"
    #redirecionar para o path correto da chave assimétrica 
    #adicionar gitignore *.pub nessa chave
    
    public_key = file("${path.module}/files/slacko.pub")

    }

resource "aws_instance" "slacko-app" {
    ami = data.aws_ami.slacko-app.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.subnet_public.id
    associate_public_ip_address = true

    tags = {
        Name = "slacko-app"
    }

    key_name = aws_key_pair.slacko-sshkey.id
    # arquivo de bootstrap
    user_data = file("${path.module}/files/ec2.sh")
}

resource "aws_instance" "mongodb" {
    ami = data.aws_ami.slacko-app.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.subnet_public.id

    tags = {
        Name = "mongodb"
    }

    key_name = aws_key_pair.slacko-sshkey.id
    # arquivo de bootstrap
    user_data = file("${path.module}/files/mongodb.sh")
     
}    

resource "aws_security_group" "allow-slacko" {
    name = "allow_ssh_http"
    description = "allow ssh and http port"

    
    #teste vpc dinâmico
    vpc_id = var.vpc_id
    
    #"${data.aws_vpc.my-vpc.id}" 

    ingress = [
        {
        description = "Allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = null

    }
    ,{
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = null
    }
    ]

    egress = [
        {
        description = "Allow all"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = null
        }
    ]

    tags = {
        Name = "allow_ssh_http"
    }
}

resource "aws_security_group" "allow-mongodb" {
    name = "allow_mongodb"
    description = "allow Mongodb"
    # entrar na AWS e em VPC na segunda coluna tem a VPC ID, colar no campo abaixo
    vpc_id = var.vpc_id

    ingress = [
        {
        description = "allow mongodb"
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = null
        }
    ]

    egress = [
        {
        description = "Allow all"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = null
        }
    ]
    
    tags = {
        Name = "allow_mongodb"
    }
}

resource "aws_network_interface_sg_attachment" "mongodb-sg" {
    security_group_id = aws_security_group.allow-mongodb.id
    network_interface_id = aws_instance.mongodb.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "slacko-sg" {
    security_group_id = aws_security_group.allow-mongodb.id
    network_interface_id = aws_instance.slacko-app.primary_network_interface_id
}

resource "aws_route53_zone" "slack_zone"{
    name = "iaac0506.com.br"

    vpc {
        # entrar na AWS e em VPC na segunda coluna tem a VPC ID, colar no campo abaixo
        vpc_id = var.vpc_id
    }
}

resource "aws_route53_record" "mongodb"{
    zone_id = aws_route53_zone.slack_zone.id
    name = "mongodb.iaac0506.com.br"
    type = "A"
    ttl = "300"
    records = [aws_instance.mongodb.private_ip]
}



# para acessar http://(ip)/docs