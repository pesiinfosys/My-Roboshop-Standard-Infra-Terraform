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
    Component = "Redis"
  }
}

variable "sg_tags" {
    default = {}
}

variable "ingress_rules" {
  default = {} # optional, because in futere also user can add/change the ingress rules
}

