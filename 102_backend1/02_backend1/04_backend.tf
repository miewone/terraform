terraform {
  backend "s3" {
    bucket         = "wgparkterra"
    key            = "global/s3/terraform.tfstate"
    region         = "ap-northeast-2"
    access_key     = "AKIA2GWBLJBUA2IYX5GK"
    secret_key     = "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"
    dynamodb_table = "terra-lock"
    encrypt        = true
    #depends_on  = [aws_s3_bucket.terra_state,]
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terra_state.arn
}
output "dynamodb_table_name" {
  value = aws_dynamodb_table.terra_lock.name
}