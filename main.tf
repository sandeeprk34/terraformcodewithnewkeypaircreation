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

######Creating a new key pair while launching an EC2 instance######
       ##1.Generate Public and Private Keys

resource "aws_key_pair" "mykeypair" {
  key_name   = "tfkey"
  public_key = ""ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVUA0A9W6hwOhj1n+Fn0vQ6bDkkxWkQSr4xmNv86gyV/ZrVoWdFhwiCa0sqs1IJcrDv3FcC9lUYiaEiKC+I6BEUSk9gE9PimVYDjGoUliAqPZWPNu9VpbQ1XPOY52XbrWi70KLI1NKqLAmrnLWloy8l31R6U5cdLhkqWMFuzaaIVyJvQwNB3m2jDlLsYkwn4vfGXCR6yRfMATvG2T1D81m6nrdb5kvfuoSi8TiQPZ8Ortfdji8Q4v0tcRJ0pQTqa1CL+zWmmHdTTsfFieOoKJ6f3sI/ungpmGzSQTsnBtAjrOEvag7QDiiUVfm5QMm0qR4COjjnJjelF65Z8vx7543 ec2-user@ip-172-31-29-10.us-west-2.compute.internal"
}

#####Spinning EC2 Instance####
resource "aws_instance" "myins" {
    ami = "${lookup(var.images, var.region)}" 
    instance_type = "t2.micro"
    associate_public_ip_address = "true"
    subnet_id = "${aws_subnet.pubsub1.id}"
    availability_zone = "${var.zones[0]}"
    vpc_security_group_ids = ["${aws_security_group.sec.id}"] 
    tags {
        Name = "TestEC2"   
    }
    key_name = "${aws_key_pair.mykeypair.key_name}"
}

####Get the running EC2 Instances#####

data "aws_instance" "insdata" {
  instance_id = "${aws_instance.myins.id}"

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}


######Creating an EBS Volume#####
resource "aws_ebs_volume" "myebs" {
  availability_zone = "us-west-2a"
  size              = 1
}



####Attaching an EBS Volume to the EC2 instance#####
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdl"
  volume_id   = "${aws_ebs_volume.myebs.id}"
  instance_id = "${data.aws_instance.insdata.instance_id}"
}


####Attaching an EBS Volume to the EC2 instance#####
#resource "aws_volume_attachment" "ebs_att" {
#  device_name = "/dev/sdz"
 # volume_id   = "${aws_ebs_volume.myebs.id}"
  #instance_id = "${aws_instance.myins.id}"
#}


 




