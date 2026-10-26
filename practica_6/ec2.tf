resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("userdata.sh")

  provisioner "local-exec" {
    when    = destroy
    command = "echo  instancia con IP ${self.public_ip} >> /noexiste/destruidadatos_instancia.txt"
  }
}
