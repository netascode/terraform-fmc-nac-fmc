locals {
  fmc           = try(local.model.fmc, {})
  domains       = try(local.fmc.domains, {})
  data_existing = try(yamldecode(file(var.yaml_existing_file)), {})
}
