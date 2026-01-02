terraform {
  backend "s3" {
    bucket         = "happy-safe-terra-o1v1" # Replace with your unique bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "zero-trust-tf-lock" # For state locking
  }
}
