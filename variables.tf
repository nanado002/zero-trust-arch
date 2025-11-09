variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"


}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "web_instance_count" {
  description = "Number of web tire instances"
  type        = number
  default     = 2
}

variable "app_instance_count" {
  description = "Number of application tire instances"
  type        = number
  default     = 2
}