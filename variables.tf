
 variable "accesskey" {
  type = string 
  default = "AKIAWGRXNRVQHNQANY4C"
}

variable "secretkey" {
    type = string 
    default = "hDMXCaDA00tcP8rFjK3T9I4AzTjkJTE5IeGY5EzA"
}

 variable "ise_base_hostname" {
  type = string 
  default = "ISE"
}

 variable "ise_username" {
  type = string 
  default = "admin"
}
 variable "ise_password" {
  type = string 
  default = "C!sco12345"
}
 variable "ise_ntp_server" {
  type = string 
  default = ""
}
 variable "ise_dns_server" {
  type = string 
  default = "8.8.8.8"
}
 variable "ise_domain" {
  type = string 
  default = "sstcloud.com"
}
 variable "ise_timezone" {
  type = string 
  default = "America/Costa_Rica"
}
 variable "aws_ise_ami" {
  type = string 
  default = "ami-0a8b4f863885c3372"
}
 variable "aws_vpc_name" {
  type = string 
  default = "ISE VPC"
}
 variable "aws_vpc_cidr" {
  type = string 
  default = "10.10.0.0/16"
}
 variable "aws_subnet_cidr" {
  type = string 
  default = "10.10.1.0/24"
}

 variable "aws_region" {
  type = string 
  default = "us-west-2"
}
 variable "aws_keypair_name" {
  type = string 
  default = "ise_deployment"
}
 variable "aws_instance_type" {
  type = string 
  default = "c5.4xlarge"
}




