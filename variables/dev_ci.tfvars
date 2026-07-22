#------------------------------------------ Global Variables --------------------------------------------------------#
project_name = "TF"
application  = "tf-app"
project      = "TF"
backup       = "NonProd"
owner        = "praveen.cherukuri@veen.com"
app_owner    = "praveen.cherukuri@veen.com"
description  = "This is a test VPC created by Terraform module"

environment_code = "T1"
application_code = "TF"
#------------------------------------------ VPC Variables --------------------------------------------------------#
region                              = "us-east-1"
environment                         = "Dev"
vpc_name                            = "TF_VPC"
cidr_block                          = "10.100.0.0/16"
enable_dns_hostnames                = true
private_dns_hostname_type_on_launch = "ip-name"
map_public_ip_on_launch             = true
create_nat_gateway                  = false
single_nat_gateway                  = false
public_subnets = [
  { availability_zone = "us-east-1a", cidr_block = "10.100.1.0/24" },
  { availability_zone = "us-east-1b", cidr_block = "10.100.2.0/24" },
  { availability_zone = "us-east-1c", cidr_block = "10.100.3.0/24" }
]
private_subnets = [
  { availability_zone = "us-east-1a", cidr_block = "10.100.10.0/24" },
  { availability_zone = "us-east-1b", cidr_block = "10.100.11.0/24" }
]
