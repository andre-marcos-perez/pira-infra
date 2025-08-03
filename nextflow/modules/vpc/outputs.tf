output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "default_sg_id" {
  value = aws_security_group.batch_sg.id
}
