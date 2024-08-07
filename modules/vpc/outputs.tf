output "vpc_id" {
    value = aws_vpc.vpc.id
}

output "route_tables" {
    value = {
        public = aws_route_table.public.id
        private = aws_route_table.private.id
    }
}