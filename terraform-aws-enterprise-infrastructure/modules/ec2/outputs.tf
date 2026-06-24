output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}