# =========================
# Generate SSH Key Pair Locally
# =========================

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload public key to AWS
resource "aws_key_pair" "ec2_key" {
  key_name   = "terraform-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Save private key locally as .pem
resource "local_file" "private_key_pem" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/terraform-ec2-key.pem"
  file_permission = "0600"
}

# Save public key locally as .pub
resource "local_file" "public_key_pub" {
  content         = tls_private_key.ec2_key.public_key_openssh
  filename        = "${path.module}/terraform-ec2-key.pub"
  file_permission = "0644"
}
