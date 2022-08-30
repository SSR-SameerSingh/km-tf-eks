terraform {
  backend "s3" {
    bucket         = "km-tf-eks"
    key            = "km-eks"
    region         = "us-west-2"
    encrypt        = true
  }
}
