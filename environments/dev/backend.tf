terraform {
  backend "s3" {
    bucket       = "akhil-3tier-terraform-state-697858907754"
    key          = "environments/dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}