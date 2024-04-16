resource "fmc_access_rules" "access_rule_0" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 0 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  depends_on         = [fmc_access_policies_category.accesspolicy_category]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_1" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 1 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_2" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 2 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_3" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 3 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_4" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 4 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_5" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 5 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_6" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 6 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_7" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 7 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_8" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 8 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_9" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 9 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_10" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 10 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_11" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 11 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_12" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 12 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_13" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 13 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_14" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 14 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_15" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 15 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_16" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 16 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_17" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 17 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_18" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 18 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_19" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 19 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_20" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 20 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_21" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 21 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_22" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 22 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_23" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 23 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_24" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 24 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_25" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 25 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_rules.access_rule_24,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_26" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 26 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_rules.access_rule_24,
    fmc_access_rules.access_rule_25,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_27" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 27 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_rules.access_rule_24,
    fmc_access_rules.access_rule_25,
    fmc_access_rules.access_rule_26,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_28" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 28 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_rules.access_rule_24,
    fmc_access_rules.access_rule_25,
    fmc_access_rules.access_rule_26,
    fmc_access_rules.access_rule_27,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
resource "fmc_access_rules" "access_rule_29" {
  for_each = { for rule in local.res_accessrules : rule.key => rule if rule.idx == 29 }
  # Mandatory
  acp     = local.map_accesspolicies[each.value.acp].id
  name    = each.value.data.name
  action  = each.value.data.action
  enabled = try(each.value.data.enabled, local.defaults.fmc.domains.access_policies.access_rules.enabled, true)
  # Optional
  category      = try(each.value.data.category, null)
  enable_syslog = try(each.value.data.enable_syslog, local.defaults.fmc.domains.access_policies.access_rules.enable_syslog, null)
  file_policy   = try(each.value.data.file_policy, null)
  ips_policy    = try(local.map_ipspolicies[each.value.data.ips_policy].id, null)
  log_begin     = try(each.value.data.log_connection_begin, null)
  log_end       = try(each.value.data.log_connection_end, null)
  log_files     = try(each.value.data.log_files, null)
  #new_comments        = try(each.value.data.new_comments, null)
  section            = try(each.value.data.section, null)
  send_events_to_fmc = try(each.value.data.send_events_to_fmc, null)
  syslog_config      = try(each.value.data.syslog_config, null)
  syslog_severity    = try(each.value.data.syslog_severity, null)
  # Positioning
  depends_on = [
    fmc_access_rules.access_rule_0,
    fmc_access_rules.access_rule_1,
    fmc_access_rules.access_rule_2,
    fmc_access_rules.access_rule_3,
    fmc_access_rules.access_rule_4,
    fmc_access_rules.access_rule_5,
    fmc_access_rules.access_rule_6,
    fmc_access_rules.access_rule_7,
    fmc_access_rules.access_rule_8,
    fmc_access_rules.access_rule_9,
    fmc_access_rules.access_rule_10,
    fmc_access_rules.access_rule_11,
    fmc_access_rules.access_rule_12,
    fmc_access_rules.access_rule_13,
    fmc_access_rules.access_rule_14,
    fmc_access_rules.access_rule_15,
    fmc_access_rules.access_rule_16,
    fmc_access_rules.access_rule_17,
    fmc_access_rules.access_rule_18,
    fmc_access_rules.access_rule_19,
    fmc_access_rules.access_rule_20,
    fmc_access_rules.access_rule_21,
    fmc_access_rules.access_rule_22,
    fmc_access_rules.access_rule_23,
    fmc_access_rules.access_rule_24,
    fmc_access_rules.access_rule_25,
    fmc_access_rules.access_rule_26,
    fmc_access_rules.access_rule_27,
    fmc_access_rules.access_rule_28,
    fmc_access_policies_category.accesspolicy_category
  ]
  dynamic "destination_dynamic_objects" {
    for_each = can(each.value.data.destination_dynamic_objects) ? ["1"] : []
    content {
      dynamic "destination_dynamic_object" {
        for_each = { for obj in try(each.value.data.destination_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[destination_dynamic_object.value].id
          type = local.map_dynamicobjects[destination_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "destination_networks" {
    for_each = can(each.value.data.destination_networks) ? ["1"] : []
    content {
      dynamic "destination_network" {
        for_each = { for obj in try(each.value.data.destination_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[destination_network.value].id
          type = local.map_networkobjects[destination_network.value].type
        }
      }
    }
  }
  dynamic "destination_ports" {
    for_each = can(each.value.data.destination_ports) ? ["1"] : []
    content {
      dynamic "destination_port" {
        for_each = { for obj in try(each.value.data.destination_ports, []) : obj => obj }
        content {
          id   = local.map_ports[destination_port.value].id
          type = local.map_ports[destination_port.value].type
        }
      }
    }
  }
  dynamic "destination_security_group_tags" {
    for_each = can(each.value.data.destination_sgts) ? ["1"] : []
    content {
      dynamic "destination_security_group_tag" {
        for_each = { for obj in try(each.value.data.destination_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[destination_security_group_tag.value].id
          type = local.map_sgts[destination_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "destination_zones" {
    for_each = can(each.value.data.destination_zones) ? ["1"] : []
    content {
      dynamic "destination_zone" {
        for_each = { for zone in try(each.value.data.destination_zones, []) : zone => zone }
        content {
          id   = local.map_securityzones[destination_zone.value].id
          type = local.map_securityzones[destination_zone.value].type
        }
      }
    }
  }
  dynamic "source_dynamic_objects" {
    for_each = can(each.value.data.source_netwsource_dynamic_objectsorks) ? ["1"] : []
    content {
      dynamic "source_dynamic_object" {
        for_each = { for obj in try(each.value.data.source_dynamic_objects, []) : obj => obj }
        content {
          id   = local.map_dynamicobjects[source_dynamic_object.value].id
          type = local.map_dynamicobjects[source_dynamic_object.value].type
        }
      }
    }
  }
  dynamic "source_networks" {
    for_each = can(each.value.data.source_networks) ? ["1"] : []
    content {
      dynamic "source_network" {
        for_each = { for obj in try(each.value.data.source_networks, []) : obj => obj }
        content {
          id   = local.map_networkobjects[source_network.value].id
          type = local.map_networkobjects[source_network.value].type
        }
      }
    }
  }
  dynamic "source_ports" {
    for_each = can(each.value.data.source_ports) ? ["1"] : []
    content {
      dynamic "source_port" {
        for_each = { for obj in try(each.value.data.source_ports, []) : obj => obj }
        content {
          id   = local.map_ports[source_port.value].id
          type = local.map_ports[source_port.value].type
        }
      }
    }
  }
  dynamic "source_security_group_tags" {
    for_each = can(each.value.data.source_sgts) ? ["1"] : []
    content {
      dynamic "source_security_group_tag" {
        for_each = { for obj in try(each.value.data.source_sgts, []) : obj => obj }
        content {
          id   = local.map_sgts[source_security_group_tag.value].id
          type = local.map_sgts[source_security_group_tag.value].type
        }
      }
    }
  }
  dynamic "source_zones" {
    for_each = can(each.value.data.source_zones) ? ["1"] : []
    content {
      dynamic "source_zone" {
        for_each = { for obj in try(each.value.data.source_zones, []) : obj => obj }
        content {
          id   = local.map_securityzones[source_zone.value].id
          type = local.map_securityzones[source_zone.value].type
        }
      }
    }
  }
  dynamic "urls" {
    for_each = can(each.value.data.urls) ? ["1"] : []
    content {
      dynamic "url" {
        for_each = { for obj in try(each.value.data.urls, []) : obj => obj }
        content {
          id   = try(local.map_urls[url.value].id, local.map_urlgroups[url.value].id)
          type = try(local.map_urls[url.value].type, local.map_urlgroups[url.value].type)
        }
      }
    }
  }
}
