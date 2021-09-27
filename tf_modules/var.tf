variable "vpc_id" {
  type = string
  default = "vpc-0415c13a81d360b80"
  description = "ID da VPC na conta CSI"
  validation {
      condition = length(var.vpc_id) < 9 && substr(var.vpc_id, 0, 9) == "us-"
      error_message = "Região incorreta."

  }
}


variable "subnet_cidr"{
  type = string
  default = "10.0.101.0/24" #public
  description = "subnet dev da aplicação"
}


#obrigar a dizer quem vai usar
#variable "ambiente"{
#  type = map(object({
#         ambiente = string
#         departamento = string

#  }))

#  default = {
#    "ambiente" = "dev"
#    "departamento" = "fab"
#  }
#}


