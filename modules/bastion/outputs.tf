output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}
output "bastion_eip" {
  value = aws_eip.bastion_eip.public_ip
}
