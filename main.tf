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

module "network" {
  source = "./modules/network"
}

module "security_group" {
  source     = "./modules/security-groups"
  depends_on = [module.network]
  vpc        = module.network.vpc
}

module "instances" {
  source              = "./modules/instances"
  depends_on          = [module.network, module.security_group]
  network_application = {
    security_group = module.security_group.security_group_application
    subnet         = module.network.public_subnet
  }
  network_database = {
    security_group = module.security_group.security_group_database
    subnet         = module.network.private_subnet_db
  }
}
