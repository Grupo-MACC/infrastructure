output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "micro_sg_id" {
  value = aws_security_group.micro_sg.id
}
output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "load_balancer_sg_id" {
  value = aws_security_group.load_balancer_sg.id
}

output "api_gateway_vpc_link_sg_id" {
  value = aws_security_group.api_gateway_vpc_link_sg.id
}