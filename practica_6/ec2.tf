resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
}
