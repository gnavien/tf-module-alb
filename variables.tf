variable "name" {}
variable "internal" {}
variable "load_balancer_type" {}

variable "subnets" {}
variable "env" {}
variable "tags" {}
variable "sg_subnet_cidr" {}
variable "port" {
  default = 80
}
variable "vpc_id" {}