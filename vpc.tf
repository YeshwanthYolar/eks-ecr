# VPC and Networking#############
resource "aws_vpc" "eks-cluster-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "eks-cluster-vpc"
  }
}

# Subnets
data "aws_availability_zones" "available" {}

#subnet for eks-cluster
resource "aws_subnet" "public" {
  count                   = length(var.subnet_cidr_blocks)
  vpc_id                  = aws_vpc.eks-cluster-vpc.id
  cidr_block              = var.subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index+1}"
  }
}

#internet_gateway for eks-cluster
resource "aws_internet_gateway" "igw-eks-cluster" {
  vpc_id = aws_vpc.eks-cluster-vpc.id

  tags = {
    Name = "igw-eks-cluster"
  }
}

# route-table for eks-cluster
resource "aws_route_table" "rt-eks-cluster" {
  vpc_id = aws_vpc.eks-cluster-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-eks-cluster.id
  }
   tags = {
    Name = "rt-eks-cluster"
  }
}

# subnet association with route-table
resource "aws_route_table_association" "public" {
    count =  length(var.subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.rt-eks-cluster.id
}