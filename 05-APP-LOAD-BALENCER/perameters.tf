resource "aws_ssm_parameter" "app_alb_zone_id" {
  name  = "/${var.project_name}/${var.environment}/APP-ALB-ZONE-ID"
  type  = "String"
  value = aws_lb.app_alb.zone_id
}

resource "aws_ssm_parameter" "app_alb_listner_arn" {
  name  = "/${var.project_name}/${var.environment}/APP-ALB-LISTNER-ARN"
  type  = "String"
  value = aws_lb_listener.http.arn
}