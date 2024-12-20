terraform {
  backend "s3" {
    bucket         = "cyrax-terraform-remote-state2"
    key            = "nginx-server/terraform.tfstate"
    region         = "us-east-1"
  }
}