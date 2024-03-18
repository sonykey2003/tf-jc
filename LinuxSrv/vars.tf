
# Getting the latest Linux AMIs from AWS marketplace
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
}

data "aws_ami" "rhel" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["RHEL-9.*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "amzn2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.*"]
  }
  filter {
      name = "virtualization-type"
      values = ["hvm"]
  }
  
}

# AWS Vars
variable "your-jc-username" {
  type = string
}

variable "my-aws-profile" {
  type = string
}

variable "INSTANCE_USERNAME" {
  #default = "ubuntu" # for ubuntu AMIs
  default = "ec2-user" # for other linux distro AMIs
}


variable "how-many-servers" {
  type = number
}

variable "AWS_REGION" {
  default = "ap-southeast-1"
}


#auto gen your public ip
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
