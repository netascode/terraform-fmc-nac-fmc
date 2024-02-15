###
# FTD NAT POLICY
###
locals {
  res_ftdnatpolicies = flatten([
    for domains in local.domain : [
      for object in try(domains.ftdnatpolicy, {}) : object if !contains(local.data_ftdnatpolicies, object.name)
    ]
  ])
}

resource "fmc_ftd_nat_policies" "ftdnatpolicy" {
  for_each = { for ftdnatpolicy in local.res_ftdnatpolicies : ftdnatpolicy.name => ftdnatpolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  description = try(each.value.description, local.defaults.fmc.domain.ftdnatpolicy.description, null)
}

###
# FTD AUTO NAT RULE
###
locals {
  res_ftdautonatrules = flatten([
    for domain in local.domain : [
      for natpolicy in try(domain.ftdnatpolicy, {}) : [
        for ftdautonatrule in try(natpolicy.ftdautonatrule, {}) : {
          key        = "${natpolicy.name}/${ftdautonatrule.name}"
          nat_policy = local.map_natpolicies[natpolicy.name].id
          data       = ftdautonatrule
        }
      ]
    ]
  ])
}

resource "fmc_ftd_autonat_rules" "ftdautonatrule" {
  for_each = { for ftdautonatrule in local.res_ftdautonatrules : ftdautonatrule.key => ftdautonatrule }

  # Mandatory
  nat_policy = each.value.nat_policy
  nat_type   = each.value.data.nat_type

  # Optional
  description                                 = try(each.value.data.description, null)
  fallthrough                                 = try(each.value.data.fallthrough, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.fallthrough, null)
  ipv6                                        = try(each.value.data.ipv6, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.ipv6, null)
  net_to_net                                  = try(each.value.data.net_to_net, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.net_to_net, null)
  no_proxy_arp                                = try(each.value.data.no_proxy_arp, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.no_proxy_arp, null)
  perform_route_lookup                        = try(each.value.data.perform_route_lookup, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.perform_route_lookup, null)
  translate_dns                               = try(each.value.data.translate_dns, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.translate_dns, null)
  translated_network_is_destination_interface = try(each.value.data.translated_network_is_destination_interface, local.defaults.fmc.domain.ftdnatpolicy.ftdautonatrule.translated_network_is_destination_interface, null)
  translated_port                             = try(each.value.data.translated_port, null)

  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) == true ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }

  dynamic "original_network" {
    for_each = can(each.value.data.original_network) == true ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_network].id
      type = local.map_networkobjects[each.value.data.original_network].type
    }
  }

  dynamic "original_port" {
    for_each = can(each.value.data.original_port) == true ? ["1"] : []
    content {
      port     = each.value.data.original_port.port
      protocol = each.value.data.original_port.protocol
    }
  }

  dynamic "pat_options" {
    for_each = can(each.value.data.pat_options) == true ? ["1"] : []
    content {
      extended_pat_table    = try(each.value.data.pat_options.extended_pat_table, null)
      include_reserve_ports = try(each.value.data.pat_options.include_reserve_ports, null)
      interface_pat         = try(each.value.data.pat_options.interface_pat, null)
      round_robin           = try(each.value.data.pat_options.round_robin, null)
      dynamic "pat_pool_address" {
        for_each = can(each.value.data.pat_options.pat_pool_address) == true ? ["1"] : []
        content {
          id   = local.map_networkobjects[each.value.data.pat_options.pat_pool_address].id
          type = local.map_networkobjects[each.value.data.pat_options.pat_pool_address].type
        }
      }
    }
  }

  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) == true ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }

  dynamic "translated_network" {
    for_each = can(each.value.data.translated_network) == true ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_network].id
      type = local.map_networkobjects[each.value.data.translated_network].type
    }
  }
}

###
# FTD MANUAL NAT RULE
###
locals {
  res_ftdmanualnatrules = flatten([
    for domain in local.domain : [
      for natpolicy in try(domain.ftdnatpolicy, []) : [
        for ftdmanualnatrule in try(natpolicy.ftdmanualnatrule, []) : {
          key        = replace("${natpolicy.name}_${ftdmanualnatrule.name}", " ", "")
          nat_policy = natpolicy.name
          data       = ftdmanualnatrule
        }
      ]
    ]
  ])

  unique_ftdnatpolicies = distinct([for v in local.res_ftdmanualnatrules : v.nat_policy])
  ftdmanualnatrules_by_policy = { for k in local.unique_ftdnatpolicies :
    k => [for v in local.res_ftdmanualnatrules : v if v.nat_policy == k]
  }
  ftdmanualnatrules_by_policy_prev = { for k in local.unique_ftdnatpolicies :
    k => concat([""], [for v in local.res_ftdmanualnatrules : v.key if v.nat_policy == k])
  }

  ftdmanualnatrules_template = {
    natpolicies   = local.ftdmanualnatrules_by_policy,
    previous      = local.ftdmanualnatrules_by_policy_prev,
    defaults      = try(local.defaults.fmc.domain.ftdnatpolicy.ftdmanualnatrule, {}),
    networkgroups = local.res_networkgroups
  }
}

resource "local_file" "ftdmanualnatrule" {
  content = replace(
    templatefile("${path.module}/fmc_tpl_ftdmanualnatrule.tftpl", local.ftdmanualnatrules_template),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "${path.module}/generated_fmc_ftdmanualnatrule.tf"
}
