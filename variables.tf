variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

variable "project_name" {
  description = "The project name for tagging purposes"
  default     = "nixos-terraform-aws"
}

variable "vhd_image_source" {
  description = "Source path of the VHD image file"
  default     = "/nix/store/h28zy1gnyl6jmwghza1z349x0mh73w57-nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux/nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux.vhd"
}

variable "ingress_ip" {
  description = "IP allowed to access the instance"
  default     = "0.0.0.0/32" # I put my IP here
}

variable "instance_type" {
  description = "The type of instance to deploy"
  default     = "g6.2xlarge"
}

variable "key_name" {
  description = "Key pair name for access"
  default     = "aws-key"
}

variable "instance_name" {
  description = "The EC2 instance tag name"
  default     = "nixos"
}
