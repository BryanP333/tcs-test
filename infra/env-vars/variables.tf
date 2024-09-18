#########################
### Common variables
#########################
variable "pbs_name" {
  default = ""
}

#########################
### API GATEWAY Variables
#########################

variable "create_authorizer" {
  type    = bool
  default = true
}

variable "app_api_access" {
  description = "api access"
  type        = string
  default     = "public"
}

variable "body" {
  description = "An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs."
  type        = string
  default     = null
}

variable "authorizer_type" {
  type    = string
  default = "REQUEST"
}

variable "authorizer_result_ttl_in_seconds" {
  type    = number
  default = 300
}

#########################
### ecs variables
#########################

variable "main_port" {
  default = "80"
}
