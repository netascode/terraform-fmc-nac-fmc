locals {
  # Normalize bulk mode outputs
  bulk_hosts_map = var.bulk && length(fmc_hosts.bulk) > 0 ? {
    for item_key, item_value in fmc_hosts.bulk[0].items : item_key => {
      name        = item_key
      id          = item_value.id
      type        = item_value.type
      domain_name = var.domain
    }
  } : {}

  # Normalize individual mode outputs  
  individual_hosts_map = var.bulk ? {} : {
    for key, resource in fmc_host.individual : resource.name => {
      name        = resource.name
      id          = resource.id
      type        = resource.type
      domain_name = var.domain
    }
  }
}

output "hosts_map" {
  description = "List of created FMC hosts with their IDs"
  value = merge(
    local.bulk_hosts_map,
    local.individual_hosts_map
  )
}
