###
# FTD MANUAL NAT RULE
###
locals {
  res_ftdmanualnatrules = flatten([
    for domain in local.domains : [
      for natpolicy in try(domain.ftd_nat_policies, []) : [
        for ftdmanualnatrule in try(natpolicy.ftd_manual_nat_rules, []) : {
          key        = replace("${natpolicy.name}_${ftdmanualnatrule.name}", " ", "")
          nat_policy = natpolicy.name
          idx        = index(natpolicy.ftd_manual_nat_rules, ftdmanualnatrule)
          data       = ftdmanualnatrule
        }
      ]
    ]
  ])
}

resource "fmc_ftd_manualnat_rules" "manualnat_rules_0" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 0 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  depends_on                        = [fmc_ftd_nat_policies.ftdnatpolicy]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_1" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 1 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_2" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 2 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_3" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 3 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_4" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 4 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_5" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 5 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_6" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 6 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_7" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 7 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_8" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 8 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_9" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 9 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_10" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 10 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_11" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 11 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_12" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 12 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_13" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 13 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_14" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 14 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_15" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 15 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_16" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 16 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_17" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 17 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_18" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 18 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_19" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 19 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_20" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 20 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_21" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 21 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_22" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 22 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_23" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 23 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_24" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 24 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_25" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 25 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_26" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 26 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_27" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 27 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_28" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 28 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_29" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 29 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_30" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 30 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_31" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 31 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_32" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 32 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_33" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 33 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_34" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 34 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_35" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 35 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_36" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 36 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_37" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 37 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_38" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 38 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_39" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 39 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_40" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 40 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_41" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 41 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_42" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 42 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_43" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 43 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_44" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 44 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_45" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 45 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_46" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 46 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_47" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 47 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_48" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 48 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_49" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 49 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_50" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 50 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_51" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 51 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_52" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 52 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_53" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 53 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_54" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 54 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_55" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 55 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_56" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 56 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_57" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 57 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_58" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 58 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_59" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 59 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_60" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 60 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_61" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 61 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_62" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 62 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_63" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 63 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_64" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 64 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_65" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 65 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_66" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 66 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_67" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 67 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_68" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 68 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_69" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 69 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_70" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 70 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_71" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 71 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_72" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 72 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_73" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 73 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_74" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 74 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_75" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 75 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_76" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 76 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_77" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 77 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_78" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 78 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_79" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 79 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_80" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 80 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_81" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 81 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_82" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 82 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_83" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 83 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_84" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 84 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_85" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 85 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_86" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 86 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_87" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 87 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_88" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 88 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_89" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 89 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_90" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 90 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_91" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 91 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_92" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 92 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_93" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 93 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_94" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 94 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_95" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 95 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_96" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 96 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_ftd_manualnat_rules.manualnat_rules_95,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_97" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 97 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_ftd_manualnat_rules.manualnat_rules_95,
    fmc_ftd_manualnat_rules.manualnat_rules_96,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_98" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 98 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_ftd_manualnat_rules.manualnat_rules_95,
    fmc_ftd_manualnat_rules.manualnat_rules_96,
    fmc_ftd_manualnat_rules.manualnat_rules_97,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}
resource "fmc_ftd_manualnat_rules" "manualnat_rules_99" {
  for_each = { for rule in local.res_ftdmanualnatrules : rule.key => rule if rule.idx == 99 }
  # Mandatory
  nat_policy = local.map_natpolicies[each.value.nat_policy].id
  nat_type   = each.value.data.nat_type
  dynamic "original_source" {
    for_each = can(each.value.data.original_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_source].id
      type = local.map_networkobjects[each.value.data.original_source].type
    }
  }
  # Optional
  description                       = try(each.value.data.description, null)
  enabled                           = try(each.value.data.enabled, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
  fallthrough                       = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.fallthrough, null)
  interface_in_original_destination = try(each.value.data.interface_in_original_destination, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_original_destination, null)
  interface_in_translated_source    = try(each.value.data.interface_in_translated_source, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.interface_in_translated_source, null)
  ipv6                              = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
  net_to_net                        = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
  no_proxy_arp                      = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
  perform_route_lookup              = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
  section                           = try(each.value.data.section, null)
  translate_dns                     = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
  unidirectional                    = try(each.value.data.unidirectional, local.defaults.fmc.domains.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
  # Positioning
  depends_on = [
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_ftd_manualnat_rules.manualnat_rules_95,
    fmc_ftd_manualnat_rules.manualnat_rules_96,
    fmc_ftd_manualnat_rules.manualnat_rules_97,
    fmc_ftd_manualnat_rules.manualnat_rules_98,
    fmc_ftd_nat_policies.ftdnatpolicy
  ]
  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }
  dynamic "original_destination" {
    for_each = can(each.value.data.original_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_destination].id
      type = local.map_networkobjects[each.value.data.original_destination].type
    }
  }
  dynamic "original_destination_port" {
    for_each = can(each.value.data.original_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_destination_port].id
      type = local.map_ports[each.value.data.original_destination_port].type
    }
  }
  dynamic "original_source_port" {
    for_each = can(each.value.data.original_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.original_source_port].id
      type = local.map_ports[each.value.data.original_source_port].type
    }
  }
  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }
  dynamic "translated_destination" {
    for_each = can(each.value.data.translated_destination) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_destination].id
      type = local.map_networkobjects[each.value.data.translated_destination].type
    }
  }
  dynamic "translated_destination_port" {
    for_each = can(each.value.data.translated_destination_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_destination_port].id
      type = local.map_ports[each.value.data.translated_destination_port].type
    }
  }
  dynamic "translated_source" {
    for_each = can(each.value.data.translated_source) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_source].id
      type = local.map_networkobjects[each.value.data.translated_source].type
    }
  }
  dynamic "translated_source_port" {
    for_each = can(each.value.data.translated_source_port) ? ["1"] : []
    content {
      id   = local.map_ports[each.value.data.translated_source_port].id
      type = local.map_ports[each.value.data.translated_source_port].type
    }
  }
}