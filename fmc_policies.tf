##########################################################
###    ACCESS CONTROL POLICY
##########################################################
locals {
  data_access_control_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for access_control_policy in try(domain.policies.access_control_policies, {}) : {
          name   = access_control_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_access_control_policy = {
    for item in flatten([
      for domain in local.domains : [
        for access_control_policy in try(domain.policies.access_control_policies, []) : [
          {
            domain         = domain.name
            name           = access_control_policy.name
            description    = try(access_control_policy.description, local.defaults.fmc.domains.policies.access_control_policies.description, null)
            default_action = try(access_control_policy.default_action, local.defaults.fmc.domains.policies.access_control_policies.default_action)

            prefilter_policy_id = try(access_control_policy.prefilter_policy, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_prefilter_policies["${domain_path}:${access_control_policy.prefilter_policy}"].id
                if contains(keys(local.map_prefilter_policies), "${domain_path}:${access_control_policy.prefilter_policy}")
            })[0]) : null
            categories = [for category in try(access_control_policy.categories, []) : {
              name    = category.name
              section = try(category.section, null)
            }]
            default_action_intrusion_policy_id = try(access_control_policy.base_intrusion_policy, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_intrusion_policies["${domain_path}:${access_control_policy.base_intrusion_policy}"].id
                if contains(keys(local.map_intrusion_policies), "${domain_path}:${access_control_policy.base_intrusion_policy}")
            })[0]) : null
            default_action_variable_set_id = try(access_control_policy.base_variable_set, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_variable_sets["${domain_path}:${access_control_policy.base_variable_set}"].id
                if contains(keys(local.map_variable_sets), "${domain_path}:${access_control_policy.base_variable_set}")
            })[0]) : null
            default_action_log_connection_begin = try(access_control_policy.log_connection_begin, local.defaults.fmc.domains.policies.access_control_policies.log_connection_begin, null)
            default_action_log_connection_end   = try(access_control_policy.log_connection_end, local.defaults.fmc.domains.policies.access_control_policies.log_connection_end, null)
            default_action_send_events_to_fmc   = try(access_control_policy.send_events_to_fmc, local.defaults.fmc.domains.policies.access_control_policies.send_events_to_fmc, null)
            default_action_send_syslog          = try(access_control_policy.send_syslog, local.defaults.fmc.domains.policies.access_control_policies.send_syslog, null)
            default_action_snmp_alert_id = try(access_control_policy.snmp_alert, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_snmp_alerts["${domain_path}:${access_control_policy.snmp_alert}"].id
                if contains(keys(local.map_snmp_alerts), "${domain_path}:${access_control_policy.snmp_alert}")
            })[0]) : null
            default_action_syslog_alert_id = try(access_control_policy.syslog_alert, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_syslog_alerts["${domain_path}:${access_control_policy.syslog_alert}"].id
                if contains(keys(local.map_syslog_alerts), "${domain_path}:${access_control_policy.syslog_alert}")
            })[0]) : null
            default_action_syslog_severity = try(access_control_policy.syslog_severity, local.defaults.fmc.domains.policies.access_control_policies.syslog_severity, null)

            rules = [for rule in try(access_control_policy.access_rules, []) : {
              name          = rule.name
              action        = rule.action
              category_name = try(rule.category, null)
              section       = try(rule.section, null)
              description   = try(rule.description, null)
              enabled       = try(rule.enabled, local.defaults.fmc.domains.policies.access_control_policies.access_rules.enabled, null)

              destination_dynamic_objects = [for destination_dynamic_object in try(rule.destination_dynamic_objects, []) : {
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_dynamic_objects["${domain_path}:${destination_dynamic_object}"].id
                  if contains(keys(local.map_dynamic_objects), "${domain_path}:${destination_dynamic_object}")
                })[0]
                type = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_dynamic_objects["${domain_path}:${destination_dynamic_object}"].type
                  if contains(keys(local.map_dynamic_objects), "${domain_path}:${destination_dynamic_object}")
                })[0]
              }]
              destination_network_literals = [for destination_network_literal in try(rule.destination_network_literals, []) : {
                value = destination_network_literal
                type  = strcontains(destination_network_literal, "/") ? "Network" : "Host"
              }]
              destination_network_objects = [for destination_network_object in try(rule.destination_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network_object}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network_object}"].type
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                )
              }]
              destination_port_literals = [for destination_port_literal in try(rule.destination_port_literals, []) : {
                protocol  = local.help_protocol_mapping[destination_port_literal.protocol]
                port      = try(destination_port_literal.port, null)
                icmp_type = try(destination_port_literal.icmp_type, null)
                icmp_code = try(destination_port_literal.icmp_code, null)
                type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              destination_port_objects = [for destination_port_object in try(rule.destination_port_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${destination_port_object}"].id
                    if contains(keys(local.map_services), "${domain_path}:${destination_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${destination_port_object}"].id
                    if contains(keys(local.map_port_groups), "${domain_path}:${destination_port_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${destination_port_object}"].type
                    if contains(keys(local.map_services), "${domain_path}:${destination_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${destination_port_object}"].type
                    if contains(keys(local.map_port_groups), "${domain_path}:${destination_port_object}")
                  })[0],
                )
              }]
              destination_sgt_objects = [for destination_sgt in try(rule.destination_sgts, []) : {
                name = destination_sgt
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_sgts["${domain_path}:${destination_sgt}"].id
                  if contains(keys(local.map_sgts), "${domain_path}:${destination_sgt}")
                })[0],
                type = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_sgts["${domain_path}:${destination_sgt}"].type
                  if contains(keys(local.map_sgts), "${domain_path}:${destination_sgt}")
                })[0],
              }]
              destination_zones = [for destination_zone in try(rule.destination_zones, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${destination_zone}"].id
                    if contains(keys(local.map_security_zones), "${domain_path}:${destination_zone}")
                })[0])
              }]

              source_dynamic_objects = [for source_dynamic_object in try(rule.source_dynamic_objects, []) : {
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_dynamic_objects["${domain_path}:${source_dynamic_object}"].id
                  if contains(keys(local.map_dynamic_objects), "${domain_path}:${source_dynamic_object}")
                })[0]
                type = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_dynamic_objects["${domain_path}:${source_dynamic_object}"].type
                  if contains(keys(local.map_dynamic_objects), "${domain_path}:${source_dynamic_object}")
                })[0]
              }]
              source_network_literals = [for source_network_literal in try(rule.source_network_literals, []) : {
                value = source_network_literal
                type  = strcontains(source_network_literal, "/") ? "Network" : "Host"
              }]
              source_network_objects = [for source_network_object in try(rule.source_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${source_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${source_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${source_network_object}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${source_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${source_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${source_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${source_network_object}"].type
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${source_network_object}")
                  })[0],
                )
              }]
              source_port_literals = [for source_port_literal in try(rule.source_port_literals, []) : {
                protocol  = local.help_protocol_mapping[source_port_literal.protocol]
                port      = try(source_port_literal.port, null)
                icmp_type = try(source_port_literal.icmp_type, null)
                icmp_code = try(source_port_literal.icmp_code, null)
                type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              source_port_objects = [for source_port_object in try(rule.source_port_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${source_port_object}"].id
                    if contains(keys(local.map_services), "${domain_path}:${source_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${source_port_object}"].id
                    if contains(keys(local.map_port_groups), "${domain_path}:${source_port_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${source_port_object}"].type
                    if contains(keys(local.map_services), "${domain_path}:${source_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${source_port_object}"].type
                    if contains(keys(local.map_port_groups), "${domain_path}:${source_port_object}")
                  })[0],
                )
              }]
              source_zones = [for source_zone in try(rule.source_zones, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${source_zone}"].id
                    if contains(keys(local.map_security_zones), "${domain_path}:${source_zone}")
                })[0])
              }]
              source_sgt_objects = [for source_sgt in try(rule.source_sgts, []) : {
                name = source_sgt
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_sgts["${domain_path}:${source_sgt}"].id
                  if contains(keys(local.map_sgts), "${domain_path}:${source_sgt}")
                })[0],
                type = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_sgts["${domain_path}:${source_sgt}"].type
                  if contains(keys(local.map_sgts), "${domain_path}:${source_sgt}")
                })[0],
              }]

              endpoint_device_types = [for endpoint_device_type in try(rule.endpoint_device_types, []) : {
                name = endpoint_device_type
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => data.fmc_endpoint_device_types.endpoint_device_types[domain_path].items[endpoint_device_type].id
                  if contains(keys(try(data.fmc_endpoint_device_types.endpoint_device_types[domain_path].items, {})), endpoint_device_type)
                })[0],
                type = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => data.fmc_endpoint_device_types.endpoint_device_types[domain_path].items[endpoint_device_type].type
                  if contains(keys(try(data.fmc_endpoint_device_types.endpoint_device_types[domain_path].items, {})), endpoint_device_type)
                })[0],
              }]

              applications = [for application in try(rule.applications, []) : {
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => data.fmc_applications.applications[domain_path].items[application].id
                  if contains(keys(try(data.fmc_applications.applications[domain_path].items, {})), application)
                })[0],
              }]

              application_filter_objects = [for application_filter_object in try(rule.application_filter_objects, []) : {
                id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_application_filters["${domain_path}:${application_filter_object}"].id
                  if contains(keys(local.map_application_filters), "${domain_path}:${application_filter_object}")
                })[0],
              }]

              # url_categories = [for url_category in try(rule.url_categories, []) : {
              #   id         = try(local.map_url_categories[url_category.category].id)
              #   reputation = try(url_category.reputation, null)
              # }]

              url_objects = [for url_object in try(rule.url_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_urls["${domain_path}:${url_object}"].id
                    if contains(keys(local.map_urls), "${domain_path}:${url_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_url_groups["${domain_path}:${url_object}"].id
                    if contains(keys(local.map_url_groups), "${domain_path}:${url_object}")
                  })[0],
                )
              }]

              vlan_tag_literals = [for vlan_tag_literal in try(rule.vlan_tag_literals, []) : {
                start_tag = vlan_tag_literal.start_tag
                end_tag   = try(vlan_tag_literal.end_tag, vlan_tag_literal.start_tag)
              }]
              vlan_tag_objects = [for vlan_tag_object in try(rule.vlan_tag_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_vlan_tags["${domain_path}:${vlan_tag_object}"].id
                    if contains(keys(local.map_vlan_tags), "${domain_path}:${vlan_tag_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_vlan_tag_groups["${domain_path}:${vlan_tag_object}"].id
                    if contains(keys(local.map_vlan_tag_groups), "${domain_path}:${vlan_tag_object}")
                })[0])
              }]

              file_policy_id = try(rule.file_policy, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_file_policies["${domain_path}:${rule.file_policy}"].id
                  if contains(keys(local.map_file_policies), "${domain_path}:${rule.file_policy}")
              })[0]) : null

              intrusion_policy_id = try(rule.intrusion_policy, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_intrusion_policies["${domain_path}:${rule.intrusion_policy}"].id
                  if contains(keys(local.map_intrusion_policies), "${domain_path}:${rule.intrusion_policy}")
              })[0]) : null
              variable_set_id = try(rule.variable_set, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_variable_sets["${domain_path}:${rule.variable_set}"].id
                  if contains(keys(local.map_variable_sets), "${domain_path}:${rule.variable_set}")
              })[0]) : null
              time_range_id = try(rule.time_range, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_time_ranges["${domain_path}:${rule.time_range}"].id
                  if contains(keys(local.map_time_ranges), "${domain_path}:${rule.time_range}")
              })[0]) : null

              log_connection_begin = try(rule.log_connection_begin, local.defaults.fmc.domains.policies.access_control_policies.access_rules.log_connection_begin, null)
              log_connection_end   = try(rule.log_connection_end, local.defaults.fmc.domains.policies.access_control_policies.access_rules.log_connection_end, null)
              log_files            = try(rule.log_files, local.defaults.fmc.domains.policies.access_control_policies.access_rules.log_files, null)
              send_events_to_fmc   = try(rule.send_events_to_fmc, local.defaults.fmc.domains.policies.access_control_policies.access_rules.send_events_to_fmc, null)
              send_syslog          = try(rule.send_syslog, local.defaults.fmc.domains.policies.access_control_policies.access_rules.send_syslog, null)
              snmp_alert_id = try(rule.snmp_alert, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_snmp_alerts["${domain_path}:${rule.snmp_alert}"].id
                  if contains(keys(local.map_snmp_alerts), "${domain_path}:${rule.snmp_alert}")
              })[0]) : null
              syslog_alert_id = try(rule.syslog_alert, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_syslog_alerts["${domain_path}:${rule.syslog_alert}"].id
                  if contains(keys(local.map_syslog_alerts), "${domain_path}:${rule.syslog_alert}")
              })[0]) : null
              syslog_severity = try(rule.syslog_severity, local.defaults.fmc.domains.policies.access_policies.syslog_severity, null)
              }
            ]
          }
        ] if !contains(try(keys(local.data_access_control_policy), []), access_control_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_access_control_policy" "access_control_policy" {
  for_each = local.data_access_control_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_access_control_policy" "access_control_policy" {
  for_each = local.resource_access_control_policy

  domain                              = each.value.domain
  name                                = each.value.name
  default_action                      = each.value.default_action
  prefilter_policy_id                 = each.value.prefilter_policy_id
  default_action_intrusion_policy_id  = each.value.default_action_intrusion_policy_id
  default_action_variable_set_id      = each.value.default_action_variable_set_id
  default_action_log_connection_begin = each.value.default_action_log_connection_begin
  default_action_log_connection_end   = each.value.default_action_log_connection_end
  default_action_send_events_to_fmc   = each.value.default_action_send_events_to_fmc
  default_action_send_syslog          = each.value.default_action_send_syslog
  default_action_snmp_alert_id        = each.value.default_action_snmp_alert_id
  default_action_syslog_alert_id      = each.value.default_action_syslog_alert_id
  default_action_syslog_severity      = each.value.default_action_syslog_severity
  description                         = each.value.description
  categories                          = each.value.categories
  rules                               = each.value.rules
}

