terraform {
  backend "s3" {
    bucket = "bucket_name"
    key = "value"
    region = "us-east-1"
  }
}