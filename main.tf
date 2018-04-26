#####Provider#####
provider "aws" {
 region     = "us-west-2"
}

######Creating a new key pair while launching an EC2 instance######
       ##1.Generate Public and Private Keys using the command ssh-keygen in the machine from where you are running the terraform file from 
        ## and copy the public key as shown below.

resource "aws_key_pair" "mykeypair" {
  key_name   = "tfkey"
 
 #####Hardcoding the public key#####
 public_key = ""
 #######Giving the Public key path######
 public_key = "${file("tfkey.pub")}"    
 }


#####Spinning EC2 Instance####
resource "aws_instance" "myins" {
    ami = "ami-223f945a" 
    instance_type = "t2.micro"
    associate_public_ip_address = "true"
    
    tags {
        Name = "TestEC2"   
    }
    key_name = "${aws_key_pair.mykeypair.key_name}"
   #####For the user data 
    # 1>I am directly writing the user data script here only as shown below
   
    user_data= << EOF
         #! /bin/bash
         yum install -y httpd
         service httpd start
         chkconfig httpd on
         echo  "<h1>Terraform</h1>" > /var/www/html/index.html
    EOF
  # 2>Or We can create file with th user data and give the file path using the file function.
    user_data =  "${file("installhttpd.sh")}"             
 
    
}



 




