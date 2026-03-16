variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"   # ← changed from t2.micro
}

variable "key_pair_name" {
  description = "Name for the generated key pair"
  type        = string
  default     = "my-ec2-keypair"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}