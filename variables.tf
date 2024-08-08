variable "subnet_id" {
  description = "The ID of the Subnet where the instance will be created"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the Security Group to associate with the instance"
  type        = string
}

variable "instance_type" {
  description = "The type of the instance"
  type        = string
  default     = "t2.micro" # Default instance type
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
}