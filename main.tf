resource "aws_vpc" "Tier2-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.Tier2-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.aws_aviability_zone

}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.Tier2-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.aws_aviability_zone
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.Tier2-vpc.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Tier2-vpc.id
}

resource "aws_route" "outbound_traffic" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
  route_table_id         = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

/**
 * Public EC2 instance
 */

resource "aws_instance" "ec2_instance_public" {
  ami           = var.ec2_ami_micro
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet1.id
}

resource "aws_ec2_instance_connect_endpoint" "ec2_instance_public_connection" {
  subnet_id = aws_subnet.public_subnet1.id
}

resource "aws_ec2_instance_state" "ec2_instance_public_state" {
  instance_id = aws_instance.ec2_instance_public.id
  state       = var.ec2_running ? "running" : "stopped"
}

/**
 * Private EC2 instance
 */

resource "aws_instance" "ec2_instance_private" {
  ami           = var.ec2_ami_micro
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet1.id
}

resource "aws_ec2_instance_connect_endpoint" "ec2_instance_private_connection" {
  subnet_id = aws_subnet.private_subnet1.id
}

resource "aws_ec2_instance_state" "ec2_instance_private_state" {
  instance_id = aws_instance.ec2_instance_private.id
  state       = var.ec2_running ? "running" : "stopped"
}
