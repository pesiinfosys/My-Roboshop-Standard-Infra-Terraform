resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project_name}/${var.environment}/VPN-SG-ID"
  type  = "String"
  value = module.vpn_sg.sg_id
}

resource "aws_ssm_parameter" "catalogue_sg_id" {
  name  = "/${var.project_name}/${var.environment}/CATALOGUE-SG-ID"
  type  = "String"
  value = module.catalogue_sg.sg_id
}

resource "aws_ssm_parameter" "mongodb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/MONGODB-SG-ID"
  type  = "String"
  value = module.mongodb_sg.sg_id
}

resource "aws_ssm_parameter" "web_sg_id" {
  name  = "/${var.project_name}/${var.environment}/WEB-SG-ID"
  type  = "String"
  value = module.web_sg.sg_id
}

resource "aws_ssm_parameter" "web_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/WEB-ALB-SG-ID"
  type  = "String"
  value = module.web_alb_sg.sg_id
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/APP-ALB-SG-ID"
  type  = "String"
  value = module.app_alb_sg.sg_id
}