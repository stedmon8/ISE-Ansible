provider "aws" {
    region = "us-west-2"
    access_key = var.accesskey
    secret_key = var.secretkey
    version = "~> 3.48"
}

resource "aws_instance" "ISE_Server" {
   ami =  "ami-0a8b4f863885c3372"
   instance_type = "t2.micro"
   key_name = "terraform-key"
   vpc_security_group_ids = [aws_security_group.ISE_SG.id]
   user_data = "hostname={{ ise_base_hostname | lower }}-server\nprimarynameserver={{ ise_dns_server }}\ndnsdoISE_VPC={{ ise_doISE_VPC }}\nntpserver={{ ise_ntp_server }}\ntimezone={{ ise_timezone }}\nusername={{ ise_username }}\npassword={{ ise_password }}"
}

resource "aws_vpc" "ISE_VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "ISE VPC"
  }


}
 
resource "aws_subnet" "ISE_subnet" {
  vpc_id     = aws_vpc.ISE_VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "ISE_subnet"
  }
}


resource "aws_security_group" "ISE_SG" {
  name        = "ISE_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.ISE_VPC.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.ISE_VPC.cidr_block]
     
    }  


    ingress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.ISE_VPC.cidr_block]
  
    }
    ingress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.ISE_VPC.cidr_block]
     
    }
    ingress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 65535
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.ISE_VPC.cidr_block]

    }
  
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  

  tags = {
    Name = "allow_tls"
  }
}





   
