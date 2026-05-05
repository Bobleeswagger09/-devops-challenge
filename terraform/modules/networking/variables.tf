variable "name" {
  description = "Security group name"
  type        = string
}

variable "app_port" {
  description = "Application port to open"
  type        = number
  default     = 5000
}
