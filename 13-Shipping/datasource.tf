data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/VPC-ID"
}

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

data "aws_ssm_parameter" "shipping_sg_id" {
  name = "/${var.project_name}/${var.environment}/SHIPPING-SG-ID"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"
}

data "aws_ssm_parameter" "app_alb_listner_arn" {
  name = "/${var.project_name}/${var.environment}/APP-ALB-LISTNER-ARN"
}