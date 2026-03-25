output "instance_ids" {
  value = aws_instance.ubuntu[*].id
}

output "public_ips" {
  value = aws_instance.ubuntu[*].public_ip
}