module "authorizer" {
  source = "../../modules/lambda"
  pbs_name = var.pbs_name
}