# quiring default vpc
data "aws_vpc" "default" {
  default = true
} 