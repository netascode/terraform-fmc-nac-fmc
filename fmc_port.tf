###
# PORT
###
locals {
  res_ports = flatten([
    for domains in local.domain : [
      for object in try(domains.port, []) : object if !contains(local.data_ports, object.name)
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
  overridable = try(each.value.overridable, local.defaults.fmc.domain.port.overridable, null)
}

###
# ICMPv4
###
locals {
  res_icmpv4s = flatten([
    for domains in local.domain : [
      for object in try(domains.icmpv4, []) : object
    ]
  ])
}

resource "fmc_icmpv4_objects" "icmpv4" {
  for_each = { for icmpv4 in local.res_icmpv4s : icmpv4.name => icmpv4 }

  # Mandatory
  name      = each.value.name
  icmp_type = each.value.icmp_type

  # Optional
  code = try(each.value.code, local.defaults.fmc.domain.icmpv4.code, null)
}

###
# PORT GROUP
###
locals {
  res_portgroups = flatten([
    for domains in local.domain : [
      for object in try(domains.portgroup, []) : object
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
  description = try(each.value.description, local.defaults.fmc.domain.host.description, null)
}
