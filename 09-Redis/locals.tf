locals{
    db_subnet_id = element(split(",",data.aws_ssm_parameter.db_subnet_id.value),0)
}