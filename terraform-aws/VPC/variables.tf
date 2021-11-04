
variable "region" {
    type = string
    description = "region of VPC"
}

variable "name" {
    type = string
    description = "name of vpc"
}

variable "vpc_sub" {
    type = string
    default = "10.0"
    description = "first two ochet of subent vpc"
}

variable "az_zones" {
    type = list(string)
    description = "List of available Zones"
    default = ["us-east-1a", "us-east-1b"]
}
