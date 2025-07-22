output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}
output "aws_internet_gateway_id" {
  description = "INTERNET GATEWAY ID"
  value = aws_internet_gateway.internet_geteway.id
}
output "aws_route_table_id" {
  description = "PUBLIC ROUTE TABLE ID"
  value = aws_route_table.public_route_table.id
}
output "aws_route_table_id" {
  description = "PRIVATE ROUTE TABLE ID"
  value = aws_route_table.private_route_table
}
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}