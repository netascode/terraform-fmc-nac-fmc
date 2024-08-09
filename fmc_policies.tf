###
# ACCESS POLICY
###
locals {
  res_accesspolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.policies.access_policies, {}) : object if !contains(local.data_accesspolicies, object.name)
    ]
  ])
}

resource "fmc_access_policies" "accesspolicy" {
  for_each = { for accesspolicy in local.res_accesspolicies : accesspolicy.name => accesspolicy }

  # Mandatory
  name = each.value.name

  # Optional
  description                             = try(each.value.description, local.defaults.fmc.domains.policies.access_policies.description, null)
  default_action                          = try(each.value.default_action, local.defaults.fmc.domains.policies.access_policies.default_action, null)
  default_action_base_intrusion_policy_id = try(local.map_ipspolicies[each.value.base_ips_policy].id, local.map_ipspolicies[local.defaults.fmc.domains.policies.access_policies.base_ips_policy].id, null)
  default_action_send_events_to_fmc       = try(each.value.send_events_to_fmc, local.defaults.fmc.domains.policies.access_policies.send_events_to_fmc, null)
  default_action_log_begin                = try(each.value.log_begin, local.defaults.fmc.domains.policies.access_policies.log_begin, null)
  default_action_log_end                  = try(each.value.log_end, local.defaults.fmc.domains.policies.access_policies.log_end, null)
  default_action_syslog_config_id         = try(each.value.syslog_config_id, local.defaults.fmc.domains.policies.access_policies.syslog_config_id, null)
}

