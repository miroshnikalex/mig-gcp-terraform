variable "cred_file" {
  type    = string
  default = "local/credentials.json"
}

variable "gcp_project" {
  type    = string
  default = "root-patrol-273614"
}

variable "gcp_region" {
  type    = string
  default = "europe-west2"
}

variable "gcp_zone" {
  type    = string
  default = "europe-west2-a"
}

#### landing zone variables ####

variable "lnd_network_name" {
  type    = string
  default = "lnd-vpc"
}

variable "lnd_vpc_iprange" {
  type    = string
  default = "172.16.0.0/16"
}

variable "lnd_subnet_name1p" {
  type    = string
  default = "lnd-sub1p"
}

variable "lnd_subnet_name1s" {
  type    = string
  default = "lnd-sub1s"
}

variable "lnd_subnet_iprange1p" {
  type    = string
  default = "172.16.2.0/24"
}

variable "lnd_subnet_iprange1s" {
  type    = string
  default = "172.16.200.0/24"
}

variable "lnd_allowed_tcp_ports" {
  type    = list(string)
  default = ["22"]
}
#### development environment variables ####

variable "dev_network_name" {
  type    = string
  default = "development-vpc"
}

variable "dev_vpc_iprange" {
  type    = string
  default = "10.2.0.0/16"
}

variable "dev_subnet_name1p" {
  type    = string
  default = "dev-w2subnet1p"
}

variable "dev_subnet_name1s" {
  type    = string
  default = "dev-w2subnet1s"
}

variable "dev_subnet_iprange1p" {
  type    = string
  default = "10.2.1.0/24"
}

variable "dev_subnet_iprange1s" {
  type    = string
  default = "192.168.10.0/24"
}

variable "dev_allowed_tcp_ports" {
  type    = list(string)
  default = ["22"]
}
#### bastion host variables ####

variable "bastion_lnd_ip_internal" {
  default = "172.16.2.250"
}
variable "bastion_dev_ip_internal" {
  default = "10.2.1.250"
}
variable "bastion_vm_type" {
  type    = string
  default = "g1-small"
}

variable "bastion_image_size" {
  type    = string
  default = "80"
}

variable "bastion_image" {
  type    = string
  default = "projects/gce-uefi-images/global/images/centos-7-v20200403"
}
