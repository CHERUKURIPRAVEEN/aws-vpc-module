# terraform_aws_vpc_module
Variables list
* region                              = "us-east-1"
* vpc_name                            = "test_vpc"
* cidr_block                          = "10.100.0.0/16"
* enable_dns_hostnames                = "true"
* private_dns_hostname_type_on_launch = "ip-name"
* map_public_ip_on_launch             = "true"
* public_subnets                      = [ { availability_zone = "us-east-1a", cidr_block = "10.100.1.0/24" }, { availability_zone = "us-east-1b", cidr_block = "10.100.2.0/24" }]
* private_subnets                     = [ { availability_zone = "us-east-1a", cidr_block = "10.100.100.0/24" }, { availability_zone = "us-east-1b", cidr_block = "10.100.101.0/24" }]