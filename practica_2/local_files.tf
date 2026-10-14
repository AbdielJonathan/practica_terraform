resource "local_file" "productos-1" {
  count    = 5
  content  = "Lista de productos para el mes próximo"
  filename = "productos-${random_string.sufijo[count.index].id}.txt"
}


#DRY: Dont Repeat Yourself

# Con "[count.index].id" aplicamos el principio dry para no esta declarado
# muchas veces el mismo bloque completo del recuso. En lugar de eso, solo colocamos
#  el atributo "count" tnto en local_file como en random_string y de esta forma 
# si el dpia de mañana en lugar de 5 queremos 50, basta con cambiar el count en 
# ambos recursos y listo