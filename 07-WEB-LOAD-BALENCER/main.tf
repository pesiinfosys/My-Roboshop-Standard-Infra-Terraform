##############################
###     LOAD-BALENCER      ###
##############################
resource "aws_lb" "web_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = false    # Public Load Balencer
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.web_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.public_subnet_ids.value)

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.common_tags.Component}"
    }
  )
}

#######################
### ACM-CERTIFICATE ###
#######################
### Creating Certificate for HTTPS in Amazon Certificate Manager(ACM)

resource "aws_acm_certificate" "cloudevops" {
  domain_name       = "cloudevops.cloud"
  validation_method = "DNS"

  tags = var.common_tags
}

data "aws_route53_zone" "cloudevops" {
  name         = "cloudevops.cloud"
  private_zone = false
}

resource "aws_route53_record" "cloudevops" {
  for_each = {
    for dvo in aws_acm_certificate.cloudevops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.cloudevops.zone_id
}

resource "aws_acm_certificate_validation" "cloudevops" {
  certificate_arn         = aws_acm_certificate.cloudevops.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudevops : record.fqdn]
}

###############
### LISTNER ###
###############

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cloudevops.arn

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.front_end.arn
  # }
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "This Is The Fixed response From WEB-ALB"
      status_code  = "200"
    }
  }
}

#######################
### Route-53 RECORD ###
#######################

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "cloudevops.cloud"

  records = [
    {
      name    = ""
      type    = "A"
      alias   = {
        name    = aws_lb.web_alb.dns_name
        zone_id = aws_lb.web_alb.zone_id
      }
    }
  ]
}