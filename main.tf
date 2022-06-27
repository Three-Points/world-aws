terraform {
  required_version = ">= 1.1.7"

  required_providers {
    aws = {
      version = ">= 4.17.0"
    }
  }
}

provider "terraform" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}