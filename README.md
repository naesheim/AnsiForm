Creates a EC2 instance in AWS with NGINX including:

 - VPC
 - loadbalancer
 - Elastic IP

# run terraform
terraform plan
terraform apply

#echo out elastic ip
echo "${terraform output eip}" >> ansible/hosts

#add and run nginx with ansible
ansible-playbook -i ansible/hosts ansible/bootstrap.yml -u ec2-user

#check nginx server is running
curl "${terraform output elb_dns_name}"
