variable "region" {
  description = "The region to deploy the cluster in, e.g: us-east-1."
  default     = "eu-west-1"
}

variable "instance_size" {
  description = "The size of the cluster nodes, e.g: t2.large. Note that OpenShift will not run on anything smaller than t2.large, officially."
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC, e.g: 10.0.0.0/16"
}

variable "subnetaz" {
  description = "The AZ for the public subnet, e.g: us-east-1a"
  type        = "map"
}

variable "subnet_cidr" {
  description = "The CIDR block for the public subnet, e.g: 10.0.1.0/24"
}

variable "key_name" {
  description = "The name of the key to user for ssh access, e.g: consul-cluster"
}

variable "public_key_path" {
  description = "The local public key path, e.g. ~/.ssh/id_rsa.pub"
}
