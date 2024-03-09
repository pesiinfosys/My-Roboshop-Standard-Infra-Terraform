module "web" {
    source = "../../Terraform-Roboshop-APP"
    project_name = var.project_name
    environment = var.environment
    Component = var.Component
    common_tags = var.common_tags
    
    ### Target Group
    target_group_port_num = var.target_group_port_num
    target_group_protocal = var.target_group_protocal
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    health_check = var.health_check

    ### Launch Template
    image_id = data.aws_ami.devops-practice.id
    instance_type = var.instance_type
    vpc_security_group_ids = data.aws_ssm_parameter.web_sg_id.value
    user_data = filebase64("${path.module}/web.sh")
    launch_template_tags = var.launch_template_tags

    ### Auto Scaling
    vpc_zone_identifier = split(",",data.aws_ssm_parameter.private_subnet_ids.value)
    max_size = var.max_size
    min_size = var.min_size
    desired_capacity = var.desired_capacity
    health_check_grace_period = var.health_check_grace_period
    health_check_type = var.health_check_type
    autoscaling_tags = var.autoscaling_tags

    # ### Auto Scaling Policy
    # ## defalut cpu threshold value 70.0
    # autoscaling_cpu_target_value = 70.0

    ### Listners
    web_alb_listener_arn = data.aws_ssm_parameter.web_alb_listner_arn.value
    listner_rule_priority = 10
    host_header = ["cloudevops.cloud" ]


}