# Taint

taint se puede interpretar como manchar o manchado. Sirve para seleccionar un recurso específica e indicarle a TF que en el próximo apply debe eliminarlo y volver a crearlo. Se puede seleccionar el recurso manualmente o también hay ocaciones en las que TF "mancha" un recurso porque hubo un problema con él al desplegarse, a veces por error de sintaxis en nuestra definición, e indica que en el proximo apply debe borrarse y volver a construirse.

Ejemplo con `ec2.tf` de la práctica 6;

1. Colocamos a propósito un error de sintaxis para ver como TF lo marca como tained:
```hcl
  resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  instance_type          = var.ec2_specs.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = file("userdata.sh")

  provisioner "local-exec" {
    when    = destroy
    command = "echo  instancia con IP ${self.public_ip} destruida >> /noexiste/datos_instancia.txt" # Aquí colocamos un path que no existe como error a proósito
  }
}

```
2. Ejecutamos un `terraform apply --auto-aprove=yes`
3. Vemos que el recurso SI se creo y desplegó, incluso vemos su IP, pero aún así TF nos avíso de un error.
4. Al volver a ejecutar `terraform apply` vemos que TF lo marcó como "tained", es decir, al decir yes, el recurso se destruirá y volverá a crear
5. Si nos llega a apasar esto con un recurso crítico que NO puede ser eliminado, tenemos que decirle a TF que los "desmanche" con `terraform untaint`