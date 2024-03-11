##################################
###        SECURITY-GROUPS     ###
##################################
### Creating VPN Security-Group
module "vpn_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "VPN"
  sg_description = "VPN Instances Security-Group"
  vpc_id = data.aws_vpc.default.id
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "VPN"
    }
  )
}

### Creating MongoDB Security-Group
module "mongodb_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "MongoDB"
  sg_description = "MongoDB Instances Security-Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "MongoDB"
    }
  )
}

### Creating Catalogue Security-Group
module "catalogue_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "Catalogue"
  sg_description = "Catalogue Instances Security-Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "Catalogue"
    }
  )
}

### Creating WEB Security-Group
module "web_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "WEB"
  sg_description = "WEB Instances Security-Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "WEB"
    }
  )
}

### Creating WEB-ALB (Public Application Load Balencer) Security-Group
module "web_alb_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "WEB-ALB-Public"
  sg_description = "Web(Public) Load Balencers Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "WEB-ALB"
    }
  )
}

### Creating APP-ALB (Private Application Load Balencer) Security-Group
module "app_alb_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "APP-ALB-Private"
  sg_description = "APP(Private) Load Balencers Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "APP-ALB"
    }
  )
}

module "redis_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "Redis"
  sg_description = "Redis Instances Security-Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "Redis"
    }
  )
}

module "user_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "User"
  sg_description = "User Instances Security-Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "User"
    }
  )
}


module "cart_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "Cart"
  sg_description = "Cart Instances Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "Cart"
    }
  )
}

module "mysql_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "MySQL"
  sg_description = "MySQL Instances Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "MySQL"
    }
  )
}

module "shipping_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "Shipping"
  sg_description = "Shipping Instances Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "Shipping"
    }
  )
}

module "rabbitmq_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "RabbitMQ"
  sg_description = "RabbitMQ Instances Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "RabbitMQ"
    }
  )
}

module "payment_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "Payment"
  sg_description = "Payment Instances Security Group"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "Payment"
    }
  )
}


##################################
###        INGRESS-RULES       ###
##################################

### Allow traffic from MyIP to VPN on all ports
resource "aws_security_group_rule" "myip-vpn" {
  type              = "ingress"
  description       = "Allow traffic from MyIP to VPN on all ports"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = module.vpn_sg.sg_id
}

