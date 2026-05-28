######
### map_ad_ldap_realms
######
locals {
  map_ad_ldap_realms_internal = merge(

    # AD/LDAP Realms - individual mode outputs
    { for key, resource in fmc_realm_ad_ldap.realm_ad_ldap : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # AD/LDAP Realms - data source
    { for key, data in data.fmc_realm_ad_ldap.realm_ad_ldap : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  # External objects
  map_ad_ldap_realms_external = {
    for key, value in try(local.data.integrations.ad_ldap_realms, {}) : key => value
  }

  # Internal + External for reference in other objects (e.g. access rules)
  map_ad_ldap_realms = merge(
    local.map_ad_ldap_realms_internal,
    local.map_ad_ldap_realms_external,
  )
}

######
### map_local_realms
######
locals {
  map_local_realms_internal = merge(

    # Local Realms - individual mode outputs
    { for key, resource in fmc_realm_local.realm_local : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Local Realms - data source
    { for key, data in data.fmc_realm_local.realm_local : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  # External objects
  map_local_realms_external = {
    for key, value in try(local.data.integrations.local_realms, {}) : key => value
  }

  # Internal + External for reference in other objects (e.g. access rules)
  map_local_realms = merge(
    local.map_local_realms_internal,
    local.map_local_realms_external,
  )
}
