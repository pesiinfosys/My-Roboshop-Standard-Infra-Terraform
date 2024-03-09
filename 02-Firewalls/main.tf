##################################
###        SECURITY-GROUPS     ###
##################################
### Creating VPN Security-Group
module "vpn_sg" {
  source = "../../Terraform-AWS-SecurityGroups"
  sg_name = "VPN"
  sg_description = "Allow all traffic from myip to VPN"
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
  sg_description = "Allow  traffic From Catalogue,User and VPN to mongodb"
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
  sg_description = "Allow  traffic From WEB and VPN"
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
  sg_description = "Allow all traffic from VPN and Pub-ALB to Web"
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
  sg_description = "Allow traffic from internet and vpn"
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
  sg_description = "Allow traffic from web and vpn"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  project_name = "Roboshop"
  common_tags = merge(
    var.common_tags,
    {
        Component = "APP-ALB"
    }
  )
}

##################################
###        INGRESS-RULES       ###
##################################

### Allow traffic from MyIP to VPN on all ports
resource "aws_security_group_rule" "vpn_myip" {
  type              = "ingress"
  description       = "Allow traffic from MyIP to VPN on all ports"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.myip.response_body)}/32"]
  security_group_id = module.vpn_sg.sg_id
}

### This is allowing all catalogue instances to all mongodb instances
resource "aws_security_group_rule" "mongodb_catalogue" {
  type              = "ingress"
  description       = "Allowing traffic from catalogue to mongodb on port number 27017"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

### This is allowing all vpn instances SSH to all mongodb instances for trouble shooting
resource "aws_security_group_rule" "mongodb_vpn" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to mongodb on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.mongodb_sg.sg_id
}

### This is allowing all vpn instances SSH to all catalogue instances for trouble shooting
resource "aws_security_group_rule" "catalogue_vpn" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to catalogue on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

### This is allowing traffic APP-ALB to all catalogue instances on 8080
resource "aws_security_group_rule" "catalogue_app_alb" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to catalogue on port number 22"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb_sg.sg_id
  security_group_id = module.catalogue_sg.sg_id
}

### This is allowing traffic from WEB to APP-ALB on 80
resource "aws_security_group_rule" "app_alb_web" {
  type              = "ingress"
  description       = "Allowing SSH from web to app_alb on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

### This is allowing SSH traffic from VPN to APP-ALB on 22
resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  description       = "Allowing HTTP from vpn to APP ALB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.app_alb_sg.sg_id
}

### This is allowing traffic from WEB to APP-ALB on 80
resource "aws_security_group_rule" "web_alb_web" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to catalogue on port number 22"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb_sg.sg_id
  security_group_id = module.web_sg.sg_id
}


resource "aws_security_group_rule" "web_alb_vpn" {
  type              = "ingress"
  description       = "Allowing HTTP from vpn to WEB ALB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_alb_sg.sg_id
}

### This is allowing SSH traffic from VPN to WEB on 22 for trouble shooting
resource "aws_security_group_rule" "web_vpn_ssh" {
  type              = "ingress"
  description       = "Allowing SSH from vpn to WEB on port number 22"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}

### This is allowing SSH traffic from VPN to WEB on 22 for trouble shooting
resource "aws_security_group_rule" "web_vpn_http" {
  type              = "ingress"
  description       = "Allowing HTTP from vpn to WEB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn_sg.sg_id
  security_group_id = module.web_sg.sg_id
}

### This is allowing traffic from Internet to WEB-ALB on 80 for HHTP
resource "aws_security_group_rule" "web_alb_internet_http" {
  type              = "ingress"
  description       = "Allowing Internet Traffic to WEB ALB on port number 80"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}

### This is allowing traffic from Internet to WEB-ALB on 443 for HTTPS
resource "aws_security_group_rule" "web_alb_internet_https" {
  type              = "ingress"
  description       = "Allowing Internet Traffic to WEB ALB on port number 443"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks        = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.sg_id
}