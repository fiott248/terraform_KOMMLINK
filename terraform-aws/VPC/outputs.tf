output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.default.*.id, [""])[0]
}
 output "routePrivate" {
   value = ["${aws_route_table.private.*.id}"]
 }

 output "routePublic" {
   value = ["${aws_route_table.public.*.id}"]
 }