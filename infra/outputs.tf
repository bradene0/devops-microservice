output "ecs_cluster_name" {
  value = aws_ecs_cluster.app.name
}

output "s3_bucket_name" {
  value = aws_s3_bucket.logs.bucket
}

output "rds_endpoint" {
  value = aws_db_instance.app.endpoint
}

