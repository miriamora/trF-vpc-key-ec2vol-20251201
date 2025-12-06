resource "aws_s3_bucket" "utc_s3" {
  bucket = "utc_s3_20251206"

  tags = {
    Name        = "utc_s3_20251206"
    Environment = "Dev"
  }
}
