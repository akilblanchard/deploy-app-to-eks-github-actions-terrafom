# Instantiate the VPC module
module "vpc" {
  source = "../modules/network"  # Path to your VPC module directory

  # Pass variables to the VPC module
  cidr_block         = "10.0.0.0/16"
  public_cidr_block  = ["10.0.1.0/24","10.0.2.0/24", "10.0.3.0/24"]
  private_cidr_block = ["10.0.10.0/24","10.0.11.0/24", "10.0.12.0/24"]
  availability_zone  = ["us-east-1a","us-east-1b", "us-east-1c"]
}

module "eks_cluster" {
  source = "./modules/eks"

  cluster_name = "eks-cluster"
  node_group_name = "private-nodes"
  instance_type = ["t3.small"]
  desired_size = 2
  max_size = 3
  min_size = 1
  private_subnet_ids = module.my_vpc.private_subnets
  public_subnet_ids  = module.my_vpc.public_subnets
}