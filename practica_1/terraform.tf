resource "local_file" "productos" {
    content = "Lista de productos para el mes próximo"
    filename = "productos.txt"
}

# En terminal ejecutar: 