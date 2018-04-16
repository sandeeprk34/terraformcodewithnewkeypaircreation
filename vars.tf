####Variables#####

variable "region" {
  default = "us-west-2"
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

