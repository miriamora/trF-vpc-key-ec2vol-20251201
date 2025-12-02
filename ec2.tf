resource "aws_instance" "utc-server" {
  ami                    = "ami-045269a1f5c90a6a0" #
  availability_zone      = "us-east-1a"
  instance_type          = "t3.micro"            #
  subnet_id              = aws_subnet.public1.id #
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  //key_name = ""

  user_data = file("setup.sh")
  tags = {
    Name = "utc-server"
  }

}