##########################################################
###    FTD NAT Policy
##########################################################
locals {
  data_ftd_nat_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for ftd_nat_policy in try(domain.policies.ftd_nat_policies, {}) : {
          name   = ftd_nat_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_ftd_nat_policy = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_nat_policy in try(domain.policies.ftd_nat_policies, []) : {
          domain      = domain.name
          name        = ftd_nat_policy.name
          description = try(ftd_nat_policy.description, local.defaults.fmc.domains.policies.ftd_nat_policies.description, null)

          auto_nat_rules = [for auto_rule in try(ftd_nat_policy.auto_nat_rules, []) : {
            nat_type = auto_rule.nat_type
            destination_interface_id = try(auto_rule.destination_interface, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${auto_rule.destination_interface}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${auto_rule.destination_interface}")
            })[0]) : null
            fall_through = try(auto_rule.fall_through, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.fall_through, null)
            ipv6         = try(auto_rule.ipv6, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.ipv6, null)
            net_to_net   = try(auto_rule.net_to_net, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.net_to_net, null)
            no_proxy_arp = try(auto_rule.no_proxy_arp, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.no_proxy_arp, null)
            original_network_id = try(auto_rule.original_network, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${auto_rule.original_network}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${auto_rule.original_network}")
              })[0],
            ) : null
            original_port = try(auto_rule.original_port, null)
            route_lookup  = try(auto_rule.route_lookup, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.route_lookup, null)
            protocol      = try(auto_rule.protocol, null)
            source_interface_id = try(auto_rule.source_interface, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${auto_rule.source_interface}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${auto_rule.source_interface}")
            })[0]) : null
            translate_dns = try(auto_rule.translate_dns, local.defaults.fmc.domains.policies.ftd_nat_policies.auto_nat_rules.translate_dns, null)
            translated_network_id = try(auto_rule.translated_network, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${auto_rule.translated_network}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${auto_rule.translated_network}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_group_objects["${domain_path}:${auto_rule.translated_network}"].id
                if contains(keys(local.map_network_group_objects), "${domain_path}:${auto_rule.translated_network}")
              })[0],
            ) : null
            translated_network_is_destination_interface = try(auto_rule.translated_network_is_destination_interface, null)
            translated_port                             = try(auto_rule.translated_port, null)
          }]

          manual_nat_rules = [for manual_rule in try(ftd_nat_policy.manual_nat_rules, []) : {
            nat_type    = manual_rule.nat_type
            section     = upper(manual_rule.section)
            enabled     = try(manual_rule.enabled, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.enabled, null)
            description = try(manual_rule.description, null)
            destination_interface_id = try(manual_rule.destination_interface, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${manual_rule.destination_interface}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${manual_rule.destination_interface}")
            })[0]) : null
            fall_through                      = try(manual_rule.fall_through, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.fall_through, null)
            interface_in_original_destination = try(manual_rule.interface_in_original_destination, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.interface_in_original_destination, null)
            interface_in_translated_source    = try(manual_rule.interface_in_translated_source, null)
            ipv6                              = try(manual_rule.ipv6, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.ipv6, null)
            net_to_net                        = try(manual_rule.net_to_net, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.net_to_net, null)
            no_proxy_arp                      = try(manual_rule.no_proxy_arp, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.no_proxy_arp, null)
            original_destination_id = try(manual_rule.original_destination, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${manual_rule.original_destination}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${manual_rule.original_destination}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_group_objects["${domain_path}:${manual_rule.original_destination}"].id
                if contains(keys(local.map_network_group_objects), "${domain_path}:${manual_rule.original_destination}")
              })[0],
            ) : null
            original_destination_port_id = try(local.map_services[manual_rule.original_destination_port].id, local.map_port_groups[manual_rule.original_destination_port].id, null)
            original_source_id = try(manual_rule.original_source, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${manual_rule.original_source}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${manual_rule.original_source}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_group_objects["${domain_path}:${manual_rule.original_source}"].id
                if contains(keys(local.map_network_group_objects), "${domain_path}:${manual_rule.original_source}")
              })[0],
            ) : null
            original_source_port_id = try(manual_rule.translated_source_port, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_services["${domain_path}:${manual_rule.translated_source_port}"].id
                if contains(keys(local.map_services), "${domain_path}:${manual_rule.translated_source_port}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_port_groups["${domain_path}:${manual_rule.translated_source_port}"].id
                if contains(keys(local.map_port_groups), "${domain_path}:${manual_rule.translated_source_port}")
              })[0],
            ) : null
            route_lookup = try(manual_rule.route_lookup, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.route_lookup, null)
            source_interface_id = try(manual_rule.source_interface, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${manual_rule.source_interface}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${manual_rule.source_interface}")
            })[0]) : null
            translate_dns = try(manual_rule.translate_dns, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.translate_dns, null)
            translated_destination_id = try(manual_rule.translated_destination, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${manual_rule.translated_destination}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${manual_rule.translated_destination}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_group_objects["${domain_path}:${manual_rule.translated_destination}"].id
                if contains(keys(local.map_network_group_objects), "${domain_path}:${manual_rule.translated_destination}")
              })[0],
            ) : null
            translated_destination_port_id = try(manual_rule.translated_destination_port, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_services["${domain_path}:${manual_rule.translated_destination_port}"].id
                if contains(keys(local.map_services), "${domain_path}:${manual_rule.translated_destination_port}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_port_groups["${domain_path}:${manual_rule.translated_destination_port}"].id
                if contains(keys(local.map_port_groups), "${domain_path}:${manual_rule.translated_destination_port}")
              })[0],
            ) : null
            translated_source_id = try(manual_rule.translated_source, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${manual_rule.manual_rule.translated_source}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${manual_rule.manual_rule.translated_source}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_group_objects["${domain_path}:${manual_rule.manual_rule.translated_source}"].id
                if contains(keys(local.map_network_group_objects), "${domain_path}:${manual_rule.manual_rule.translated_source}")
              })[0],
            ) : null
            translated_source_port_id = try(manual_rule.translated_source_port, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_services["${domain_path}:${manual_rule.translated_source_port}"].id
                if contains(keys(local.map_services), "${domain_path}:${manual_rule.translated_source_port}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_port_groups["${domain_path}:${manual_rule.translated_source_port}"].id
                if contains(keys(local.map_port_groups), "${domain_path}:${manual_rule.translated_source_port}")
              })[0],
            ) : null
            unidirectional = try(manual_rule.unidirectional, local.defaults.fmc.domains.policies.ftd_nat_policies.manual_nat_rules.unidirectional, null)
          }]
        } if !contains(try(keys(local.data_ftd_nat_policy), []), ftd_nat_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_ftd_nat_policy" "ftd_nat_policy" {
  for_each = local.data_ftd_nat_policy

  name   = each.value.name
  domain = each.value.domain
}


