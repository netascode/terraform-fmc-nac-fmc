######
### map_vpn_ra
######
locals {
  map_vpn_ra_internal = merge(

    # VPN RA - individual mode outputs
    { for key, resource in fmc_vpn_ra.vpn_ra : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # VPN RA - data sources
    merge([
      for domain, vpns in data.fmc_vpn_ra.vpn_ra : {
        for vpn_name, vpn_values in vpns.items : "${domain}:${vpn_name}" => { id = vpn_values.id, type = vpn_values.type }
      }
    ]...),
  )

  # External objects
  map_vpn_ra_external = {
    for key, value in try(local.data.vpns.remote_access, {}) : key => value
  }

  # Internal + External for reference in other objects (e.g. access rules)
  map_vpn_ra = merge(
    local.map_vpn_ra_internal,
    local.map_vpn_ra_external,
  )
}