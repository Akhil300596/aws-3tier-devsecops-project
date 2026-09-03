provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "aws-3tier-devsecops"
      Environment = "shared"
      ManagedBy   = "terraform"
    }
  }
}