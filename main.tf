locals {
  fmc           = try(local.model.fmc, {})
  domain        = try(local.fmc.domain, {})
  data_existing = try(yamldecode(file(var.yaml_existing_file)), {})
}
