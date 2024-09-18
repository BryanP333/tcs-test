variable "pbs_name" {
  description = "Prefix name"
}

variable "main_port" {
  description = "Port for container"
}

variable "container_image" {
  description = "image to use in containers"
}

variable "credentialsParam" {
  description = "arn of the docker hub secret"
}

variable "alb_arn" {
  description = "arn of load balancer"
}

variable "main_subnet_ids" {
  description = "List of subnets where deploy containers"
}

variable "security_group" {
  description = "Security group ID"
}

