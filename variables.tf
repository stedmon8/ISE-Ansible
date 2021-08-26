# This credentials file is not encrypted for educational
# and demonstration purposes. It is highly recommended to
# encrypt this file with Ansible Vault or other encryption
# mechanism to protect your secrets!
 
 
 variable "accesskey" {
  type = string 
  default = "AKIAWGRXNRVQNLADJVLT" #<- put in your AWS access key here
}

variable "secretkey" {
    type = string 
    default = "Xq1NwqnSCCePE/qT7d6t10w1Z7JYU04RETD0gbph" #<- put in your AWS secret key here
}

 variable "ise_base_hostname" { #<- put in your AWS secret key here
  type = string 
  default = "ise"           #<- put in your AWS secret key here
}

 variable "ise_username" { 
  type = string 
  default = "admin"       #<- put in your AWS secret key here
}
 variable "ise_password" {
  type = string 
  default = "C!sco12345"   #<- put in your AWS secret key here
}
 variable "ise_ntp_server" { 
  default = "10.0.1.1"       #<- put in your AWS secret key here
}
 variable "ise_dns_server" {
  default = "10.0.1.1"       #<- put in your AWS secret key here
}
 variable "ise_domain" {
  type = string 
  default = "stbates.com"        #<- put in your AWS secret key here
}
 variable "ise_timezone" {
  type = string 
  default = "America/Costa_Rica"     #<- put in your AWS secret key here
}
 variable "aws_ise_ami" {
  type = string 
  default = "ami-0ef2cc6c45ca5fc1f"  #<-- Make sure this the correct AMI for your AWS Region. Check ISE cloud formation template for AMIs per region

 }



