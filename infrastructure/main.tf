# Instantiate the VPC module
module "vpc" {
  source = "../modules/network"  # Path to your VPC module directory

  # Pass variables to the VPC module
  cidr_block         = "10.0.0.0/16"
  public_cidr_block  = ["10.0.1.0/24","10.0.2.0/24"]
  private_cidr_block = ["10.0.10.0/24","10.0.11.0/24"]
  availability_zone  = ["us-east-1a","us-east-1b"]
}
