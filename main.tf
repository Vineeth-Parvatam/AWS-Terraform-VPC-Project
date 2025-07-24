module "vpc" {
  source = "./modules/vpc"
  aws_region = "us-east-1"
  Name = var.project_name
  vpc_cidr_block = "10.1.0.0/16"
  public_subnet_cidr_block_a = "10.1.1.0/24"
  public_subnet_cidr_block_b = "10.1.2.0/24"
  private_subnet_cidr_block_a = "10.1.3.0/24"
  private_subnet_cidr_block_b = "10.1.4.0/24"
  availability_zone_a = "us-east-1a"
  availability_zone_b = "us-east-1b"
}