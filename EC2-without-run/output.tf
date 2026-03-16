# ─── Key Pair Outputs ─────────────────────────────────────────
output "key_pair_name" {
  description = "Name of the created AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "private_key_path" {
  description = "Local path of the saved private key (.pem)"
  value       = local_file.private_key_pem.filename
}

# ─── Ubuntu Instance Outputs ──────────────────────────────────
output "ubuntu_instance_id" {
  description = "ID of the Ubuntu EC2 instance"
  value       = aws_instance.ubuntu.id
}

output "ubuntu_public_ip" {
  description = "Public IP of the Ubuntu EC2 instance"
  value       = aws_instance.ubuntu.public_ip
}

output "ubuntu_ssh_command" {
  description = "SSH command to connect to Ubuntu instance"
  value       = "ssh -i ${local_file.private_key_pem.filename} ubuntu@${aws_instance.ubuntu.public_ip}"
}

# ─── Amazon Linux Instance Outputs ───────────────────────────
output "amazon_linux_instance_id" {
  description = "ID of the Amazon Linux EC2 instance"
  value       = aws_instance.amazon_linux.id
}

output "amazon_linux_public_ip" {
  description = "Public IP of the Amazon Linux EC2 instance"
  value       = aws_instance.amazon_linux.public_ip
}

output "amazon_linux_ssh_command" {
  description = "SSH command to connect to Amazon Linux instance"
  value       = "ssh -i ${local_file.private_key_pem.filename} ec2-user@${aws_instance.amazon_linux.public_ip}"
}