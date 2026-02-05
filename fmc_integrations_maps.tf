######
### map_realm_ad_ldap
######
locals {
  map_realm_ad_ldap = merge(

    # Realm AD/LDAP - individual mode outputs
    { for key, resource in fmc_realm_ad_ldap.realm_ad_ldap : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Realm AD/LDAP - data source
    { for key, data in data.fmc_realm_ad_ldap.realm_ad_ldap : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_realm_local
######
locals {
  map_realm_local = merge(

    # Realm Local - individual mode outputs
    { for key, resource in fmc_realm_local.realm_local : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Realm Local - data source
    { for key, data in data.fmc_realm_local.realm_local : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}