resource "fmc_ftd_nat_policy" "ftd_nat_policy" {
  for_each = local.resource_ftd_nat_policy

  domain           = each.value.domain
  name             = each.value.name
  description      = each.value.description
  manual_nat_rules = each.value.manual_nat_rules
  auto_nat_rules   = each.value.auto_nat_rules
}

##########################################################
###    Intrusion Policy (IPS)
##########################################################
locals {
  data_intrusion_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for intrusion_policy in try(domain.policies.intrusion_policies, {}) : {
          name   = intrusion_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_intrusion_policy = {
    for item in flatten([
      for domain in local.domains : [
        for intrusion_policy in try(domain.policies.intrusion_policies, []) : {
          domain      = domain.name
          name        = intrusion_policy.name
          description = try(intrusion_policy.description, local.defaults.fmc.domains.policies.intrusion_policies.description, null)
          base_policy_id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => data.fmc_intrusion_policy.intrusion_policy["${domain_path}:${intrusion_policy.base_policy}"].id
            if try(data.fmc_intrusion_policy.intrusion_policy["${domain_path}:${intrusion_policy.base_policy}"].id, "") != ""
          })[0]
          inspection_mode = try(intrusion_policy.inspection_mode, local.defaults.fmc.domains.policies.intrusion_policies.inspection_mode, null)
        } if contains(try(keys(local.data_intrusion_policy), []), "Global:${intrusion_policy.base_policy}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_intrusion_policy_l2 = {
    for item in flatten([
      for domain in local.domains : [
        for intrusion_policy in try(domain.policies.intrusion_policies, []) : {
          domain      = domain.name
          name        = intrusion_policy.name
          description = try(intrusion_policy.description, local.defaults.fmc.domains.policies.intrusion_policies.description, null)
          base_policy_id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => fmc_intrusion_policy.intrusion_policy["${domain_path}:${intrusion_policy.base_policy}"].id
            if try(fmc_intrusion_policy.intrusion_policy["${domain_path}:${intrusion_policy.base_policy}"].id, "") != ""
          })[0]
          inspection_mode = try(intrusion_policy.inspection_mode, local.defaults.fmc.domains.policies.intrusion_policies.inspection_mode, null)
        } if contains(try(keys(local.resource_intrusion_policy), []), "${domain.name}:${intrusion_policy.base_policy}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_intrusion_policy" "intrusion_policy" {
  for_each = local.data_intrusion_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_intrusion_policy" "intrusion_policy" {
  for_each = local.resource_intrusion_policy

  domain          = each.value.domain
  name            = each.value.name
  base_policy_id  = each.value.base_policy_id
  description     = each.value.description
  inspection_mode = each.value.inspection_mode
}

resource "fmc_intrusion_policy" "intrusion_policy_l2" {
  for_each = local.resource_intrusion_policy_l2

  domain          = each.value.domain
  name            = each.value.name
  base_policy_id  = each.value.base_policy_id
  description     = each.value.description
  inspection_mode = each.value.inspection_mode
}
##########################################################
###    File Policy
##########################################################
locals {
  data_file_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for file_policy in try(domain.policies.file_policies, {}) : {
          name   = file_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_file_policy = {
    for item in flatten([
      for domain in local.domains : [
        for file_policy in try(domain.policies.file_policies, []) : {
          domain                       = domain.name
          name                         = file_policy.name
          block_encrypted_archives     = try(file_policy.block_encrypted_archives, local.defaults.fmc.domains.policies.file_policies.block_encrypted_archives, null)
          block_uninspectable_archives = try(file_policy.block_uninspectable_archives, local.defaults.fmc.domains.policies.file_policies.block_uninspectable_archives, null)
          clean_list                   = try(file_policy.clean_list, local.defaults.fmc.domains.policies.file_policies.clean_list, null)
          custom_detection_list        = try(file_policy.custom_detection_list, local.defaults.fmc.domains.policies.file_policies.custom_detection_list, null)
          description                  = try(file_policy.description, local.defaults.fmc.domains.policies.file_policies.description, null)
          first_time_file_analysis     = try(file_policy.first_time_file_analysis, local.defaults.fmc.domains.policies.file_policies.first_time_file_analysis, null)
          inspect_archives             = try(file_policy.inspect_archives, local.defaults.fmc.domains.policies.file_policies.inspect_archives, null)
          max_archive_depth            = try(file_policy.max_archive_depth, local.defaults.fmc.domains.policies.file_policies.max_archive_depth, null)
          threat_score                 = try(file_policy.threat_score, local.defaults.fmc.domains.policies.file_policies.threat_score, null)

          file_rules = [for file_rule in try(file_policy.file_rules, []) : {
            action                = file_rule.action
            application_protocol  = file_rule.application_protocol
            direction_of_transfer = file_rule.direction_of_transfer
            file_categories = [for file_category in try(file_rule.file_categories, []) : {
              name = file_category
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => data.fmc_file_categories.file_categories[domain_path].items[file_category].id
                if contains(keys(try(data.fmc_file_categories.file_categories[domain_path].items, {})), file_category)
              })[0],
            }]
            file_types = [for file_type in try(file_rule.file_types, []) : {
              name = file_type
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => data.fmc_file_types.file_types[domain_path].items[file_type].id
                if contains(keys(try(data.fmc_file_types.file_types[domain_path].items, {})), file_type)
              })[0],
            }]
            store_files = try(file_rule.store_files, local.defaults.fmc.domains.policies.file_policies.store_files, null)
          }]
        } #if !contains(try(keys(local.data_file_policy), []), file_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_file_policy" "file_policy" {
  for_each = local.data_file_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_file_policy" "file_policy" {
  for_each = local.resource_file_policy

  domain                       = each.value.domain
  name                         = each.value.name
  block_encrypted_archives     = each.value.block_encrypted_archives
  block_uninspectable_archives = each.value.block_uninspectable_archives
  clean_list                   = each.value.clean_list
  custom_detection_list        = each.value.custom_detection_list
  description                  = each.value.description
  first_time_file_analysis     = each.value.first_time_file_analysis
  inspect_archives             = each.value.inspect_archives
  max_archive_depth            = each.value.max_archive_depth
  threat_score                 = each.value.threat_score
  file_rules                   = each.value.file_rules
}

##########################################################
###    Network Analysis Policy
##########################################################
locals {
  data_network_analysis_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for network_analysis_policy in try(domain.policies.network_analysis_policies, {}) : {
          name   = network_analysis_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_network_analysis_policy = {
    for item in flatten([
      for domain in local.domains : [
        for network_analysis_policy in try(domain.policies.network_analysis_policies, []) : {
          domain = domain.name
          name   = network_analysis_policy.name
          base_policy_id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => data.fmc_network_analysis_policy.network_analysis_policy["${domain_path}:${network_analysis_policy.base_policy}"].id
            if try(data.fmc_network_analysis_policy.network_analysis_policy["${domain_path}:${network_analysis_policy.base_policy}"].id, "") != ""
          })[0]
          description     = try(network_analysis_policy.description, local.defaults.fmc.domains.policies.network_analysis_policies.description, null)
          inspection_mode = try(network_analysis_policy.inspection_mode, local.defaults.fmc.domains.policies.network_analysis_policies.inspection_mode, null)
        } #if !contains(try(keys(local.data_network_analysis_policy), []), network_analysis_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_network_analysis_policy" "network_analysis_policy" {
  for_each = local.data_network_analysis_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_network_analysis_policy" "network_analysis_policy" {
  for_each = local.resource_network_analysis_policy

  domain          = each.value.domain
  name            = each.value.name
  base_policy_id  = each.value.base_policy_id
  description     = each.value.description
  inspection_mode = each.value.inspection_mode
}

##########################################################
###    Prefilter Policy
##########################################################
locals {
  data_prefilter_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for prefilter_policy in try(domain.policies.prefilter_policies, {}) : {
          name   = prefilter_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_prefilter_policy = {
    for item in flatten([
      for domain in local.domains : [
        for prefilter_policy in try(domain.policies.prefilter_policies, []) : [
          {
            domain                              = domain.name
            name                                = prefilter_policy.name
            description                         = try(prefilter_policy.description, local.defaults.fmc.domains.policies.prefilter_policies.description, null)
            default_action                      = try(prefilter_policy.default_action, local.defaults.fmc.domains.policies.prefilter_policies.default_action)
            default_action_log_connection_begin = try(prefilter_policy.log_connection_begin, local.defaults.fmc.domains.policies.prefilter_policies.log_connection_begin, null)
            default_action_log_connection_end   = try(prefilter_policy.log_connection_end, local.defaults.fmc.domains.policies.prefilter_policies.log_connection_end, null)
            default_action_send_events_to_fmc   = try(prefilter_policy.send_events_to_fmc, local.defaults.fmc.domains.policies.prefilter_policies.send_events_to_fmc, null)
            default_action_snmp_alert_id = try(prefilter_policy.snmp_alert, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_snmp_alerts["${domain_path}:${prefilter_policy.snmp_alert}"].id
                if contains(keys(local.map_snmp_alerts), "${domain_path}:${prefilter_policy.snmp_alert}")
            })[0]) : null
            default_action_syslog_alert_id = try(prefilter_policy.syslog_alert, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_syslog_alerts["${domain_path}:${prefilter_policy.syslog_alert}"].id
                if contains(keys(local.map_syslog_alerts), "${domain_path}:${prefilter_policy.syslog_alert}")
            })[0]) : null

            rules = [for rule in try(prefilter_policy.rules, []) : {
              name          = rule.name
              action        = rule.action
              rule_type     = rule.rule_type
              enabled       = try(rule.enabled, local.defaults.fmc.domains.policies.prefilter_policies.rules.enabled, null)
              bidirectional = rule.rule_type == "TUNNEL" ? try(rule.bidirectional, local.defaults.fmc.domains.policies.prefilter_policies.rules.bidirectional) : null
              destination_interfaces = [for destination_interface in try(rule.destination_interfaces, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${destination_interface}"].id
                    if contains(keys(local.map_security_zones), "${domain_path}:${destination_interface}")
                })[0])
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${destination_interface}"].type
                    if contains(keys(local.map_security_zones), "${domain_path}:${destination_interface}")
                })[0])
              }]
              destination_network_literals = [for destination_network_literal in try(rule.destination_network_literals, []) : {
                value = destination_network_literal
                type  = can(regex("/", destination_network_literal)) ? "Network" : "Host"
              }]
              destination_network_objects = [for destination_network_object in try(rule.destination_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network_object}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network_object}"].type
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network_object}")
                  })[0],
                )
              }]
              destination_port_literals = [for destination_port_literal in try(rule.destination_port_literals, []) : {
                protocol = local.help_protocol_mapping[destination_port_literal.protocol]
                port     = try(destination_port_literal.port, null)
                #type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              destination_port_objects = [for destination_port_object in try(rule.destination_port_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${destination_port_object}"].id
                    if contains(keys(local.map_services), "${domain_path}:${destination_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${destination_port_object}"].id
                    if contains(keys(local.map_port_groups), "${domain_path}:${destination_port_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${destination_port_object}"].type
                    if contains(keys(local.map_services), "${domain_path}:${destination_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${destination_port_object}"].type
                    if contains(keys(local.map_port_groups), "${domain_path}:${destination_port_object}")
                  })[0],
                )
              }]

              encapsulation_ports  = rule.rule_type == "TUNNEL" ? try(rule.encapsulation_ports, local.defaults.fmc.domains.policies.prefilter_policies.rules.encapsulation_ports) : null
              log_connection_begin = try(rule.log_connection_begin, local.defaults.fmc.domains.policies.prefilter_policies.rules.log_connection_begin, null)
              log_connection_end   = try(rule.log_connection_end, local.defaults.fmc.domains.policies.prefilter_policies.rules.log_connection_end, null)
              send_events_to_fmc   = try(rule.send_events_to_fmc, local.defaults.fmc.domains.policies.prefilter_policies.rules.send_events_to_fmc, null)
              send_syslog          = try(rule.send_syslog, local.defaults.fmc.domains.policies.prefilter_policies.rules.send_syslog, null)
              snmp_alert_id = try(rule.snmp_alert, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_snmp_alerts["${domain_path}:${rule.snmp_alert}"].id
                  if contains(keys(local.map_snmp_alerts), "${domain_path}:${rule.snmp_alert}")
              })[0]) : null
              source_interfaces = [for source_interface in try(rule.source_interfaces, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${source_interface}"].id
                    if contains(keys(local.map_security_zones), "${domain_path}:${source_interface}")
                })[0])
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_security_zones["${domain_path}:${source_interface}"].type
                    if contains(keys(local.map_security_zones), "${domain_path}:${source_interface}")
                })[0])
              }]
              source_network_literals = [for source_network_literal in try(rule.source_network_literals, []) : {
                value = source_network_literal
                type  = can(regex("/", source_network_literal)) ? "Network" : "Host"
              }]
              source_network_objects = [for source_network_object in try(rule.source_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${source_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${source_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${source_network_object}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${source_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${source_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${source_network_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${source_network_object}"].type
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${source_network_object}")
                  })[0],
                )
              }]
              source_port_literals = [for source_port_literal in try(rule.source_port_literals, []) : {
                protocol = local.help_protocol_mapping[source_port_literal.protocol]
                port     = try(source_port_literal.port, null)
                #type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              source_port_objects = [for source_port_object in try(rule.source_port_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${source_port_object}"].id
                    if contains(keys(local.map_services), "${domain_path}:${source_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${source_port_object}"].id
                    if contains(keys(local.map_port_groups), "${domain_path}:${source_port_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_services["${domain_path}:${source_port_object}"].type
                    if contains(keys(local.map_services), "${domain_path}:${source_port_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_port_groups["${domain_path}:${source_port_object}"].type
                    if contains(keys(local.map_port_groups), "${domain_path}:${source_port_object}")
                  })[0],
                )
              }]
              syslog_alert_id = try(rule.syslog_alert, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_syslog_alerts["${domain_path}:${rule.syslog_alert}"].id
                  if contains(keys(local.map_syslog_alerts), "${domain_path}:${rule.syslog_alert}")
              })[0]) : null
              syslog_severity = try(rule.syslog_severity, local.defaults.fmc.domains.policies.prefilter_policies.syslog_severity, null)
              tunnel_zone_id = try(rule.tunnel_zone, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_tunnel_zones["${domain_path}:${rule.tunnel_zone}"].id
                  if contains(keys(local.map_tunnel_zones), "${domain_path}:${rule.tunnel_zone}")
              })[0]) : null
              time_range_id = try(rule.time_range, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_time_ranges["${domain_path}:${rule.time_range}"].id
                  if contains(keys(local.map_time_ranges), "${domain_path}:${rule.time_range}")
              })[0]) : null
              vlan_tag_literals = [for vlan_tag_literal in try(rule.vlan_tag_literals, []) : {
                start_tag = vlan_tag_literal.start_tag
                end_tag   = try(vlan_tag_literal.end_tag, vlan_tag_literal.start_tag)
              }]
              vlan_tag_objects = [for vlan_tag_object in try(rule.vlan_tag_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_vlan_tags["${domain_path}:${vlan_tag_object}"].id
                    if contains(keys(local.map_vlan_tags), "${domain_path}:${vlan_tag_object}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_vlan_tag_groups["${domain_path}:${vlan_tag_object}"].id
                    if contains(keys(local.map_vlan_tag_groups), "${domain_path}:${vlan_tag_object}")
                })[0])
              }]
            }]
        }] #if !contains(try(keys(local.data_tunnel_zones), []), prefilter_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_prefilter_policy" "prefilter_policy" {
  for_each = local.data_prefilter_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_prefilter_policy" "prefilter_policy" {
  for_each = local.resource_prefilter_policy

  domain                              = each.value.domain
  name                                = each.value.name
  description                         = each.value.description
  default_action                      = each.value.default_action
  default_action_log_connection_begin = each.value.default_action_log_connection_begin
  default_action_log_connection_end   = each.value.default_action_log_connection_end
  default_action_send_events_to_fmc   = each.value.default_action_send_events_to_fmc
  default_action_syslog_alert_id      = each.value.default_action_syslog_alert_id
  default_action_snmp_alert_id        = each.value.default_action_snmp_alert_id
  rules                               = each.value.rules
}

