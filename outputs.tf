output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  value = { for k, v in aws_subnet.public : k => v.id }
}

output "private_subnets" {
  value = { for k, v in aws_subnet.private : k => v.id }
}