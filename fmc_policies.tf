###
# ACCESS POLICY
###
locals {
  res_accesspolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.access_policies, {}) : object if !contains(local.data_accesspolicies, object.name)
    ]
  ])
}

resource "fmc_access_policies" "accesspolicy" {
  for_each = { for accesspolicy in local.res_accesspolicies : accesspolicy.name => accesspolicy }

  # Mandatory
  name = each.value.name

  # Optional
  description                             = try(each.value.description, local.defaults.fmc.domains.access_policies.description, null)
  default_action                          = try(each.value.default_action, local.defaults.fmc.domains.access_policies.default_action, null)
  default_action_base_intrusion_policy_id = try(local.map_ipspolicies[each.value.base_ips_policy].id, local.map_ipspolicies[local.defaults.fmc.domains.access_policies.base_ips_policy].id, null)
  default_action_send_events_to_fmc       = try(each.value.send_events_to_fmc, local.defaults.fmc.domains.access_policies.send_events_to_fmc, null)
  default_action_log_begin                = try(each.value.log_begin, local.defaults.fmc.domains.access_policies.log_begin, null)
  default_action_log_end                  = try(each.value.log_end, local.defaults.fmc.domains.access_policies.log_end, null)
  default_action_syslog_config_id         = try(each.value.syslog_config_id, local.defaults.fmc.domains.access_policies.syslog_config_id, null)
}

###
# ACCESS POLICY CATEGORY
###
locals {
  res_accesspolicies_category = flatten([
    for domain in local.domains : [
      for accesspolicy in try(domain.access_policies, {}) : [
        for accesspolicy_category in try(accesspolicy.categories, {}) : {
          key  = "${accesspolicy.name}/${accesspolicy_category}"
          acp  = local.map_accesspolicies[accesspolicy.name].id
          data = accesspolicy_category
        }
      ]
    ]
  ])
}

resource "fmc_access_policies_category" "accesspolicy_category" {
  for_each = { for accesspolicy_category in local.res_accesspolicies_category : accesspolicy_category.key => accesspolicy_category }

  # Mandatory
  name             = each.value.data
  access_policy_id = each.value.acp
}

###
# PREFILTER POLICY
###
locals {
  res_prefilterpolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.prefilter_policies, {}) : object
    ]
  ])
}

resource "fmc_prefilter_policy" "prefilterpolicy" {
  for_each = { for prefpolicy in local.res_prefilterpolicies : prefpolicy.name => prefpolicy }

  # Mandatory  
  name = each.value.name

  # Optional    
  default_action {
    #log_end           = try(each.value.log_end, null)         # Not supported by provider
    log_begin          = try(each.value.log_begin, null)
    send_events_to_fmc = try(each.value.send_events_to_fmc, null)
    action             = try(each.value.action, local.defaults.fmc.domains.prefilter_policies.action, "ANALYZE_TUNNELS")
  }

  description = try(each.value.description, local.defaults.fmc.domains.prefilter_policies.description, null)
}

###
# FTD NAT POLICY
###
locals {
  res_ftdnatpolicies = flatten([
    for domain in local.domains : [
      for object in try(domain.ftd_nat_policies, {}) : object if !contains(local.data_ftdnatpolicies, object.name)
    ]
  ])
}

resource "fmc_ftd_nat_policies" "ftdnatpolicy" {
  for_each = { for ftdnatpolicy in local.res_ftdnatpolicies : ftdnatpolicy.name => ftdnatpolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  description = try(each.value.description, local.defaults.fmc.domains.ftd_nat_policy.description, null)
}

###
# FTD AUTO NAT RULE
###
locals {
  res_ftdautonatrules = flatten([
    for domain in local.domains : [
      for natpolicy in try(domain.ftd_nat_policies, {}) : [
        for ftdautonatrule in try(natpolicy.ftd_auto_nat_rules, {}) : {
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
  fallthrough                                 = try(each.value.data.fall_through, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.fall_through, null)
  ipv6                                        = try(each.value.data.ipv6, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.ipv6, null)
  net_to_net                                  = try(each.value.data.net_to_net, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.net_to_net, null)
  no_proxy_arp                                = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.no_proxy_arp, null)
  perform_route_lookup                        = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.perform_route_lookup, null)
  translate_dns                               = try(each.value.data.translate_dns, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.translate_dns, null)
  translated_network_is_destination_interface = try(each.value.data.translated_network_is_destination_interface, local.defaults.fmc.domains.ftd_nat_policies.ftd_auto_nat_rules.translated_network_is_destination_interface, null)
  translated_port                             = try(each.value.data.translated_port, null)

  dynamic "destination_interface" {
    for_each = can(each.value.data.destination_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.destination_interface].id
      type = local.map_securityzones[each.value.data.destination_interface].type
    }
  }

  dynamic "original_network" {
    for_each = can(each.value.data.original_network) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.original_network].id
      type = local.map_networkobjects[each.value.data.original_network].type
    }
  }

  dynamic "original_port" {
    for_each = can(each.value.data.original_port) ? ["1"] : []
    content {
      port     = each.value.data.original_port.port
      protocol = each.value.data.original_port.protocol
    }
  }

  dynamic "pat_options" {
    for_each = can(each.value.data.pat_options) ? ["1"] : []
    content {
      extended_pat_table    = try(each.value.data.pat_options.extended_pat_table, null)
      include_reserve_ports = try(each.value.data.pat_options.include_reserve_ports, null)
      interface_pat         = try(each.value.data.pat_options.interface_pat, null)
      round_robin           = try(each.value.data.pat_options.round_robin, null)
      dynamic "pat_pool_address" {
        for_each = can(each.value.data.pat_options.pat_pool_address) ? ["1"] : []
        content {
          id   = local.map_networkobjects[each.value.data.pat_options.pat_pool_address].id
          type = local.map_networkobjects[each.value.data.pat_options.pat_pool_address].type
        }
      }
    }
  }

  dynamic "source_interface" {
    for_each = can(each.value.data.source_interface) ? ["1"] : []
    content {
      id   = local.map_securityzones[each.value.data.source_interface].id
      type = local.map_securityzones[each.value.data.source_interface].type
    }
  }

  dynamic "translated_network" {
    for_each = can(each.value.data.translated_network) ? ["1"] : []
    content {
      id   = local.map_networkobjects[each.value.data.translated_network].id
      type = local.map_networkobjects[each.value.data.translated_network].type
    }
  }
}

###
# IPS POLICY
###
locals {
  res_ipspolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.ips_policies, []) : object
    ]
  ])
}

resource "fmc_ips_policies" "ips_policy" {
  for_each = { for ipspolicy in local.res_ipspolicies : ipspolicy.name => ipspolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  inspection_mode = try(each.value.inspection_mode, local.defaults.fmc.domains.ips_policies.inspection_mode, null)
  basepolicy_id   = try(data.fmc_ips_policies.ips_policy[each.value.base_policy].id, null)

  depends_on = [
    data.fmc_ips_policies.ips_policy
  ]
}
