resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
}
