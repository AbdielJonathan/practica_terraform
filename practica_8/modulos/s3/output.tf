output "s3_bucket_arn" {
  description = "ARN del bucket"
  value       = aws_s3_bucket.cerberus_bucket.arn
}
