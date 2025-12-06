resource "tls_private_key" "utc_tls" {
  rsa_bits  = "4096"
  algorithm = "RSA"
}

resource "aws_key_pair" "utc_trF_key" {
  key_name   = "utc_trF_key"
  public_key = tls_private_key.utc_tls.public_key_openssh
}

resource "local_file" "utc_key_pem" {
  filename        = "utc_key.pem"
  file_permission = "400"
  content         = tls_private_key.utc_tls.private_key_openssh
}