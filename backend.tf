terraform {
  backend "s3" {
    bucket       = "utc-bucket-20251201"
    key          = "utc-app/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}