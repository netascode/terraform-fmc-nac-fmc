# Handle bulk mode (single resource)
resource "fmc_hosts" "bulk" {
  count = var.bulk ? 1 : 0

  domain = var.domain
  items  = { for host in var.hosts : host.name => host }
}

# Handle individual mode  
resource "fmc_host" "individual" {
  for_each = var.bulk ? {} : { for host in var.hosts : host.name => host }

  domain      = var.domain
  name        = each.value.name
  ip          = each.value.ip
  description = each.value.description
}
