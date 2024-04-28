###
# DYNAMIC OBJECTS
###
locals {
  res_dynamicobjects = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.dynamic_objects, []) : object if !contains(local.data_dynamicobjects, object.name)
    ]
  ])
}

resource "fmc_dynamic_objects" "dynamicobject" {
  for_each = { for dynobj in local.res_dynamicobjects : dynobj.name => dynobj }

  # Mandatory
  name        = each.value.name
  object_type = try(each.value.object_type, local.defaults.fmc.domains.objects.dynamic_objects.object_type)

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.dynamic_objects.description, null)
}

###
# SGT
###
locals {
  res_sgts = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.sgts, []) : object if !contains(local.data_sgts, object.name)
    ]
  ])
}

resource "fmc_sgt_objects" "sgt" {
  for_each = { for sgt in local.res_sgts : sgt.name => sgt }

  # Mandatory
  name = each.value.name
  tag  = each.value.tag

  # Optional
  type        = "SecurityGroupTag"
  description = try(each.value.description, local.defaults.fmc.domains.objects.sgts.description, null)
}

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
  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networkgroups.description, null)

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
  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networkgroups.description, null)
  depends_on = [
    fmc_network_group_objects.networkgroup_l1
  ]
  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      fmc_network_group_objects.networkgroup_l1
    ]
  }
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

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networkgroups.description, null)
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2
  ]
  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      fmc_network_group_objects.networkgroup_l1,
      fmc_network_group_objects.networkgroup_l2
    ]
  }
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

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networkgroups.description, null)
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2,
    fmc_network_group_objects.networkgroup_l3
  ]
  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      fmc_network_group_objects.networkgroup_l1,
      fmc_network_group_objects.networkgroup_l2,
      fmc_network_group_objects.networkgroup_l3
    ]
  }
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

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.networkgroups.description, null)
  depends_on = [
    fmc_network_group_objects.networkgroup_l1,
    fmc_network_group_objects.networkgroup_l2,
    fmc_network_group_objects.networkgroup_l3,
    fmc_network_group_objects.networkgroup_l4
  ]
  lifecycle {
    create_before_destroy = false
    replace_triggered_by = [
      fmc_network_group_objects.networkgroup_l1,
      fmc_network_group_objects.networkgroup_l2,
      fmc_network_group_objects.networkgroup_l3,
      fmc_network_group_objects.networkgroup_l4
    ]
  }
}

###
# PORT
###
locals {
  res_ports = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.ports, []) : object if !contains(local.data_ports, object.name)
    ]
  ])
}

resource "fmc_port_objects" "port" {
  for_each = { for port in local.res_ports : port.name => port }

  # Mandatory
  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol

  # Optional
  overridable = try(each.value.overridable, local.defaults.fmc.domains.objects.ports.overridable, null)
}

###
# ICMPv4
###
locals {
  res_icmpv4s = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.icmp_v4s, []) : object
    ]
  ])
}

resource "fmc_icmpv4_objects" "icmpv4" {
  for_each = { for icmpv4 in local.res_icmpv4s : icmpv4.name => icmpv4 }

  # Mandatory
  name      = each.value.name
  icmp_type = each.value.icmp_type

  # Optional
  code = try(each.value.code, local.defaults.fmc.domains.objects.icmp_v4s.code, null)
}

###
# PORT GROUP
###
locals {
  res_portgroups = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.port_groups, []) : object
    ]
  ])
}

resource "fmc_port_group_objects" "portgroup" {
  for_each = { for portgrp in local.res_portgroups : portgrp.name => portgrp }

  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for obj in try(each.value.objects, {}) :
      obj => obj
    }
    content {
      id   = local.map_ports[objects.value].id
      type = local.map_ports[objects.value].type
    }
  }

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.port_groups.description, null)
}

###
# URL
###
locals {
  res_urls = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.urls, []) : object if !contains(local.data_urls, object.name)
    ]
  ])
}

resource "fmc_url_objects" "url" {
  for_each = { for url in local.res_urls : url.name => url }

  # Mandatory
  name = each.value.name
  url  = each.value.url

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.urls.description, null)
}

###
# URL GROUPS
###
locals {
  res_urlgroups = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.url_groups, []) : object
    ]
  ])
}

resource "fmc_url_object_group" "urlgroup" {
  for_each = { for urlgrp in local.res_urlgroups : urlgrp.name => urlgrp }

  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for obj in try(each.value.objects, {}) :
      obj => obj
    }
    content {
      id   = local.map_urls[objects.value].id
      type = local.map_urls[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for obj in try(each.value.literals, {}) :
      obj => obj
    }
    content {
      url = literals.value
    }
  }

  # Optional
  description = try(each.value.description, local.defaults.fmc.domains.objects.url_groups.description, null)
}

###
# SECURITY ZONE
###
locals {
  res_securityzones = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.security_zones, []) : object if !contains(local.data_securityzones, object.name)
    ]
  ])
}

resource "fmc_security_zone" "securityzone" {
  for_each = { for securityzone in local.res_securityzones : securityzone.name => securityzone }

  # Mandatory  
  name           = each.value.name
  interface_mode = try(each.value.interface_type, local.defaults.fmc.domains.objects.security_zones.interface_type)
}
