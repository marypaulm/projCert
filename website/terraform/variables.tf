# AWS Region
variable "region" {
  description = "AWS Region to deploy resources in"
  default     = "eu-central-1"
}

# EC2 AMI (Ubuntu)
variable "ami_id" {
  description = "AMI ID for the EC2 instances"
  default     = "ami-0a116fa7c861dd5f9"
}

# EC2 instance type
variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

# AWS key pair name
variable "key_name" {
  description = "Name of the AWS key pair for SSH access"
  default = null
}

# Optional: CIDR block for SSH access
variable "ssh_cidr" {
  description = "CIDR block allowed to SSH"
  default     = "0.0.0.0/0"
}
