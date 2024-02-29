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
  res_networkgroups = flatten([
    for domains in local.domains : [
      for object in try(domains.objects.network_groups, []) : object if !contains(local.data_networkgroups, object.name)
    ]
  ])

  networkgroup_template = {
    defaults      = try(local.defaults.fmc.domains.objects.network_groups, {}),
    networkgroups = local.res_networkgroups
  }
}

resource "local_file" "networkgroups" {
  content = replace(
    templatefile("${path.module}/templates/fmc_tpl_networkgroup.tftpl", local.networkgroup_template),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "${path.module}/generated_fmc_networkgroup.tf"
}
