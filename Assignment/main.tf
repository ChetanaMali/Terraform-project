provider "aws" {
  region = "us-east-1"
}

module "ec2" {
  source        = "./EC2"
  image_id      = var.image_id
  instance_type = var.instance_type
}