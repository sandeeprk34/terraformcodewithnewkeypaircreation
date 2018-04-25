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



