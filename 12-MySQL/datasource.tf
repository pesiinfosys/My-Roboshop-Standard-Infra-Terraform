data "aws_ami" "devops-practice" {

  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Centos-8-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ssm_parameter" "mysql_sg_id" {
  name = "/${var.project_name}/${var.environment}/MYSQL-SG-ID"
}

data "aws_ssm_parameter" "db_subnet_id" {
  name = "/${var.project_name}/${var.environment}/database-subnet-ids"
}