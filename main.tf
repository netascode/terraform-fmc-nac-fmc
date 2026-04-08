locals {
  fmc           = try(local.model.fmc, {})
  domains       = try(local.fmc.domains, [])
  data          = try(local.model.data.fmc, {})
  data_existing = try(local.model.existing.fmc.domains, {})
}
