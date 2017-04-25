variable "name" {
  description = "The name of the VPC"
  default = "MyVPC"
}

variable "cidr" {
  description = "The CIDR of the VPC."
  default = "10.0.0.0/16"
}

variable "public_subnet" {
  description = "The public subnet to create."
  default = "10.0.1.0/24"
}

variable "enable_dns_hostnames" {
  description = "Should be true if you want to use private DNS within the VPC"
  default = true
}

variable "enable_dns_support" {
  description = "Should be true if you want to use private DNS within the VPC"
  default = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = true
}

output "public_subnet_id" {
 value = "${aws_subnet.public.id}"
}

output "vpc_id" {
  value = "${aws_vpc.base.id}"
}

output "cidr" {
  value = "${aws_vpc.base.cidr_block}"
}
