output "public_ip" {
  value = aws_instance.utc-server.public_ip
}

output "vpc_id" {
  value = aws_vpc.utc-vpc.id
}