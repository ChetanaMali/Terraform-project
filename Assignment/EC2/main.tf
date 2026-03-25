resource "aws_instance" "ubuntu" {
  count         = 2
  ami           = var.image_id
  instance_type = var.instance_type

  tags = {
    Name = "ubuntu-instance-${count.index + 1}"
  }
}