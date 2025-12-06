resource "aws_instance" "utc-server" {
  ami                    = "ami-045269a1f5c90a6a0" #
  availability_zone      = "us-east-1a"
  instance_type          = "t3.micro"            #
  subnet_id              = aws_subnet.public1.id #
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.utc_trF_key.key_name

  user_data = file("setup.sh")
  tags = {
    Name = "utc-server"
  }
}

resource "aws_ebs_volume" "utc_volume" {
  size = 20
  availability_zone = "us-east-1a"
  tags = {
    Name = "utc_extra_volume"
  }
}

resource "aws_volume_attachment" "utc_vol_attachment" {
  volume_id = aws_ebs_volume.utc_volume.id
  instance_id = aws_instance.utc-server.id
  device_name = "/dev/sdb"
}