#Crea 5 buckets en aws y 5 sufijos random que utiliza para los nombres de los buckets

resource "aws_s3_bucket" "bucket-example" {
  bucket = "my-tf-test-bucket-abdi-${random_string.sufijo[count.index].id}"
  count  = 5

  tags = {
    Owner       = "Abdiel"
    Environment = "Dev"
    Other_tag   = "other tag"
  }
}

resource "random_string" "sufijo" {
  count   = 5
  length  = 4
  special = false
  upper   = false
  numeric = false
}
