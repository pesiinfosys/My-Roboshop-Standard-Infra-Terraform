module "ec2_mysql" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops-practice.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [data.aws_ssm_parameter.mysql_sg_id.value]
  # subnet_id              = data.aws_ssm_parameter.db_subnet_id.value[0]
  subnet_id = local.db_subnet_id
  user_data = file("mysql.sh")
  tags = merge(
    var.common_tags,
    {
        Name = "MySQL"
    }
   
  )
}

###################################
###      ROUTE53-RECORDS      ###
###################################
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  zone_name = "cloudevops.cloud"

  records = [
    {
      name    = "mysql"
      type    = "A"
      ttl     = 1
      records = [module.ec2_mysql.private_ip]
    }
  ]
}