variable cidr_block{
    type = string
    description = "CIDR block for the main VPC"
}

variable public_cidr_block{
    type = list(string)
    description = "cidr for public subnet"
}

variable private_cidr_block{
    type = list(string)
    description = "cidr for private subnet"
}

variable "availability_zone" {
  type        = list(string)
  description = "List of availability zones for subnets"
}
