variable "region" {
  description = "region details"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "default tags"
  type        = map(string)
  default = {
    "env" = "DEV"
  }
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
  default     = "VPC_BY_TF"
}

variable "cidr_block" {
  description = "CIDR range"
  type        = string
  default     = "10.1.0.0/16"
}

variable "enable_dns_hostnames" {
  description = "dns hostname enable"
  type        = bool
  default     = false
}

variable "public_subnets" {
  description = " A list of map avaliability_zones, cidr_block for each availability zone inside vpc"
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = [
    { availability_zone = "us-east-1a", cidr_block = "10.1.1.0/24" },
    { availability_zone = "us-east-1b", cidr_block = "10.1.2.0/24" }
  ]
}

variable "private_dns_hostname_type_on_launch" {
  description = "Private host name on launch"
  type        = string
  default     = "ip-name"
}

variable "map_public_ip_on_launch" {
  description = "Public IP on launch"
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = " A list of map avaliability_zones, cidr_block for each availability zone inside vpc"
  type = list(object({
    availability_zone = string
    cidr_block        = string
  }))
  default = [
    { availability_zone = "us-east-1a", cidr_block = "10.1.100.0/24" },
    { availability_zone = "us-east-1b", cidr_block = "10.1.101.0/24" }
  ]
}