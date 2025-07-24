variable "aws_region" {
    description = "value of the AWS region to use"
    type = string
    default = "us-east-1"
}

variable "Name" {
    description = "Name of the project"
    type = string
    default = "demo_project"
}

variable "vpc_cidr_block" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block_a" {
    description = "CIDR block for public subnet in availability zone A"
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block_a" {
    description = "CIDR block for private subnet in availability zone A"
    type = string
    default = "10.0.2.0/24"
}

variable "public_subnet_cidr_block_b" {
    description = "CIDR block for public subnet in availability zone B"
    type = string
    default = "10.0.3.0/24"
}

variable "private_subnet_cidr_block_b" {
    description = "CIDR block for private subnet in availability zone B"
    type = string
    default = "10.0.4.0/24"
}
variable "availability_zone_a" {
    description = "Availability zone A for the subnets"
    type = string
    default = "us-east-1a"
}

variable "availability_zone_b" {
    description = "Availability zone B for the subnets"
    type = string
    default = "us-east-1b"
}