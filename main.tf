provider "aws" {
    region = "us-west-2"
    access_key = var.accesskey
    secret_key = var.secretkey
    version = "~> 3.48"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.pk.public_key_openssh

}

resource "local_file" "key" {
    filename = "deployer-key.pem"
    file_permission = "0400"
    directory_permission =  "0700"
}




resource "aws_instance" "ISE_Server" {
   ami =  "ami-0ef2cc6c45ca5fc1f"
   instance_type = "c5.4xlarge"
   key_name = aws_key_pair.deployer.key_name
   associate_public_ip_address = "true"
   vpc_security_group_ids = [aws_security_group.ISE_SG.id]
   subnet_id = aws_subnet.ISE_subnet.id
   user_data = "hostname=${var.ise_base_hostname}-server\nprimarynameserver=${var.ise_dns_server}\ndnsdomain=${var.ise_domain}\nntpserver=${ var.ise_ntp_server }\ntimezone=${ var.ise_timezone }\nusername=${var.ise_username}\npassword=${var.ise_password}"

   tags = {
     Name = "ISE_3.1_Server"
   }

    provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./deployer-key.pem"


    }





#     provisioner "local-exec" {
#         command     = <<-EOF
#                 echo "[ISE]" > inventory.ini
#                 echo ${self.public_ip} >> inventory.ini
#                 echo "[ISE:vars]" >> inventory.ini
#                 echo "ise_hostname: '${self.public_ip}'" >> inventory.ini
#                 echo "ise_username: 'admin'" >> inventory.ini
#                 echo "ise_password: 'C!sco12345'" >> inventory.ini
#                 echo "ise_verify: False" >> inventory.ini
#                 echo "ansible_ssh_private_key_file=~/Desktop/ansible/cisco/deployer-key.pem" >> inventory.ini
#                 echo "ansible_ssh_user=admin" >> inventory.ini

#                                 EOF

#     }

#     provisioner "local-exec" {
#             command     = <<-EOF
#        echo "#" > secrets2.yml
#        echo "# This credentials file is not encrypted for educational" >> secrets2.yml
#        echo "# and demonstration purposes. It is highly recommended to" >> secrets2.yml
#        echo "# encrypt this file with Ansible Vault or other encryption" >> secrets2.yml
#        echo "# mechanism to protect your secrets!" >> secrets2.yml
#        echo "#" >> secrets2.yml
#        echo "# ise_hostname:" >> secrets2.yml
#        echo "---" >> secrets2.yml
#        echo "ise_hostname: '${self.public_ip}'" >> secrets2.yml
#        echo "ise_username: 'admin'" >> secrets2.yml
#        echo "ise_password: 'C!sco12345'" >> secrets2.yml
#        echo "ise_verify: False" >> secrets2.yml
#        echo "radius_secret: 'C!sco12345'" >> secrets2.yml
#        echo "configured: 0" >> secrets2.yml
#        echo "exec-enable-password: '12345678'" >> secrets2.yml
#        echo "ise_url: https://${self.public_ip}:9060/ers/config/activedirectory" >> secrets2.yml
#        echo "condition_name: '8021x Switches'" >> secrets2.yml
#        echo "condition_dict_name: 'DEVICE'" >> secrets2.yml
#        echo "condition_att_name: 'Device Type'" >> secrets2.yml
#        echo "condition_att_value: 'All Device Types#Switches'" >> secrets2.yml
#                                     EOF

#     }

#    provisioner "remote-exec" {
#     inline = ["ping 8.8.8.8"]

#     connection {
#         type        = "ssh"
#         user        = "admin"
#         host        = self.public_ip
#         private_key = file("deployer-key.pem")
#         timeout = "33m"
#     }

# }
#     provisioner "local-exec" {
#     command = "sh use_me_first.sh"
# }
    
#     provisioner "local-exec" {
#     command = "sleep 120; ansible-playbook -i inventory.ini MAIN_ISE_config.yml"
# }

lifecycle {
      create_before_destroy = true 
    }

}

resource "aws_vpc" "ISE_VPC" {
  cidr_block       = "10.0.0.0/16"
 

  tags = {
    Name = "ISE VPC"
  }


}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ISE_VPC.id

  tags = {
    Name = "ISE_IGW"
  }
}

resource "aws_default_route_table" "ISE_routetable" {
  default_route_table_id = aws_vpc.ISE_VPC.default_route_table_id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
    }

  tags = {
    Name = "ISE_routetable"
  }
}
 
resource "aws_subnet" "ISE_subnet" {
  vpc_id     = aws_vpc.ISE_VPC.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true 


  tags = {
    Name = "ISE_subnet"
  }
}


resource "aws_security_group" "ISE_SG" {
  name        = "ISE_SG"
  description = "Allow inbound traffic to ISE"
  vpc_id      = aws_vpc.ISE_VPC.id

  ingress {
      description      = "Allow all traffic to ISE VPC"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = ["0.0.0.0/0"]
    #   cidr_blocks      = [aws_subnet.ISE_subnet.cidr_block]
     
    }  
# ingress {
#       description      = "TLS from VPC"
#       from_port        = 22
#       to_port          = 22
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     #   cidr_blocks      = [aws_subnet.ISE_subnet.cidr_block]
     
#     }  



#     ingress {
#       description      = "TLS from VPC"
#       from_port        = 0
#       to_port          = 65535
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     #   cidr_blocks      = [aws_subnet.ISE_subnet.cidr_block]
  
#     }
#     ingress {
#       description      = "TLS from VPC"
#       from_port        = 0
#       to_port          = 65535
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     #   cidr_blocks      = [aws_subnet.ISE_subnet.cidr_block]
     
#     }
#     ingress {
#       description      = "TLS from VPC"
#       from_port        = 0
#       to_port          = 65535
#       protocol         = "tcp"
#       cidr_blocks      = ["0.0.0.0/0"]
#     #   cidr_blocks      = [aws_subnet.ISE_subnet.cidr_block]

#     }
  
#   egress {
#       from_port        = 0
#       to_port          = 0
#       protocol         = "-1"
#       cidr_blocks      = ["0.0.0.0/0"]
#       ipv6_cidr_blocks = ["::/0"]
#     }
  

  tags = {
    Name = "ISE_SG"
  }
}

output "key" {
     
     value = aws_key_pair.deployer.public_key
     description = "This will show the puublic ip address of my ec2 instances"
   }





   
