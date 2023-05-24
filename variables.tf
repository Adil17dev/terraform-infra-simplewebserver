variable "region" {
    type = string
    description = "region where instance is setup"
    default = "ap-south-1"
}

variable "my_instance_type" {
    type = string
    description = "AWS instance type"
    default = "t2.micro"
}