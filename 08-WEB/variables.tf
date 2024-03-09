variable "project_name" {
   default = "Roboshop" 
}

variable "environment" {
    default = "DEV"
}

variable "Component" {
    default = "WEB"
}

variable "common_tags" {
  default = {
    Terraform = true
    Environment = "DEV"
    Project = "ROBOSHOP"
    Component = "WEB"
  }
}

variable "target_group_port_num" {
    default = 80
}

variable "target_group_protocal" {
    default = "HTTP"
}

variable "health_check" {       
    default = {
        enabled = true
        interval = 15
        path = "/"
        port = 80
        protocol = "HTTP"
        timeout = 5
        healthy_threshold = 2 # consider as Healthy if 2 health checks are success
        unhealthy_threshold = 3 # consider as Un-Healthy if 3 health checks are failes
        matcher = "200-299" # Health check is success if HTTP status code in between 200-299
    }
}

variable "instance_type" {
    default = "t2.micro"
}

variable "launch_template_tags" {
    default = [
        {
            resource_type = "instance"
            tags = {
                Name = "WEB"
            }
        },
                {
            resource_type = "volume"
            tags = {
                Name = "WEB"
            }
        }
      
    ]
}

variable "max_size" {
    default = 10
}

variable "min_size" {
    default = 1
}

variable "desired_capacity" {
    default = 2
}

variable "health_check_grace_period" {
    default = 300
}

variable "health_check_type" {
    default = "ELB"
}

variable "autoscaling_tags" {
    default = [
        {
            key                 = "Name"
            value               = "WEB"
            propagate_at_launch = true
        },
        {
            key                 = "Project"
            value               = "Roboshop"
            propagate_at_launch = true
        },
                {
            key                 = "Terraform"
            value               = true
            propagate_at_launch = true
        },
                {
            key                 = "Component"
            value               = "Web"
            propagate_at_launch = true
        }
    ]
}



