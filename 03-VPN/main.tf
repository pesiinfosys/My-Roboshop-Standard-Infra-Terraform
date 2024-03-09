module "ec2_vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops-practice.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  ### NOTE: If we don't provide the subnet_id , by default it will provision inside defalut VPC under public subnet, in this case we need public subnet of default VPC
#   subnet_id              = local.public_subnet_ids[0]

  tags = merge(
    var.common_tags,
    {
        Name = "VPN"
    }
   
  )
}