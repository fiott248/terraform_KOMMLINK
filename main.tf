terraform {
  required_version = ">= 0.12"
}

module "VPC" {
  source = "./terraform-aws/VPC"
  name = var.vpcname
  vpc_sub = var.vpc_start_oct
  az_zones = var.az_zones
  region = var.region
}
