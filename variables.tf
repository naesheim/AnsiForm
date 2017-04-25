variable "access_key" {
  description = "Access key generated from aws client"
  default = "secret"
}

variable "secret_key" {
  description = "Secret key generated from aws client"
  default = "secret"
}

variable "key_path" {
  description = "key_path is used with provisioner and remote exec"
  default = "secret"
}

variable "ami_id" {
    description = "Select which AMI, based on your region code"
    default = "ami-211ada4e"
}

variable "key_name" {
    description = "Which key should be used for shh connection with instance"
    default = "secret"
}

variable "region" {
    description = "Where should this be hosted"
    default = "eu-central-1"
}

variable "instance_type" {
    description = "selec from a different size and variations"
    default = "t2.small"
}
