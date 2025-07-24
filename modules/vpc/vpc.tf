# defining VPC and subnets for a demo project
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
      Name = "${var.Name}_vpc"
    }
}

resource "aws_subnet" "public_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr_block_a
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.Name}_public_subnet_a"
    }
}

resource "aws_subnet" "private_subnet_a" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_block_a
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.Name}_private_subnet_a"
    }
}

resource "aws_subnet" "public_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr_block_b
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = true
    tags = {
      Name = "${var.Name}_public_subnet"
    }
}

resource "aws_subnet" "private_subnet_b" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr_block_b
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = false
    tags = {
      Name = "${var.Name}_private_subnet"
    }
}

#defining elastic IP for NAT Gateway
resource "aws_eip" "nat_gateway_a" {
    domain = "vpc"
    tags = {
      Name = "${var.Name}_nat_eip_a"
    }
}

resource "aws_eip" "nat_gateway_b" {
    domain = "vpc"
    tags = {
      Name = "${var.Name}_nat_eip_b"
    }
}

#Defining gateway for the VPC
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "${var.Name}_internet_gateway"
    }
}

resource "aws_nat_gateway" "a" {
    allocation_id = aws_eip.nat_gateway_a.id
    subnet_id = aws_subnet.public_subnet_a.id
    tags = {
      Name = "${var.Name}_nat_gateway_a"
    }
} 

resource "aws_nat_gateway" "b" {
    allocation_id = aws_eip.nat_gateway_b.id
    subnet_id = aws_subnet.public_subnet_b.id
    tags = {
      Name = "${var.Name}_nat_gateway_b"
    }
}

# Defining route tables for public and private subnets
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
}

resource "aws_route_table" "private_a" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.a.id
    }
}
resource "aws_route_table" "private_b" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.b.id
    }
}

# Associating route tables with subnets
resource "aws_route_table_association" "public_subnet_a" {
    subnet_id = aws_subnet.public_subnet_a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_b" {
    subnet_id = aws_subnet.public_subnet_b.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_a" {
    subnet_id = aws_subnet.private_subnet_a.id
    route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_subnet_b" {
    subnet_id = aws_subnet.private_subnet_b.id
    route_table_id = aws_route_table.private_b.id
}

