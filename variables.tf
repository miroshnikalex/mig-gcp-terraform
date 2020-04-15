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

variable "gcp_zone2" {
  type    = string
  default = "europe-west2-b"
}

variable "gcp_zone3" {
  type    = string
  default = "europe-west2-c"
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

variable "lnd_tcp_allowed" {
  type    = list(string)
  default = ["22"]
}

variable "lnd_tcp_denied" {
  type    = list(string)
  default = ["1-65535"]
}

variable "lnd_udp_denied" {
  type    = list(string)
  default = ["1-65535"]
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

variable "dev_tcp_allowed" {
  type    = list(string)
  default = ["22"]
}

variable "dev_tcp_denied" {
  type    = list(string)
  default = ["22", "3389", "23", "20", "21"]
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

#### storage variables ####
variable "tf_storage_name" {
  type    = string
  default = "tf-state-bkt-204090"
}

variable "provisioning_bkt" {
  type    = string
  default = "provisioning-bkt-204090"
}

#### MIG variables ####
variable "webserver_image" {
  type    = string
  default = "projects/root-patrol-273614/global/images/dev-web-15042020"
}

variable "webserver_image_size" {
  type    = string
  default = "120"
}
