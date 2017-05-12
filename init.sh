#!/bin/bash

# run terraform
terraform plan
terraform apply

#echo out elastic ip
echo $(terraform output eip) >> ansible/hosts

#add git and docker with ansible
ansible-playbook -i ansible/hosts ansible/bootstrap.yml -u ec2-user --private-key=terraform-key-pair-eu-central-1.pem

#run docker-compose
ansible-playbook -i ansible/hosts ansible/run.yml -u ec2-user --private-key=terraform-key-pair-eu-central-1.pem

#check if server is running
curl "$(terraform output elb_dns_name)":3000