##########################################################
###    Health Policy
##########################################################
locals {
  data_health_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for health_policy in try(domain.policies.health_policies, {}) : {
          name   = health_policy.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_health_policy = {
    for item in flatten([
      for domain in local.domains : [
        for health_policy in try(domain.policies.health_policies, []) : {
          domain                          = domain.name
          name                            = health_policy.name
          policy_type                     = try(health_policy.policy_type, local.defaults.fmc.domains.policies.health_policies.policy_type)
          description                     = try(health_policy.description, local.defaults.fmc.domains.policies.health_policies.description, null)
          is_default_policy               = try(health_policy.is_default_policy, local.defaults.fmc.domains.policies.health_policies.is_default_policy, null)
          health_module_run_time_interval = try(health_policy.health_module_run_time_interval, local.defaults.fmc.domains.policies.health_policies.health_module_run_time_interval, null)
          metric_collection_interval      = try(health_policy.metric_collection_interval, local.defaults.fmc.domains.policies.health_policies.metric_collection_interval, null)
          health_modules = [for health_module in try(health_policy.health_modules, []) : {
            name               = health_module.name
            type               = health_module.type
            enabled            = try(health_module.enabled, local.defaults.fmc.domains.policies.health_policies.health_modules.enabled, null)
            alert_severity     = try(health_module.alert_severity, null)
            critical_threshold = try(health_module.critical_threshold, null)
            warning_threshold  = try(health_module.warning_threshold, null)
            alert_configs = [for alert_config in try(health_module.alert_configs, []) : {
              name    = alert_config.name
              enabled = try(alert_config.enabled, local.defaults.fmc.domains.policies.health_policies.health_modules.alert_configs.enabled, null)
              thresholds = [for threshold in try(alert_config.thresholds, []) : {
                type      = threshold.type
                threshold = threshold.threshold
              }]
            }]
            custom_thresholds = [for custom_threshold in try(health_module.custom_thresholds, []) : {
              type      = custom_threshold.type
              threshold = custom_threshold.threshold
            }]
          }]
        } #if !contains(try(keys(local.data_health_policy), []), health_policy.name)
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

}

data "fmc_health_policy" "health_policy" {
  for_each = local.data_health_policy

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_health_policy" "health_policy" {
  for_each = local.resource_health_policy

  domain                          = each.value.domain
  name                            = each.value.name
  policy_type                     = each.value.policy_type
  description                     = each.value.description
  health_module_run_time_interval = each.value.health_module_run_time_interval
  is_default_policy               = each.value.is_default_policy
  metric_collection_interval      = each.value.metric_collection_interval
  health_modules                  = each.value.health_modules
}

##########################################################
###    Create maps for combined set of _data and _resources network objects
##########################################################

######
### map_access_control_policies
######
locals {
  map_access_control_policies = merge(

    # Access Policy - individual mode outputs
    { for key, resource in fmc_access_control_policy.access_control_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # Access Policy - data source
    { for key, data in data.fmc_access_control_policy.access_control_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )
}

######
### map_ftd_nat_policies
######
locals {
  map_ftd_nat_policies = merge(

    # FTD NAT Policy - individual mode outputs
    { for key, resource in fmc_ftd_nat_policy.ftd_nat_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # FTD NAT Policy - data source
    { for key, data in data.fmc_ftd_nat_policy.ftd_nat_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )
}

######
### map_intrusion_policies
######
locals {
  map_intrusion_policies = merge(

    # Intrusion Policy - individual mode outputs
    { for key, resource in fmc_intrusion_policy.intrusion_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Intrusion Policy L2 - individual mode outputs
    { for key, resource in fmc_intrusion_policy.intrusion_policy_l2 : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Intrusion Policy - data source
    { for key, data in data.fmc_intrusion_policy.intrusion_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_file_policies
######
locals {
  map_file_policies = merge(

    # File Policy - individual mode outputs
    { for key, resource in fmc_file_policy.file_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # File Policy - data source
    { for key, data in data.fmc_file_policy.file_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_network_analysis_policies
######

locals {
  map_network_analysis_policies = merge(

    # Network Analysis Policy - individual mode outputs
    { for key, resource in fmc_network_analysis_policy.network_analysis_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Network Analysis Policy - data source
    { for key, data in data.fmc_network_analysis_policy.network_analysis_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_prefilter_policies
######
locals {
  map_prefilter_policies = merge(

    # Prefilter Policy - individual mode outputs
    { for key, resource in fmc_prefilter_policy.prefilter_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Prefilter Policy - data source
    { for key, data in data.fmc_prefilter_policy.prefilter_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_health_policies
######
locals {
  map_health_policies = merge(

    # Health Policy - individual mode outputs
    { for key, resource in fmc_health_policy.health_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # Health Policy - data source
    { for key, data in data.fmc_health_policy.health_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )
}

######
### map_snmp_alerts
######
locals {
  map_snmp_alerts = merge(

    # SNMP Alerts - data sources
    merge([
      for domain, snmp_alerts in data.fmc_snmp_alerts.snmp_alerts : {
        for snmp_name, snmp_values in snmp_alerts.items : "${domain}:${snmp_name}" => { id = snmp_values.id, type = snmp_values.type }
      }
    ]...),
  )
}

######
### map_snmp_alerts
######
locals {
  map_syslog_alerts = merge(

    # Syslog Alerts - data sources
    merge([
      for domain, syslog_alerts in data.fmc_syslog_alerts.syslog_alerts : {
        for syslog_name, syslog_values in syslog_alerts.items : "${domain}:${syslog_name}" => { id = syslog_values.id, type = syslog_values.type }
      }
    ]...),
  )

}
