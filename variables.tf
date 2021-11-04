variable "az_zones" {
  type        = list(string)
  description = "List of available Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpcname" {
  type    = string
  default = "test"
}

variable "vpc_start_oct" {
  type    = string
  default = "10.1"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
