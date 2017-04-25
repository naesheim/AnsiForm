resource "aws_vpc" "base" {
  cidr_block = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support = "${var.enable_dns_support}"
}

resource "aws_route" "internet_access" {
     route_table_id         = "${aws_route_table.base.id}"
     destination_cidr_block = "0.0.0.0/0"
     gateway_id             = "${aws_internet_gateway.base.id}"
}

resource "aws_route_table" "base" {
  vpc_id = "${aws_vpc.base.id}"
/*
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.base.id}"
  }
*/
  tags {
    Name = "aws_route_table"
  }
}

resource "aws_internet_gateway" "base" {
    vpc_id = "${aws_vpc.base.id}"
}

resource "aws_subnet" "public" {
     vpc_id                 = "${aws_vpc.base.id}"
     cidr_block             = "${var.public_subnet}"
     map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
     tags {
       Name = "${var.name}-public"
     }
 }

resource "aws_route_table_association" "a" {
     subnet_id      = "${aws_subnet.public.id}"
     route_table_id = "${aws_route_table.base.id}"
}
