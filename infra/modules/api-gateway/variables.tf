variable "app_api_access" {
  description = "api access"
  type        = string
  default     = "public"
}

variable "pbs_name" {
  default = "tcs"
}

variable "body" {
  description = "An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs."
  type        = string
  default     = null
}
