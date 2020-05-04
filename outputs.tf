output "public_subnets" {
  description = "List of public subnets' IDs"
  value       = concat(aws_subnet.pub-1.id, aws_subnet.pub-2.id)
}

output "private_subnets" {
  description = "List of private subnets' IDs"
  value       = concat(aws_subnet.priv-1.*.id, aws_subnet.priv-2.*.id)
}

output "vpc_id" {
  description = "VPC ID"
  value       = data.aws_vpc.selected.id
}