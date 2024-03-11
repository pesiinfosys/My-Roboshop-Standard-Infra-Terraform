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

resource "aws_ssm_parameter" "redis_sg_id" {
  name  = "/${var.project_name}/${var.environment}/REDIS-SG-ID"
  type  = "String"
  value = module.redis_sg.sg_id
}

resource "aws_ssm_parameter" "user_sg_id" {
  name  = "/${var.project_name}/${var.environment}/USER-SG-ID"
  type  = "String"
  value = module.user_sg.sg_id
}

resource "aws_ssm_parameter" "cart_sg_id" {
  name  = "/${var.project_name}/${var.environment}/CART-SG-ID"
  type  = "String"
  value = module.cart_sg.sg_id
}

resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "/${var.project_name}/${var.environment}/MYSQL-SG-ID"
  type  = "String"
  value = module.mysql_sg.sg_id
}

resource "aws_ssm_parameter" "shipping_sg_id" {
  name  = "/${var.project_name}/${var.environment}/SHIPPING-SG-ID"
  type  = "String"
  value = module.shipping_sg.sg_id
}

resource "aws_ssm_parameter" "rabbitmq_sg_id" {
  name  = "/${var.project_name}/${var.environment}/RABBITMQ-SG-ID"
  type  = "String"
  value = module.rabbitmq_sg.sg_id
}

resource "aws_ssm_parameter" "payment_sg_id" {
  name  = "/${var.project_name}/${var.environment}/PAYMENT-SG-ID"
  type  = "String"
  value = module.payment_sg.sg_id
}