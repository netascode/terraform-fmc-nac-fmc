###
# SECURITY ZONE
###
locals {
  res_securityzones = flatten([
    for domains in local.domains : [
      for object in try(domains.security_zones, []) : object if !contains(local.data_securityzones, object.name)
    ]
  ])
}

resource "fmc_security_zone" "securityzone" {
  for_each = { for securityzone in local.res_securityzones : securityzone.name => securityzone }

  # Mandatory  
  name           = each.value.name
  interface_mode = try(each.value.interface_type, local.defaults.fmc.domains.security_zones.interface_type)
}
