####Variables#####

variable "region" {
  default = "us-west-2"
}


variable "images" {
  type = "map"

  default = {
    us-west-2 = "ami-223f945a"
  }
}

variable "zones" {
  default = ["us-west-2a", "us-west-2b"]
}

variable "vpccidr" {
    default = "10.0.0.0/16"
  description = "This is the vpc cdir"
}
variable "pubsubnet1" {
  default = "10.0.1.0/24"
  description = "This is the cidr for Public subnet1"
}
variable "prisubnet1" {
  default = "10.0.2.0/24"
  description = "This is cidr for private subnet1"
}

variable "pubsubnet2" {
  default = "10.0.3.0/24"
  description = "This is the cidr for Public subnet2"
}
variable "prisubnet2" {
  default = "10.0.4.0/24"
  description = "This is cidr for private subnet2"
}

variable "key_name" {
  default = "key"
  description = "the ssh key to use in the EC2 machines"
}
