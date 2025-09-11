locals {

  hosts_items = {
    for host in var.hosts : host.name => {
      name        = host.name
      ip          = host.ip
      description = host.description
    }
  }

}

# Handle bulk mode (single resource)
resource "fmc_hosts" "bulk" {
  count = var.bulk ? 1 : 0

  domain = var.domain
  items  = local.hosts_items
}

# Handle individual mode  
resource "fmc_host" "individual" {
  for_each = var.bulk ? {} : local.hosts_items

  domain      = var.domain
  name        = each.value.name
  ip          = each.value.ip
  description = each.value.description
}
