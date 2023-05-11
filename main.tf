provider "aws" {
    region = "ap-south-1"
}
#Creation of vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

   tags = {
     Name = "cis"
  }
}


#public subnet
resource "aws_subnet" "cisbenchmarkpublic" {
  vpc_id                  = aws_vpc.main.id,
  cidr_block              = "10.0.1.0/24",
  map_public_ip_on_launch = "true",
  availability_zone       = "ap-south-1a"

    tags = {
      Name = "cisbenchmarkpublic"
  }
}
#public subnet
resource "aws_subnet" "cisbenchmarkprivate" {
  vpc_id                  = aws_vpc.main.id,
  cidr_block              = "10.0.2.0/24",
  map_public_ip_on_launch = "false",
  availability_zone       = "ap-south-1b"

    tags = {
      Name = "cisbenchmarkprivate"
  }
}
