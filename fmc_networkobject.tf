###
# HOST
###
locals {
  res_hosts = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.hosts, []) : object if !contains(local.data_hosts, object.name)
    ]
  ])
}

resource "fmc_host_objects" "host" {
  for_each = { for host in local.res_hosts : host.name => host }

  # Mandatory
  name  = each.value.name
  value = each.value.ip

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.hosts.description, null)
}

###
# NETWORK
###
locals {
  res_networks = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.networks, []) : object if !contains(local.data_networks, object.name)
    ]
  ])
}

resource "fmc_network_objects" "network" {
  for_each = { for network in local.res_networks : network.name => network }

  # Mandatory
  name  = each.value.name
  value = each.value.prefix

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networks.description, null)
}

###
# RANGE
###
locals {
  res_ranges = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.ranges, []) : object
    ]
  ])
}

resource "fmc_range_objects" "range" {
  for_each = { for range in local.res_ranges : range.name => range }

  # Mandatory
  name  = each.value.name
  value = each.value.ip_range

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.ranges.description, null)
}

###
# FQDN
###
locals {
  res_fqdns = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.fqdns, []) : object
    ]
  ])
}

resource "fmc_fqdn_objects" "fqdn" {
  for_each = { for fqdn in local.res_fqdns : fqdn.name => fqdn }

  # Mandatory
  name           = each.value.name
  value          = each.value.fqdn
  dns_resolution = try(each.value.dns_resolution, local.defaults.fmc.domains.objects.fqdns.dns_resolution)

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.fqdns.description, null)
}

###
# NETWORK GROUP
###
locals {

  res_networkgroups_l1_hlp = merge({
    for domains in local.domains : domains.name => merge(
      { for object in try(domains.objects.network_groups, []) :
        object.name => [for obj in try(object.objects, []) : false if !contains(keys(local.map_networkobjects_l1), obj)]
    })
  })

  res_networkgroups_l2_hlp = merge({
    for domains in local.domains : domains.name => merge(
      { for object in try(domains.objects.network_groups, []) :
        object.name => [for obj in try(object.objects, []) : false if !contains(keys(local.map_networkobjects_l2), obj)]
    })
  })

  res_networkgroups_l3_hlp = merge({
    for domains in local.domains : domains.name => merge(
      { for object in try(domains.objects.network_groups, []) :
        object.name => [for obj in try(object.objects, []) : false if !contains(keys(local.map_networkobjects_l3), obj)]
    })
  })

  res_networkgroups_l4_hlp = merge({
    for domains in local.domains : domains.name => merge(
      { for object in try(domains.objects.network_groups, []) :
        object.name => [for obj in try(object.objects, []) : false if !contains(keys(local.map_networkobjects_l4), obj)]
    })
  })

  res_networkgroups_l5_hlp = merge({
    for domains in local.domains : domains.name => merge(
      { for object in try(domains.objects.network_groups, []) :
        object.name => [for obj in try(object.objects, []) : false if !contains(keys(local.map_networkobjects_l5), obj)]
    })
  })

  res_networkgroups_l1 = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) :
      {
        name        = object.name
        description = can(object.description)
        objects     = try(object.objects, [])
        literals    = try(object.literals, [])
      } if !contains(local.res_networkgroups_l1_hlp[domains.name][object.name], false)
    ]
  ])

  res_networkgroups_l2 = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) :
      {
        name        = object.name
        description = can(object.description)
        objects     = try(object.objects, [])
        literals    = try(object.literals, [])
      } if !contains(keys(local.map_networkobjects_l2), object.name) && !contains(local.res_networkgroups_l2_hlp[domains.name][object.name], false)
    ]
  ])

  res_networkgroups_l3 = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) :
      {
        name        = object.name
        description = can(object.description)
        objects     = try(object.objects, [])
        literals    = try(object.literals, [])
      } if !contains(keys(local.map_networkobjects_l3), object.name) && !contains(local.res_networkgroups_l3_hlp[domains.name][object.name], false)
    ]
  ])

  res_networkgroups_l4 = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) :
      {
        name        = object.name
        description = can(object.description)
        objects     = try(object.objects, [])
        literals    = try(object.literals, [])
      } if !contains(keys(local.map_networkobjects_l4), object.name) && !contains(local.res_networkgroups_l4_hlp[domains.name][object.name], false)
    ]
  ])

  res_networkgroups_l5 = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) :
      {
        name        = object.name
        description = can(object.description)
        objects     = try(object.objects, [])
        literals    = try(object.literals, [])
      } if !contains(keys(local.map_networkobjects_l5), object.name) && !contains(local.res_networkgroups_l5_hlp[domains.name][object.name], false)
    ]
  ])

  res_networkgroups = local.res_networkgroups_l1

}

resource "fmc_network_group_objects" "networkgroup_l1" {
  for_each = { for networkgroup in local.res_networkgroups_l1 : networkgroup.name => networkgroup }
  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for netgrpobj in each.value.objects : netgrpobj => netgrpobj }

    content {
      id   = local.map_networkobjects_l1[objects.value].id
      type = local.map_networkobjects_l1[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for netgrplit in each.value.literals : netgrplit => netgrplit }

    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }

  lifecycle {
    create_before_destroy = false
  }
}


resource "fmc_network_group_objects" "networkgroup_l2" {
  for_each = { for networkgroup in local.res_networkgroups_l2 : networkgroup.name => networkgroup }
  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for netgrpobj in each.value.objects : netgrpobj => netgrpobj }

    content {
      id   = local.map_networkobjects_l2[objects.value].id
      type = local.map_networkobjects_l2[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for netgrplit in each.value.literals : netgrplit => netgrplit }

    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    fmc_network_group_objects.networkgroup_l1
  ]
}

resource "fmc_network_group_objects" "networkgroup_l3" {
  for_each = { for networkgroup in local.res_networkgroups_l3 : networkgroup.name => networkgroup }
  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for netgrpobj in each.value.objects : netgrpobj => netgrpobj }

    content {
      id   = local.map_networkobjects_l3[objects.value].id
      type = local.map_networkobjects_l3[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for netgrplit in each.value.literals : netgrplit => netgrplit }

    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2
  ]
}

resource "fmc_network_group_objects" "networkgroup_l4" {
  for_each = { for networkgroup in local.res_networkgroups_l4 : networkgroup.name => networkgroup }
  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for netgrpobj in each.value.objects : netgrpobj => netgrpobj }

    content {
      id   = local.map_networkobjects_l4[objects.value].id
      type = local.map_networkobjects_l4[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for netgrplit in each.value.literals : netgrplit => netgrplit }

    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2,
    fmc_network_group_objects.networkgroup_l3
  ]
}

resource "fmc_network_group_objects" "networkgroup_l5" {
  for_each = { for networkgroup in local.res_networkgroups_l5 : networkgroup.name => networkgroup }
  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for netgrpobj in each.value.objects : netgrpobj => netgrpobj }

    content {
      id   = local.map_networkobjects_l5[objects.value].id
      type = local.map_networkobjects_l5[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for netgrplit in each.value.literals : netgrplit => netgrplit }

    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }
  lifecycle {
    create_before_destroy = false
  }
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2,
    fmc_network_group_objects.networkgroup_l3,
    fmc_network_group_objects.networkgroup_l4
  ]
}