locals {
  fmc           = try(local.model.fmc, {})
  domains       = try(local.fmc.domains, {})
  data_existing = try(local.model.existing, {})
}