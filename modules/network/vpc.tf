resource "aws_vpc" "main" {
        cidr_block= var.cidr_block
        enable_dns_support = true
        enable_dns_hostnames= true
  tags = {
    Name = "Main VPC"
  }
}

#---------------
#Internet Gateway
#---------------
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "Main IGW"
    }
}

#---------------
#Public Subnet
#---------------
resource "aws_subnet" "public"{
    count = length(var.public_cidr_block)

    vpc_id = aws_vpc.main.id
    cidr_block =  var.public_cidr_block[count.index]
    availability_zone = var.availability_zone[count.index]
    map_public_ip_on_launch = true
}

#Route Table for Public Subnet
resource "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_route" {
        destination_cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
        route_table_id = aws_route_table.public.id 
    }


#Route Table Association for Public Subnet
resource "aws_route_table_association" "PublicRouteAssociation"{
    count = length(var.public_cidr_block)

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id 
}

#---------------
#Private Subnet
#---------------
resource "aws_subnet" "private"{
    count = length(var.private_cidr_block)

    vpc_id = aws_vpc.main.id
    cidr_block =  var.private_cidr_block[count.index]
    availability_zone = var.availability_zone[count.index]
}

#Route Table for Private Subnet
resource "aws_route_table" "private"{
    count = length(var.private_cidr_block)
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "private"{
        count = length(var.private_cidr_block)

        route_table_id = aws_route_table.private[count.index].id
        destination_cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.default[count.index].id
    }

#Route Table Association for Private Subnet
resource "aws_route_table_association" "PrivateRouteAssociation"{
    count = length(var.private_cidr_block)

    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private[count.index].id 
}

# NAT resources for the private subnet 
resource "aws_eip" "nat" {
  count = length(var.public_cidr_block)
  domain = "vpc"
}

resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.igw]

  count = length(var.public_cidr_block)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}
