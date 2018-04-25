#####Provider#####
provider "aws" {
 region     = "us-west-2"
}

######Creating a new key pair while launching an EC2 instance######
       ##1.Generate Public and Private Keys using the command ssh-keygen in the machine from where you are running the terraform file from 
        ## and copy the public key as shown below.

resource "aws_key_pair" "mykeypair" {
  key_name   = "tfkey"

 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCVUA0A9W6hwOhj1n+Fn0vQ6bDkkxWkQSr4xmNv86gyV/ZrVoWdFhwiCa0sqs1IJcrDv3FcC9lUYiaEiKC+I6BEUSk9gE9PimVYDjGoUliAqPZWPNu9VpbQ1XPOY52XbrWi70KLI1NKqLAmrnLWloy8l31R6U5cdLhkqWMFuzaaIVyJvQwNB3m2jDlLsYkwn4vfGXCR6yRfMATvG2T1D81m6nrdb5kvfuoSi8TiQPZ8Ortfdji8Q4v0tcRJ0pQTqa1CL+zWmmHdTTsfFieOoKJ6f3sI/ungpmGzSQTsnBtAjrOEvag7QDiiUVfm5QMm0qR4COjjnJjelF65Z8vx7543 ec2-user@ip-172-31-29-10.us-west-2.compute.internal"
 #public_key = "${file("tfkey.pub")}"    #Here we are giving the file location of public key file instead of hardcoding the public key.
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
}



 




