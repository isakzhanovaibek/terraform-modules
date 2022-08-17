variable "cidr_block_vpc" {
  type        = string
  description = "cidr_block for vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "cidr_bock for public subnet a"
  default     = "10.0.10.0/24"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "cidr_bock for public subnet b"
  default     = "10.0.11.0/24"
}

variable "private_subnet_cidr_a" {
  type        = string
  description = "cidr_bock for public subnet a"
  default     = "10.0.20.0/24"
}

variable "private_subnet_cidr_b" {
  type        = string
  description = "cidr_bock for public subnet b"
  default     = "10.0.21.0/24"
}
