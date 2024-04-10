
variable "cluster_name" {
    type = string
    description = "Name of the EKS cluster"
}


variable "node_group_name" {
    type = string
    description = "Name of the EKS node group"
} 

variable "instance_type" {
    type = list(string)
    description = "ARN of the IAM role for the EKS node group"
}

variable "private_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "desired_size" {
    type = number
    description = "Desired size of the EKS node group"
}

variable "max_size" {
    type = number
    description = "Maximum size of the EKS node group"
}

variable "min_size" {
    type = number
    description = "Minimum size of the EKS node group"
}