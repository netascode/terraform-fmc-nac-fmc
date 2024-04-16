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
