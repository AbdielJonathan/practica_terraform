# Módulos

![alt text](../assets/modulos-01.png)

Los módulos sirven para agreupar configuraciones y hacer nuestro código más prolijo. Nosotros podemos crear nuestros propios módulos, si la empresa lo desea puede estandarizar el uso de módulos, podemos utilizar módulos oficiales y de terceros. En Terraform Registry hay módulos. Ejemplo: https://registry.terraform.io/browse/modules

## Estructura de un módulo
Véase la práctica 8 como referencia a los módulos

**main.tf**

Se utiliza para declarar los componentes, por ejemplo, un bucket

**variables.tf**

Misma función para declarar variables, solo que en módulos NO utilizamos un archivo terraform.tfvars. Los valores se declaran en la raíz, en este caso se declararon en `practica_8/vpc.tf`

**output.tf**

Si quereos acceder a un valor del recurso con un output, no basta con llamarlo desde la raíz (practica_8), tenemos que establecerlo también en un archivo `output.tf` dentro del módulo

**Estructura básica de un módulo**

```hcl
module "mybucket" {
  source      = "./modulos/s3"
  bucket_name = "nombreunicopepelgrillo-1234567" # Por ahora le ponemos un nombre equis pero siempre hay que asegurarse que sea único

}
```
