module "vpc" {
  # source = "../../Terraform-AWS-VPC"
  source = "git::https://github.com/pesiinfosys/Terraform-AWS-VPC.git"
  project_name = var.project_name
  cidr_block = var.cidr_block
  common_tags = var.common_tags
  enable_dns_support = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  public_subnet_cidr_block = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  database_subnet_cidr_block = var.database_subnet_cidr_block
  requester_vpc_id = data.aws_vpc.default.id
  is_peering_required = var.is_peering_required
  default_route_table_id = data.aws_vpc.default.main_route_table_id
  default_cidr_block = data.aws_vpc.default.cidr_block
  
}