# plan

Terraform me permite guardar planes de despliegue de infraestructura. Esto es útil para que definamos un plan de despliegue y así si alguien más del equipo toca el código, nuestro plan de despliegue se guarda como snapshot y queda listo para usarse siempre. Para generar un plan se hace lo siguiente:

1. Se define la infraestructura
2. Ejecutar `terraform plan --out <nombre_del_plan>.plan`
3. Se pueden ejecutar:
   1.  `terraform show <nombre_del_plan>.plan`
   2.  `terraform apply <nombre_del_plan>.plan`
   3.  `terraform destroy <nombre_del_plan>.plan` **El único que no se puede aplicar**