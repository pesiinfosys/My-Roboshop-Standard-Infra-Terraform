variable "project_name" {
   default = "Roboshop" 
}

variable "environment" {
    default = "DEV"
}

variable "Component" {
    default = "Cart"
}

variable "common_tags" {
  default = {
    Terraform = true
    Environment = "DEV"
    Project = "ROBOSHOP"
    Component = "Cart"
  }
}

variable "target_group_port_num" {
    default = 8080
}

variable "target_group_protocal" {
    default = "HTTP"
}


variable "instance_type" {
    default = "t2.micro"
}

variable "launch_template_tags" {
    default = [
        {
            resource_type = "instance"
            tags = {
                Name = "Cart"
            }
        },
                {
            resource_type = "volume"
            tags = {
                Name = "Cart"
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
            value               = "Cart"
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
            value               = "Cart"
            propagate_at_launch = true
        }
    ]
}



