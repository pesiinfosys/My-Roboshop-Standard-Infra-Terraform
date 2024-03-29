###############################
###     TARGET-GROUP        ###
###############################

resource "aws_lb_target_group" "catalogue" {
  name     = "${var.project_name}-${var.common_tags.Component}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value

  health_check {
    enabled = true
    interval = 15
    path = "/health"
    port = 8080
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 2 # consider as Healthy if 2 health checks are success
    unhealthy_threshold = 3 # consider as Un-Healthy if 3 health checks are failes
    matcher = "200-299" # Health check is success if HTTP status code in between 200-299
  }
}

##################################
###     LAUNCH-TEMPLATE        ###
##################################

resource "aws_launch_template" "catalogue" {
  name = "${var.project_name}-${var.common_tags.Component}"
  image_id = data.aws_ami.devops-practice.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.catalogue_sg_id.value]

  tag_specifications {
    resource_type = "instance"

    tags = merge(
        var.common_tags,
        {
            Name = var.common_tags.Component
        }
    )
  }

  user_data = filebase64("${path.module}/catalogue.sh")
}


###################################
###         AUTO-SCALING        ###
###################################

resource "aws_autoscaling_group" "catalogue" {
  name                      = "${var.project_name}-${var.common_tags.Component}"
  max_size                  = 5
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }
 
  vpc_zone_identifier       = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  target_group_arns = [aws_lb_target_group.catalogue.arn]
  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "Name"
    value               = "Catalogue"
    propagate_at_launch = true
  }
}

###################################
###     AUTO-SCALING-POLICY     ###
###################################

resource "aws_autoscaling_policy" "catalogue" {
  autoscaling_group_name = aws_autoscaling_group.catalogue.name
  name                   = "cpu"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

################################
###     LISTNERS             ###
################################

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn = data.aws_ssm_parameter.app_alb_listner_arn.value
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.app.cloudevops.cloud"]
    }
  }
}