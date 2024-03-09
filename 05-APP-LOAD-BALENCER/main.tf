#####################################
###     PRIVATE-LOAD-BALENCER      ###
#####################################
resource "aws_lb" "app_alb" {
  name               = "${var.project_name}-${var.common_tags.Component}"
  internal           = true # Private Load Balencer
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",",data.aws_ssm_parameter.private_subnet_ids.value)

#   enable_deletion_protection = true

  tags = merge(
    var.common_tags,
    {
        Name = "${var.project_name}-${var.common_tags.Component}"
    }
  )
}

###############
### LISTNER ###
###############

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response From APP-ALB"
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
      name    = "*.app"
      type    = "A"
      alias   = {
        name    = aws_lb.app_alb.dns_name
        zone_id = aws_lb.app_alb.zone_id
      }
    }
  ]
}