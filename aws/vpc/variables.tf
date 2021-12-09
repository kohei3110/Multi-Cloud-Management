variable "vpc_name" {
  type        = string
  description = "the name for the vpc"
  default     = ""
}

variable "cidr_block" {
  type        = string
  description = "the cidr block to use for the vpc"
  default     = ""
}

variable "subnet_count" {
  type        = number
  description = "how many private and private subnets to create"
  default     = 0
}