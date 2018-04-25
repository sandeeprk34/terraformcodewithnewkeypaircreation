#####Provider#####
provider "aws" {
 region     = "${var.region}"
}

#####VPC Creation#####
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpccidr}"
 
  tags {
    Name = "TerraTestVPC"
  }
}

####Data Sources for AZs######

#data "aws_availability_zone" "az1" {
# name = "us-west-2a"
#}

#data "aws_availability_zone" "az2" {
# name = "us-west-2b"
#}

#data "aws_availability_zones" "az" {
# name = ["us-west-2a","us-west-2b"]
#}



#####Subnets Creation#####

resource "aws_subnet" "pubsub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pubsubnet1}"
  map_public_ip_on_launch = true
  #availability_zone = "${data.aws_availability_zone.az1.name}"
  #availability_zone = "${data.aws_availability_zones.az.name[0]}"
   availability_zone = "${var.zones[0]}"
  tags {
    Name = "TerraPubSub1"
  }
}

resource "aws_subnet" "prisub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.prisubnet1}"
  availability_zone = "${var.zones[0]}"

  tags {
    Name = "TerraPriSub1"
  }
}


resource "aws_subnet" "pubsub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pubsubnet2}"
  map_public_ip_on_launch = true
  availability_zone = "${var.zones[1]}"

  tags {
    Name = "TerraPubSub2"
  }
}

resource "aws_subnet" "prisub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.prisubnet2}"
  availability_zone = "${var.zones[1]}"

  tags {
    Name = "TerraPriSub2"
  }
}

####IGW#####
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TerraIGW"
  }
}

######Route Table######

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "TerraRouteTable"
  }
}

### Subnet Associations to Route Table####

resource "aws_route_table_association" "a" {
  route_table_id = "${aws_route_table.r.id}"
  subnet_id      = "${aws_subnet.pubsub1.id}"
  
}

resource "aws_route_table_association" "b" {
  route_table_id = "${aws_route_table.r.id}"
  subnet_id     = "${aws_subnet.pubsub2.id}"
}


#####Security Group######
resource "aws_security_group" "sec" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
  tags {
    Name = "TerraSecGrp"
  }
}

#####Spinning EC2 Instance####
resource "aws_instance" "myins" {
    ami = "${lookup(var.images, var.region)}" 
    instance_type = "t2.micro"
    associate_public_ip_address = "true"
    subnet_id = "${aws_subnet.pubsub1.id}"
    vpc_security_group_ids = ["${aws_security_group.sec.id}"] 
    tags {
        Name = "TestEC2"
    }
    key_name = "${var.key_name}"
}
 
#####Create an ebs volume#####

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 1
}



