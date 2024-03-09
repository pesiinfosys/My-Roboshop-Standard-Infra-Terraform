resource "aws_ssm_parameter" "web_alb_zone_id" {
  name  = "/${var.project_name}/${var.environment}/WEB-ALB-ZONE-ID"
  type  = "String"
  value = aws_lb.web_alb.zone_id
}

resource "aws_ssm_parameter" "web_alb_listner_arn" {
  name  = "/${var.project_name}/${var.environment}/WEB-ALB-LISTNER-ARN"
  type  = "String"
  value = aws_lb_listener.https.arn
}