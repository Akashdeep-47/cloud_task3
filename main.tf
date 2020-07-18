provider "aws" {
	region = "ap-south-1"
	profile = "sky"
}

# -- Creating vpc

resource "aws_vpc" "ak-vpc" {
	cidr_block       = "192.168.0.0/16"
	instance_tenancy = "default"
	enable_dns_hostnames = "true"

	tags = {
  		Name = "ak-vpc"
  	}
}

# -- Creating internet-gateway

resource "aws_internet_gateway" "ak-igw" {
	vpc_id = "${aws_vpc.ak-vpc.id}"

	tags = {
  		Name = "ak-igw"
  	}
}

# -- Creating subnet

data "aws_availability_zones" "zones" {
	state = "available"
}

# -- Creating public subnet

resource "aws_subnet" "public-subnet-1a" {
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
	cidr_block = "192.168.0.0/24"
	vpc_id = "${aws_vpc.ak-vpc.id}"
	map_public_ip_on_launch = "true"
 
	tags = {
		Name = "public-subnet-1a"
	}
}

# -- Creating private subnet

resource "aws_subnet" "private-subnet-1b" {
	availability_zone = "${data.aws_availability_zones.zones.names[1]}"
	cidr_block = "192.168.1.0/24"
	vpc_id = "${aws_vpc.ak-vpc.id}"

	tags = {
		Name = "private-subnet-1b"
	}
}

# -- Create route table

resource "aws_route_table" "ak-route-igw" {
	vpc_id = "${aws_vpc.ak-vpc.id}"

	route {
  		cidr_block = "0.0.0.0/0"
  		gateway_id = "${aws_internet_gateway.ak-igw.id}"
  	}
	
	tags = {
    		Name = "ak-route-igw"
  	}
}

# -- Subnet Association

resource "aws_route_table_association" "subnet-1a-asso" {
		subnet_id      = "${aws_subnet.public-subnet-1a.id}"
  		route_table_id = "${aws_route_table.ak-route-igw.id}"
}

# -- Creating Key Pairs for wordpress

resource "tls_private_key" "key1" {
	algorithm = "RSA"
	rsa_bits = 4096
}

resource "local_file" "key2" {
	content = "${tls_private_key.key1.private_key_pem}"
	filename = "wordpress_key.pem"
	file_permission = 0400
}

resource "aws_key_pair" "key3" {
	key_name = "wordpress_key"
	public_key = "${tls_private_key.key1.public_key_openssh}"
}

# -- Creating Key Pairs for mySql

resource "tls_private_key" "key4" {
	algorithm = "RSA"
	rsa_bits = 4096
}

resource "local_file" "key5" {
	content = "${tls_private_key.key4.private_key_pem}"
	filename = "mysql_key.pem"
	file_permission = 0400
}

resource "aws_key_pair" "key6" {
	key_name = "mysql_key"
	public_key = "${tls_private_key.key4.public_key_openssh}"
}

# -- Creating Security Groups for wordpress

resource "aws_security_group" "sg-wp" {
	name        = "wordpress-sg"
  	description = "Allow TLS inbound traffic"
  	vpc_id      = "${aws_vpc.ak-vpc.id}"


  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  	ingress {
    		description = "HTTP"
    		from_port   = 80
    		to_port     = 80
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "wordpress-sg"
  	}
}

# -- Creating Security Groups for mySql

resource "aws_security_group" "sg-db" {
	depends_on = [
		aws_security_group.sg-wp,
  	]
	name        = "mySql-sg"
  	description = "Allow TLS inbound traffic"
  	vpc_id      = "${aws_vpc.ak-vpc.id}"


  	ingress {
    		description = "SSH"
    		from_port   = 22
    		to_port     = 22
    		protocol    = "tcp"
    		cidr_blocks = [ "0.0.0.0/0" ]
  	}

  	ingress {
    		description = "MYSQL/Aurora"
    		from_port   = 3306
    		to_port     = 3306
    		protocol    = "tcp"
    		security_groups = [ "${aws_security_group.sg-wp.id}" ]
  	}

  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

  	tags = {
    		Name = "mySql-sg"
  	}
}

# -- Creatig Ec2 instance for mySql

resource "aws_instance" "database_server" {
  	ami = "ami-08706cb5f68222d09"
	subnet_id = "${aws_subnet.private-subnet-1b.id}"
	availability_zone = "${data.aws_availability_zones.zones.names[1]}"
  	instance_type = "t2.micro"
	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}
  	key_name = "${aws_key_pair.key6.key_name}"
  	vpc_security_group_ids = [ "${aws_security_group.sg-db.id}" ]
	
	tags = {
		Name = "MySql"
	}
}

# -- Creating Ec2 instance for wordpress

resource "aws_instance" "web_server" {
	depends_on = [
		aws_instance.database_server,
  	]
		
  	ami = "ami-004a955bfb611bf13"
	subnet_id = "${aws_subnet.public-subnet-1a.id}"
	availability_zone = "${data.aws_availability_zones.zones.names[0]}"
  	instance_type = "t2.micro"
	root_block_device {
		volume_type = "gp2"
		delete_on_termination = true
	}
  	key_name = "${aws_key_pair.key3.key_name}"
  	vpc_security_group_ids = [ "${aws_security_group.sg-wp.id}" ]
	associate_public_ip_address = true
	
	tags = {
		Name = "Wordpress"
	}
}

	
