variable "project_name" {
    default = "Roboshop"
}

variable "environment" {
  default = "DEV"
}

variable "common_tags" {
  default = {
    Terraform = true
    Environment = "DEV"
    Project = "ROBOSHOP"
    Component = "WEB-ALB"
  }
}