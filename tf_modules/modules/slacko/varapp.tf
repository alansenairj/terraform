
#essa variável serve para a pessoa inserir manualmente a vpc e a subnet quando subir com o apply
variable "vpc_id" {
  type = string
  default = "vpc-0415c13a81d360b80"
}

variable "subnet_cidr"{
  type = string
  default = "10.0.101.0/24" #public
}

#regras de ingress

