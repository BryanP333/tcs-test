locals {
  api_access = var.app_api_access == "priv" ? "priv" : var.app_api_access == "public" ? "public" : "public"
  types      = var.app_api_access == "priv" ? "PRIVATE" : var.app_api_access == "public" ? "REGIONAL" : "REGIONAL"

}