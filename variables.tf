variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "aws_aviability_zone" {
  description = "AWS aviability zone"
  type        = string
  default     = "eu-central-1a"
}

variable "ec2_ami_micro" {
  description = "ami for ec2 instance"
  type        = string
  default     = "ami-025a6a5beb74db87b"
}

variable "ec2_running" {
  description = "ec2 instance running"
  type        = bool
}
