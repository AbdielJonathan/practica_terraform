# Provisioners
Los provisioners me permiten ejecutar código en 2 sitios; la máquina donde se esta escribiendo el código hcl mi máquina local por ejemplo, y dentro de los recursos desplegados. Hay que tomar en cuenta que al hablar de ejecutar código dentro del recurso, tiene que tener sentido en el recurso en el que estamos trabajando. Por lo general hablamos de servidores como ec2 de AWS o VM de GCP.

## Provisioner local

Para ejecutar un provisioner local se utiliza la siguiente sintaxis (se toma como ejemplo el recurso de ec2.tf). Ejemplo 1:

```hcl
resource "aws_instance" "public_instance" {
  ami                    = "ami-0567589d25e06853e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  provisioner "local-exec" {
    command = "echo  instancia creada con IP ${aws_instance.public_instance.public_ip} >> datos_instancia.txt"
  }
}

```

Aquí se crea el archivo datos_instancia.txt en mi máquina local y dentro se escribe la línea del echo

Ejemplo 2 - sentencia when:

```hcl
resource "aws_instance" "public_instance" {
  ami                    = "ami-0567589d25e06853e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  provisioner "local-exec" {
    when = destroy
    command = "echo  instancia con IP ${self.public_instance.public_ip} destruida >> datos_instancia.txt"
  }
}

```

Aquí se escribe la línea hasta que se destruye. Se puede probar con `terraform destroy --target=aws_instance.public_instance`. La sentencia `self` hace referencia al recurso donde se esta ejecutando el provisioner

## Provisioner remoto

Se ejecuta el código en el recurso remoto que estamos creando

```hcl
resource "aws_instance" "public_instance" {
  ami                    = "ami-0567589d25e06853e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]

  provisioner "local-exec" {
    when = destroy
    command = "echo  instancia con IP ${self.public_ip} destruida >> datos_instancia.txt"
  }

  provisioner "remote-exec" {
    inline = [
        "echo 'hola mundo' > ~/saludo.txt"
    ]

    connection {
      type = "ssh"
      host = "self.public_ip"
      user = "ec2-user" # el default de aws. Se puede ver/cambiar en el panel
      private_key = file("mykey.pem") # se descarga desde el panel
    }
  }
}

```

En el ejemplo de arriba tenemos los 2 provisioners de local y remoto, esto es posible porque no son mutuemente excluyentes y se pueden establecer ambos sin problema.

Aunque es válido trabajar con provisioners, en la práctica usual no suele trabajarse así sino con otros métodos como el user data para AWS.

## User data

Este es un método para AWS que SI se usa en la vida diaria donde se establece un script y se ejecuta solo una vez al crearse la instancia. Ejemplo:

```hcl
resource "aws_instance" "public_instance" {
  ami                    = "ami-0567589d25e06853e"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_subnet.id
  key_name               = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  user_data              = <<EOF
    !#/bin/bash
    echo "Este es un mensaje" > ~/mensaje.txt

  EOF
}

```

Se escribe directamente el script con EOF. A diferencia de el provider remoto con el ejemplo anterior, user data ejecuta una sola vez el script al crearse la instancia en este ejemplo y siempre lo ejecuta con el usuario root.

Alternativa en lugar de utilizar EOF y colocar directamente el script en el tf, se puede crear un archivo `.sh`, por ejepmlo: `user_data = file("userdata.sh")`. Vease la práctica 6 el archivo ec2.tf como ejecmplo