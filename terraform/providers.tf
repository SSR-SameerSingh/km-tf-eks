provider "aws" {
    region = "${var.AWS_REGION}"
}

terraform {
  required_providers {
    rafay = {
      version = ">= 1.0.0"
      source = "registry.terraform.io/RafaySystems/rafay"
    }
  }
}
