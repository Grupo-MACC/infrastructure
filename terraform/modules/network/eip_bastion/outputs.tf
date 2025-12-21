output "bastion_eip_id" {
  value = aws_eip.bastion_eip.id
}

output "bastion_eip_allocation_id" {
  value = aws_eip.bastion_eip.allocation_id
}

output "bastion_eip_public_ip" {
  value = aws_eip.bastion_eip.public_ip
}