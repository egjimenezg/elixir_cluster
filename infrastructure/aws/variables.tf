variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier for naming/tagging"
}

variable "environment" {
  description = "Environment name (dev/stating/prod)"
  type        = string
  default     = "dev"
}
