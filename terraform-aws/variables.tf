variable "region" {
  type = string
  default = "ap-south-1"
}

variable "key_name" {
  type = string
  default = "nodeapp-kp"
  description = "Name of the SSH key pair"
}
