# AWS VPC Module - outputs.tf
# Project: Portfolio-2

# ----------------------------------------------------------------------------------------------------------------------
# 1. VPC Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the created VPC."
  value       = aws_vpc.main.cidr_block
}

# ----------------------------------------------------------------------------------------------------------------------
# 2. Subnet Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "public_subnet_ids" {
  description = "A list of IDs of the public subnets."
  value       = aws_subnet.public[*].id # 作成されたすべてのパブリックサブネットIDのリスト
}

output "public_subnet_cidr_blocks" {
  description = "A list of CIDR blocks of the public subnets."
  value       = aws_subnet.public[*].cidr_block
}

output "private_subnet_ids" {
  description = "A list of IDs of the private subnets."
  value       = aws_subnet.private[*].id # 作成されたすべてのプライベートサブネットIDのリスト
}

output "private_subnet_cidr_blocks" {
  description = "A list of CIDR blocks of the private subnets."
  value       = aws_subnet.private[*].cidr_block
}

# ----------------------------------------------------------------------------------------------------------------------
# 3. Route Table Outputs
# ----------------------------------------------------------------------------------------------------------------------

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public.id
}

output "private_route_table_ids" {
  description = "A list of IDs of the private route tables (one per AZ)."
  value       = aws_route_table.private[*].id
}

# ----------------------------------------------------------------------------------------------------------------------
# 4. Gateway Outputs 
# ----------------------------------------------------------------------------------------------------------------------

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway."
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_eip_id" {
  description = "The Allocation ID of the Elastic IP for the NAT Gateway."
  value       = aws_eip.nat_gateway_eip.id
}