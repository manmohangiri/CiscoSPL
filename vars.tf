variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = map
  default = {
    us-east-1 = "ami-085925f297f89fce1"
  }
}

variable "webvpcid" {
  default = "vpc-effeed95"
}

variable "sg_list_id" {
  type = list
  default = ["sg-00f6671ede233c06a"]
}

variable "subnet_id1" {
  default = "subnet-1fde133e"
}

variable "subnet_id2" {
  default = "subnet-2e36f148"
}

variable "instancekey" {
  default = "webkey"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "webkey.pub"
}

variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}

variable "cook_nginx" {
  default = "cook_nginx.sh"
}

