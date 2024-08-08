output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "route_tables" {
    value = {
        public = aws_route_table.public.id
        private = aws_route_table.private.id
    }
}

output "public_subnets" {
    description = "outputs of public subnets"
    value = [for subnet in aws_subnet.public_subnets: subnet.id]
}

output "private_subnets" {
    description = "outputs of private subnets"
    value = [for subnet in aws_subnet.private_subnets: subnet.id]
}