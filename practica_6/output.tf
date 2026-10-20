output "ec2_public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.public_instance.public_ip
}