### This is connect all catalogue instances to all mongodb instances on 27017
resource "aws_security_group_rule" "catalogue-mongodb" {
  type              = "ingress"
  description       = "Allowing requets from catalogue to mongodb on port number 27017"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

### This is allowing all vpn instances SSH to all mongodb instances for trouble shooting
resource "aws_security_group_rule" "vpn-mongodb" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to mongodb on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

### This is allowing all vpn instances SSH to all catalogue instances for trouble shooting
resource "aws_security_group_rule" "vpn-catalogue" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to catalogue on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

### This is allowing requests from APPALB to all catalogue instances on 8080
resource "aws_security_group_rule" "app_alb-catalogue" {
  type              = "ingress"
  description       = "Allowing requests from APP-ALB to Catalogue on 8080"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

### This is allowing requests from all WEB instances to APP-ALB on 80
resource "aws_security_group_rule" "web-app_alb" {
  type              = "ingress"
  description       = "Allowing requests from WEB to APP-ALB on 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

### This is allowing requests from all VPN instances to APP_ALB on 80
resource "aws_security_group_rule" "vpn-app_alb" {
  type              = "ingress"
  description       = "Allowing requests from VPN to APP_ALB on 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

### This is allowing requests from WEB_ALB to all WEB instances on 80
resource "aws_security_group_rule" "web_alb-web" {
  type              = "ingress"
  description       = "Allowing requests from WEB-ALB to WEB on 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.web_sg.sg_id
}

### This is allowing requests from VPN to all WEB_ALB instances on 80
resource "aws_security_group_rule" "vpn-web_alb" {
  type              = "ingress"
  description       = "Allowing requests from VPN to WEB_ALB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_alb_sg.sg_id
}

### This is allowing SSH traffic from all VPN instances to all WEB instances on 22 for trouble shooting
resource "aws_security_group_rule" "vpn-web_ssh" {
  type              = "ingress"
  description       = "Allowing SSH requests from VPN to WEB on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}

### This is allowing HTTP requests from all VPN instances to all WEB instances on 80 for trouble shooting
resource "aws_security_group_rule" "vpn-web_http" {
  type              = "ingress"
  description       = "Allowing HTTP traffic from VPN to WEB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}

# ### This is allowing HTTP requests from Internet to WEB_ALB on port number 80
# resource "aws_security_group_rule" "web_alb-internet_http" {
#   type              = "ingress"
#   description       = "Allowing HTTP requests from Internet to WEB_ALB on port number 80"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks        = ["0.0.0.0/0"]
#   security_group_id = module.web_alb_sg.sg_id
# }

### This is allowing HTTPS requests from Internet to WEB_ALB on port number 443
resource "aws_security_group_rule" "web_alb_internet_https" {
  type              = "ingress"
  description       = "Allowing Internet Traffic to WEB_ALB on port number 443"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}

### This is allowing requests from all User instances to all Redis instances on 6379 
resource "aws_security_group_rule" "user-redis" {
  type              = "ingress"
  description       = "Allowing requests from USER to REDIS on port number 6379"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.user_sg.sg_id
  security_group_id = module.redis_sg.sg_id
}

### This is allowing SSH from all VPN instances to all Redis instances on 22 
resource "aws_security_group_rule" "vpn-redis" {
  type              = "ingress"
  description       = "Allowing SSH from VPN to REDIS on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.redis_sg.sg_id
}

### This is allowing requests from APP-ALB to all USER instances on 8080 
resource "aws_security_group_rule" "app_alb-user" {
  type              = "ingress"
  description       = "Allowing APP-ALB to User on port number 8080"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.user_sg.sg_id
}

### This is allowing SSH from all VPN instances to USER instances on 22 
resource "aws_security_group_rule" "vpn-user" {
  type              = "ingress"
  description       = "Allowing SSH requests from VPN to USER on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.user_sg.sg_id
}

### This is allowing requests from all User instances to all MongoDB instances on 27017 
resource "aws_security_group_rule" "user-mongodb" {
  type              = "ingress"
  description       = "Allowing requests from USER to MongoDB on port number 27017"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.user_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

### This is allowingrequests from all VPN instances to all Cart instances on 22 
resource "aws_security_group_rule" "vpn-cart" {
  type              = "ingress"
  description       = "Allowing SSH requests from VPN to CART on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.cart_sg.sg_id
}

### This is allowing requests from APP-ALB to all Cart instances on 8080 
resource "aws_security_group_rule" "app_alb-cart" {
  type              = "ingress"
  description       = "Allowing requests from APP-ALB to CART on port number 8080"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.cart_sg.sg_id
}

### This is allowing traffic from Cart to Catalogue on 80
## This is to communicate Cart with Catalogue via APP-ALB
resource "aws_security_group_rule" "cart-app_alb" {
  type              = "ingress"
  description       = "Allowing requests from CART to APP_ALB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

### This is allowing requests from all Cart instances to all Redis instances on 6379 
resource "aws_security_group_rule" "cart-redis" {
  type              = "ingress"
  description       = "Allowing requests from CART to REDIS on port number 6379"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  source_security_group_id = module.cart_sg.sg_id
  security_group_id = module.redis_sg.sg_id
}

### This is allowing all VPN instances SSH to all MySQL instances for trouble shooting
resource "aws_security_group_rule" "vpn-mysql" {
  type              = "ingress"
  description       = "Allowing SSH from VPN to MYSQL on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

### This is allowing all VPN instances SSH to all SHIPPING instances for trouble shooting
resource "aws_security_group_rule" "vpn-shipping" {
  type              = "ingress"
  description       = "Allowing SSH from VPN to SHIPPING on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.shipping_sg.sg_id
}

### This is allowing all SHIPPING instances requests to all MYSQL instances on port number 
resource "aws_security_group_rule" "shipping-mysql" {
  type              = "ingress"
  description       = "Allowing requests from SHIPPING to MYSQL on port number 3306"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.shipping_sg.sg_id
  security_group_id = module.mysql_sg.sg_id
}

### This is allowing requests from APP-ALB to all SHIPPING instances on 8080 
resource "aws_security_group_rule" "app_alb-shipping" {
  type              = "ingress"
  description       = "Allowing requests from APP-ALB to SHIPPING on port number 8080"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.shipping_sg.sg_id
}

### This is allowing all vpn instances SSH to all RABBITMQ instances for trouble shooting
resource "aws_security_group_rule" "vpn-rabbitmq" {
  type              = "ingress"
  description       = "Allowing SSH from VPN to RABBITMQ on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.rabbitmq_sg.sg_id
}

### This is allowing requests from all PAYMENT instances to all RABBITMQ instances on port number 5672
resource "aws_security_group_rule" "payment-rabbitmq" {
  type              = "ingress"
  description       = "Allowing SSH from PAYMENT to RABBITMQ on port number 22"
  from_port         = 5672
  to_port           = 5672
  protocol          = "tcp"
  source_security_group_id = module.payment_sg.sg_id
  security_group_id = module.rabbitmq_sg.sg_id
}

### This is allowing all VPN instances SSH to all PAYMENT instances for trouble shooting
resource "aws_security_group_rule" "vpn-payment" {
  type              = "ingress"
  description       = "Allowing SSH from VPN to PAYMENT on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.payment_sg.sg_id
}

### This is allowing requests from APP-ALB to all PAYMENT instances on 8080 
resource "aws_security_group_rule" "app_alb-payment" {
  type              = "ingress"
  description       = "Allowing requests from APP-ALB to PAYMENT on port number 8080"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.payment_sg.sg_id
}



