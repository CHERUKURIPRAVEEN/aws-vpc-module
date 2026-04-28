##################################################################################################
#####################################   VPC   ####################################################
##################################################################################################

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    {
      "Name" = var.vpc_name
      "EKS"  = "YES"
    }, var.tags
  )
}

##################################################################################################
################################### Public Subnets ###############################################
##################################################################################################

resource "aws_subnet" "public" {
  for_each                            = { for subnets in var.public_subnets : subnets.availability_zone => subnets }
  vpc_id                              = aws_vpc.vpc.id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  private_dns_hostname_type_on_launch = var.private_dns_hostname_type_on_launch
  map_public_ip_on_launch             = var.map_public_ip_on_launch
  tags = merge({
    "Name"   = "${aws_vpc.vpc.id}-subnet-public-${each.value.availability_zone}"
    "Public" = "YES"
    "EKS"    = "YES"
    }, var.tags
  )
}

##################################################################################################
################################### Private Subnets ##############################################
##################################################################################################

resource "aws_subnet" "private" {
  for_each                            = { for subnets in var.private_subnets : subnets.availability_zone => subnets }
  vpc_id                              = aws_vpc.vpc.id
  cidr_block                          = each.value.cidr_block
  availability_zone                   = each.value.availability_zone
  private_dns_hostname_type_on_launch = var.private_dns_hostname_type_on_launch
  tags = merge({
    "Name"   = "${aws_vpc.vpc.id}-subnet-private-${each.value.availability_zone}"
    "Public" = "NO"
    "EKS"    = "YES"
    }, var.tags
  )
}

##################################################################################################
################################### Internet Gateway #############################################
##################################################################################################

resource "aws_internet_gateway" "internet_geteway" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    "Name" = "${aws_vpc.vpc.id}-igw"
    }, var.tags
  )
}

##################################################################################################
########################################### EIP ##################################################
##################################################################################################

# resource "aws_eip" "eip" {
#   for_each = { for az in var.public_subnets : az.availability_zone => az }
#   domain   = "vpc"
#   tags = merge({
#     "Name" = "${aws_vpc.vpc.id}-eip-${each.value.availability_zone}"
#     },
#   var.tags)

#   # EIP may require IGW to exist prior to association.
#   depends_on = [aws_internet_gateway.internet_geteway]
# }

# resource "aws_eip" "eip" {
#   for_each = var.create_nat_gateway ? {
#     for az in var.public_subnets : az.availability_zone => az
#   } : {}

#   domain = "vpc"

#   tags = merge({
#     Name = "${aws_vpc.vpc.id}-eip-${each.value.availability_zone}"
#   }, var.tags)

#   depends_on = [aws_internet_gateway.internet_geteway]
# }

resource "aws_eip" "eip" {
  for_each = local.nat_gateway_azs

  domain = "vpc"

  tags = merge({
    Name = "${aws_vpc.vpc.id}-eip-${each.key}"
  }, var.tags)

  depends_on = [aws_internet_gateway.internet_geteway]
}

##################################################################################################
########################################### NAT Gateway ##########################################
##################################################################################################
# resource "aws_nat_gateway" "nat_gateway" {
#   for_each      = { for az in var.public_subnets : az.availability_zone => az }
#   subnet_id     = aws_subnet.public[each.value.availability_zone].id
#   allocation_id = aws_eip.eip[each.value.availability_zone].id
#   tags = merge({
#     "Name" = "${aws_vpc.vpc.id}-nat-public-${each.value.availability_zone}"
#     },
#   var.tags)

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.internet_geteway]
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   for_each = var.create_nat_gateway ? {
#     for az in var.public_subnets : az.availability_zone => az
#   } : {}

#   subnet_id     = aws_subnet.public[each.value.availability_zone].id
#   allocation_id = aws_eip.eip[each.value.availability_zone].id

#   tags = merge({
#     Name = "${aws_vpc.vpc.id}-nat-public-${each.value.availability_zone}"
#   }, var.tags)

#   depends_on = [aws_internet_gateway.internet_geteway]
# }

locals {
  nat_gateway_azs = var.create_nat_gateway ? (
    var.single_nat_gateway ?
    { (var.public_subnets[0].availability_zone) = var.public_subnets[0] } :
    { for az in var.public_subnets : az.availability_zone => az }
  ) : {}
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = local.nat_gateway_azs

  subnet_id     = aws_subnet.public[each.key].id
  allocation_id = aws_eip.eip[each.key].id

  tags = merge({
    Name = "${aws_vpc.vpc.id}-nat-${each.key}"
  }, var.tags)

  depends_on = [aws_internet_gateway.internet_geteway]
}

##################################################################################################
################################## Public Route Table ############################################
##################################################################################################

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = merge({
    "Name" = "${aws_vpc.vpc.id}-public-route-table"
    }, var.tags
  )
}

##################################################################################################
############################ Public Route Table Association ######################################
##################################################################################################

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = { for az in var.public_subnets : az.availability_zone => az }
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public[each.value.availability_zone].id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_geteway.id
  destination_cidr_block = "0.0.0.0/0"
}

##################################################################################################
################################## Private Route Table ###########################################
##################################################################################################

# resource "aws_route_table" "private_route_table" {
#   for_each = { for subnets in var.private_subnets : subnets.availability_zone => subnets }
#   vpc_id = aws_vpc.vpc.id
#   tags = merge({
#     "Name" = "${aws_vpc.vpc.id}-private-route-table"
#     }, var.tags
#   )
# }

resource "aws_route_table" "private_route_table" {
  for_each = { for subnets in var.private_subnets : subnets.availability_zone => subnets }

  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${aws_vpc.vpc.id}-private-rt-${each.key}"
  }, var.tags)
}

resource "aws_route" "private_nat_route" {
  for_each = local.nat_gateway_azs

  route_table_id         = aws_route_table.private_route_table[each.key].id
  nat_gateway_id         = aws_nat_gateway.nat_gateway[each.key].id
  destination_cidr_block = "0.0.0.0/0"
}

##################################################################################################
############################ Private Route Table Association #####################################
##################################################################################################

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = { for az in var.private_subnets : az.availability_zone => az }
  route_table_id = aws_route_table.private_route_table[each.value.availability_zone].id
  subnet_id      = aws_subnet.private[each.value.availability_zone].id
}