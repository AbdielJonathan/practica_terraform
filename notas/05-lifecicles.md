# Lifecicles

Los lifecicleas son configuraciones que le podemos hacer a un recurso para agregar constraints a su deploy. Es decir, "solo destruyelo si pasa esto", "solo aplica los cambios si pasa esto". Y hay diferentes tipos de lifecicle.

Para la explicación de los siguientes lifecicle utilizaremos el recurso de ec2 de practica_6/ec2.tf

```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf
}

```

## create_before_destroy

Este constraint le indica a TF que si hay un cambio en el recurso y al ejecutar `terraform plan` se indica que es necesario destruirlo y crear otro; como su nombre lo indica, `create_before_destroy` le indica a TF que primero cree el nuevo recurso antes de eliminarlo. Se aplica con:

```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf

  lifecycle {
    create_before_destroy = true
  }
}
```

## prevent_destroy

Constraint que le indica a TF que bajo ninguna circunstancia se destruya ese recurso. Valioso para evitar que recursos críticos del equipo se eliminen por error.

Ejemplo:

```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf

  lifecycle {
    prevent_destroy = true
  }
}
```

Si se modifica ami, instance_type, etc. Al ejecutar un plan, si no estuviera "prevent_destroy", TF nos indicaría que requiere eliminar y volver a construir public_instance con los cambios que hicimos. Pero en este ejemplo, nos aparecerá un `Error: Instance cannot be destroyed`, lo cual es "correcto"


## ignore_changes

Sirve para colocar cualquier elemento que componga el recurso que deseamos que al cambiarse se ignore y no aparezca en el `terraform plan`.

Ejemplo:

```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf

  lifecycle {
    ignore_changes = [
        ami,
        subnet.id
    ]
  }
}
```

Si hay un cambio en ami o en subnet.id, el plan no nos mostrará cambios porque se ignoran. 

## replace_triggered_by

Es una lista de elementos que van a disparar el remplzo del recurso.

Ejemplo:

```hcl
resource "aws_instance" "public_instance" {
  ami           = "ami-0567589d25e06853e"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  key_name = data.aws_key_pair.mykeyabdiel.key_name #viene de data.tf

  lifecycle {
    replace_triggered_by = [
        aws_subnet.public_subnet
    ]
  }
}
```

Mientras aws_subnet.private_subnet no se modifique, no se remplazará el recurso. Para que se aplique el remplazo hay que cambiar algo de 

```hcl
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_abdiel_virginia.id
  cidr_block              = var.subnets[0]
  map_public_ip_on_launch = true # Le asigne direcciones públicas a los recursos dentro de la subnet
  tags = {
    "Name" = "public_subnet"
  }
}
```