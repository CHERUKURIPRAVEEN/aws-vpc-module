variable "region" {
  description = "region details"
  type        = string
  default     = "us-east-1"
}

variable "application" {
  description = "Application tag value for the EC2 instance. Minimum of 8 characters."
  type        = string

  validation {
    condition     = length(var.application) <= 7
    error_message = "application value should be maximum of 7 characters"
  }
}

variable "application_code" {
  description = "Application code for the EC2 instance. Minimum of 8 characters."
  type        = string

  validation {
    condition     = length(var.application_code) <= 3
    error_message = "application code should be maximum of 3 characters"
  }
}

variable "environment" {
  description = "Environment of the EC2 instance. Possible values: 'Dev','Qa','Stage','PreProd','Production'"
  type        = string
  default     = "Dev"

  validation {
    condition     = contains(["Dev", "Qa", "Stage", "PreProd", "Production"], var.environment)
    error_message = "Environment should be 'Dev','Qa','Stage','PreProd','Production'"
  }
}

variable "environment_code" {
  description = "Environment code for the EC2 instance. Possible values: 'Dev','Qa','Stage','PreProd','Production'"
  type        = string
  default     = "A1"

  validation {
    condition     = length(var.environment_code) == 2
    error_message = "Environment code like 'A1','S1','S2','SX','P1','P2','PX','PR','PD'"
  }
}

variable "tags" {
  description = "default tags"
  type        = map(string)
  default = {
    "env" = "NP"
  }
}

variable "vpc_name" {
  description = "vpc name"
  type        = string
  default     = "VPC_BY_TF"

  validation {
    condition     = length(var.vpc_name) <= 10
    error_message = "VPC name must not exceed 10 characters."
  }

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]+$", var.vpc_name))
    error_message = "VPC name should contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "cidr_block" {
  description = "CIDR range"
  type        = string
  default     = " "
}

variable "create_nat_gateway" {
  description = "Create EIP and NAT Gateway"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  type    = bool
  default = true
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
  default = []
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
  default = []
}