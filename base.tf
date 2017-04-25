# in provider you decide which cloud platform you are going to use. aws/azure/google
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "eu-central-1"
}

# this spins up a new instance in cloud of type 'instance type'
resource "aws_instance" "linux_base" {
  ami           = "ami-211ada4e"
  key_name = "terraform-key-pair-eu-central-1"
  instance_type = "t2.small"
  subnet_id = "${module.vpc.public_subnet_id}"
  #specify which security rules are active
  vpc_security_group_ids = ["${aws_security_group.agent.id}"]
  associate_public_ip_address = true

  tags {
      Name = "InfrasAsCode"
  }
 }

# you can have as many resources as you want. But keep the names seperate
/*
resource "aws_instance" "windows10_base" {
  ami = ""
  instance_type = "win10"
}
*/
# aws_eip is an elastic ip address for your instance - specified with id
resource "aws_eip" "base" {
  instance = "${aws_instance.linux_base.id}"
  vpc = true
}

module "vpc" {
  source = "./vpc"
  name = "VirtualPrivateCloud"
  cidr = "10.0.0.0/16"
  public_subnet = "10.0.1.0/24"
}


#elastic load balancer
resource "aws_elb" "base" {
  name = "base-elb"
  subnets = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  /*
  in order for elb to allow health checks you need to allow outbound connection from the security group
  health checks sends a HTTP req every 30 sec and waits for a 200 resp.
  */
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }

  listener {
     instance_port = 80
     instance_protocol = "http"
     lb_port = 80
     lb_protocol = "http"
  }
  instances = ["${aws_instance.linux_base.id}"]
}

#the elb needs a security group in order to access port 80
resource "aws_security_group" "elb" {
    description = "allow http from anywhere"
    vpc_id = "${module.vpc.vpc_id}"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "agent" {
    name = "instance specific"
    description = "allow ssh from anywhere"
    vpc_id = "${module.vpc.vpc_id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${module.vpc.cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# outputs tells terraform which variables to 'bubble up'
output "elb_dns_name" {
  value = "${aws_elb.base.dns_name}"
}

output "instance_public_ip"{
    value = "${aws_instance.linux_base.public_ip}"
}

output "eip"{
    value = "${aws_eip.base.public_ip}"
}
