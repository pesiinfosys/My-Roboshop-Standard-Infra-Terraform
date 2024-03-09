data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/VPC-ID"
}

# quiring my ip address
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

# quiring default vpc for VPN 
data "aws_vpc" "default" {
  default = true
} 