###
# ACCESS POLICY CATEGORY
###
locals {
  res_accesspolicies_category = flatten([
    for domain in local.domains : [
      for accesspolicy in try(domain.policies.access_policies, []) : [
        for accesspolicy_category in try(accesspolicy.categories, {}) : {
          key  = "${accesspolicy.name}/${accesspolicy_category.name}"
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
  name             = each.value.data.name
  access_policy_id = each.value.acp
}

###
# PREFILTER POLICY
###
locals {
  res_prefilterpolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.policies.prefilter_policies, {}) : object
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

  description = try(each.value.description, local.defaults.fmc.domains.policies.prefilter_policies.description, null)
}

###
# FTD NAT POLICY
###
locals {
  res_ftdnatpolicies = flatten([
    for domain in local.domains : [
      for object in try(domain.policies.ftd_nat_policies, {}) : object if !contains(local.data_ftdnatpolicies, object.name)
    ]
  ])
}

resource "fmc_ftd_nat_policies" "ftdnatpolicy" {
  for_each = { for ftdnatpolicy in local.res_ftdnatpolicies : ftdnatpolicy.name => ftdnatpolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  description = try(each.value.description, local.defaults.fmc.domains.policies.ftd_nat_policy.description, null)
}

###
# FTD AUTO NAT RULE
###
locals {
  res_ftdautonatrules = flatten([
    for domain in local.domains : [
      for natpolicy in try(domain.policies.ftd_nat_policies, []) : [
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
  fallthrough                                 = try(each.value.data.fall_through, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.fall_through, null)
  ipv6                                        = try(each.value.data.ipv6, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.ipv6, null)
  net_to_net                                  = try(each.value.data.net_to_net, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.net_to_net, null)
  no_proxy_arp                                = try(each.value.data.no_proxy_arp, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.no_proxy_arp, null)
  perform_route_lookup                        = try(each.value.data.perform_route_lookup, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.perform_route_lookup, null)
  translate_dns                               = try(each.value.data.translate_dns, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.translate_dns, null)
  translated_network_is_destination_interface = try(each.value.data.translated_network_is_destination_interface, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.translated_network_is_destination_interface, null)
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
    for_each = try(length(each.value.data.pat_options), 0) != 0 ? ["1"] : []
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
      for object in try(domains.policies.ips_policies, []) : object
    ]
  ])
}

resource "fmc_ips_policies" "ips_policy" {
  for_each = { for ipspolicy in local.res_ipspolicies : ipspolicy.name => ipspolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  inspection_mode = try(each.value.inspection_mode, local.defaults.fmc.domains.policies.ips_policies.inspection_mode, null)
  basepolicy_id   = try(data.fmc_ips_policies.ips_policy[each.value.base_policy].id, null)

  depends_on = [
    data.fmc_ips_policies.ips_policy
  ]
}

###
# Network Analysis Policy
###
locals {
  res_network_analysis_policies = flatten([
    for domains in local.domains : [
      for object in try(domains.policies.network_analysis_policies, []) : object
    ]
  ])
}

resource "fmc_network_analysis_policy" "network_analysis_policy" {
  for_each = { for net_analysis_policy in local.res_network_analysis_policies : net_analysis_policy.name => net_analysis_policy }

  # Mandatory  
  name = each.value.name
  base_policy {
    name = each.value.base_policy
  }

  # Optional  
  description  = try(each.value.description, local.defaults.fmc.domains.policies.network_analysis_policies.description, null)
  snort_engine = try(each.value.snort_engine, local.defaults.fmc.domains.policies.network_analysis_policies.snort_engine, null)

}



###
# POLICY ASSIGNMENT
###
locals {
  res_natpolicyassignments = flatten([
    for nat_policy in local.res_ftdnatpolicies : {
      "name" = nat_policy.name
      "objects" = compact(flatten(concat([
        for domain in local.domains : [
          for device in try(domain.devices.devices, []) : contains(keys(device), "nat_policy") && try(device.nat_policy, null) == nat_policy.name ? device.name : null
        ]
        ],
        [
          for domain in local.domains : [
            for cluster in try(domain.devices.clusters, []) : contains(keys(cluster), "nat_policy") && try(cluster.nat_policy, null) == nat_policy.name ? cluster.name : null
          ]
        ]
      )))
    }
  ])

  res_acppolicyassignments = flatten([
    for acp_policy in local.res_accesspolicies : {
      "name" = acp_policy.name
      "objects" = compact(flatten(concat([
        for domain in local.domains : [
          for device in try(domain.devices.devices, []) : contains(keys(device), "access_policy") && device.access_policy == acp_policy.name && contains(local.data_devices, device.name) ? device.name : null
        ]
        ],
        [
          for domain in local.domains : [
            for cluster in try(domain.devices.clusters, []) : contains(keys(cluster), "access_policy") && cluster.access_policy == acp_policy.name && contains(local.data_clusters, cluster.name) ? cluster.name : null
          ]
        ]
      )))
    }
  ])

}

resource "fmc_policy_devices_assignments" "nat_policy_assignment" {
  for_each = { for nat in local.res_natpolicyassignments : nat.name => nat if length(nat.objects) > 0 }

  # Mandatory
  dynamic "target_devices" {
    for_each = { for device in each.value.objects : device => device }
    content {
      id   = try(local.map_clusters[target_devices.value].id, local.map_devices[target_devices.value].id, null)
      type = try(local.map_clusters[target_devices.value].type, local.map_devices[target_devices.value].type, null)
    }
  }
  policy {
    id   = try(local.map_natpolicies[each.value.name].id, null)
    type = try(local.map_natpolicies[each.value.name].type, null)
  }
  depends_on = [
    fmc_devices.device,
    fmc_device_cluster.cluster
  ]
}

resource "fmc_policy_devices_assignments" "access_policy_assignment" {
  for_each = { for acp in local.res_acppolicyassignments : acp.name => acp if length(acp.objects) > 0 }


  # Mandatory
  dynamic "target_devices" {
    for_each = { for device in each.value.objects : device => device }
    content {
      id   = try(local.map_clusters[target_devices.value].id, local.map_devices[target_devices.value].id, null)
      type = try(local.map_clusters[target_devices.value].type, local.map_devices[target_devices.value].type, null)
    }
  }

  policy {
    id   = try(local.map_accesspolicies[each.value.name].id, null)
    type = try(local.map_accesspolicies[each.value.name].type, null)
  }
  depends_on = [
    fmc_devices.device,
    fmc_device_cluster.cluster
  ]
}