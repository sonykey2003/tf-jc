# Default VPC 
resource "aws_vpc" "linux-srv-vpc" {
  cidr_block = "10.10.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "linux-srv-vpc_${chomp(data.http.myip.response_body)}_${var.your-jc-username}"
  }
}

# Create a new internet getaway
resource "aws_internet_gateway" "linux-gw" {
  vpc_id = aws_vpc.linux-srv-vpc.id
  tags = {
    Name = "linux-wan-gw"
  }
}

# Create a new route table
resource "aws_route_table" "linux-public-crt" {
    vpc_id = aws_vpc.linux-srv-vpc.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.linux-gw.id
    }
    
    tags = {
        Name = "linux-public-crt"
    }
}

# Associating the crt to the ad subnet
resource "aws_route_table_association" "linux-public-crt"{
    subnet_id = aws_subnet.linux-subnet.id
    route_table_id = aws_route_table.linux-public-crt.id
}

# Creating internal networks
resource "aws_subnet" "linux-subnet" {
  vpc_id     = aws_vpc.linux-srv-vpc.id
  cidr_block = "10.10.11.0/24" 
  map_public_ip_on_launch = true
  tags = {
    Name = "linux-subnet"
  }
}
# Creating security groups for internet connectivities
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  vpc_id      =  aws_vpc.linux-srv-vpc.id
  description = "security group that allows rdp from my home IP and all egress traffic"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
  }
  
  tags = {
    Name = "allow-ssh"
  }

}


# Creating security groups for private subnet connectivities
resource "aws_security_group" "allow-internal-all" {
  name        = "allow-internal-all"
  vpc_id      =  aws_vpc.linux-srv-vpc.id
  description = "security group that allows all traffic from the same subnet"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.10.11.0/24"] # Find a free subnet within your VPC
  }
  
 
  tags = {
    Name = "allow-internal-all"
  }

}



