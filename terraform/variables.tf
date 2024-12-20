variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-west-2"
}

variable "drupal_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use"
  type        = string
  default     = null
}

variable "allow_ssh" {
  description = "Whether to allow SSH access to the server"
  type        = bool
  default     = false
}

variable "enable_rds" {
  description = "Whether to start MySQL since it takes forever to get going"
  type        = bool
  default     = true
}

variable "db_username" {
  description = "Username for MySQL"
  type        = string
  default     = "drupal"
}

variable "db_password" {
  description = "Password for MySQL"
  type        = string
}
