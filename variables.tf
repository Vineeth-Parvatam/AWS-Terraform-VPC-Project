variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "demo-project"
}
variable "ami_id" {
  description = "The AMI ID to use for the instances"
  type        = string
}
variable "instance_type" {
  description = "The instance type to use for the instances"
  type        = string
  default     = "t2.micro"
}
