##########################################################
###    Content of the file:
##########################################################
#
###
#  Resources
####
# resource "fmc_access_control_policy" "module" {
# resource "fmc_ftd_nat_policy" "module" {
# resource "fmc_intrusion_policy" "module" {
# resource "fmc_file_policy" "module" {
# resource "fmc_network_analysis_policy" "module" {
# resource "fmc_prefilter_policy" "module" {
#
###
#  Local variables
###
# local.resource_access_control_policy
# local.resource_ftd_nat_policy
# local.resource_intrusion_policy
# local.resource_file_policy
# local.resource_network_analysis_policy
# local.resource_prefilter_policy
#
# local.map_access_control_policies
# local.map_ftd_nat_policies
# local.map_intrusion_policies
# local.map_file_policies
# local.map_prefilter_policies
# local.map_snmp_alerts
# local.map_syslog_alerts
#
###
##########################################################
###    Protocol Mapping Help value
##########################################################
locals {
  help_protocol_mapping = {
    "TCP"  = "6",
    "UDP"  = "17",
    "ICMP" = "1"
  }

}
##########################################################
###    Access Control Policy
##########################################################

locals {

  resource_access_control_policy = {
    for item in flatten([
      for domain in local.domains : [
        for access_policy in try(domain.policies.access_policies, []) : [
          {
            name                = access_policy.name
            default_action      = try(access_policy.default_action, local.defaults.fmc.domains.policies.access_policies.default_action)
            prefilter_policy_id = try(local.map_prefilter_policies[access_policy.prefilter_policy].id, null)
            categories = [for category in try(access_policy.categories, []) : {
              name    = category.name
              section = try(category.section, null)
            }]

            default_action_intrusion_policy_id = try(local.map_intrusion_policies[access_policy.base_intrusion_policy].id, local.map_intrusion_policies[local.defaults.fmc.domains.policies.access_policies.base_intrusion_policy].id, null)
            default_action_log_begin           = try(access_policy.log_begin, local.defaults.fmc.domains.policies.access_policies.log_begin, null)
            default_action_log_end             = try(access_policy.log_end, local.defaults.fmc.domains.policies.access_policies.log_end, null)
            default_action_send_events_to_fmc  = try(access_policy.send_events_to_fmc, local.defaults.fmc.domains.policies.access_policies.send_events_to_fmc, null)
            default_action_send_syslog         = try(access_policy.enable_syslog, local.defaults.fmc.domains.policies.access_policies.enable_syslog, null)

            default_action_snmp_config_id   = try(local.map_snmp_alerts[access_policy.snmp_alert].id, null)
            default_action_syslog_config_id = try(local.map_syslog_alerts[access_policy.syslog_alert].id, null)
            default_action_syslog_severity  = try(access_policy.syslog_severity, local.defaults.fmc.domains.policies.access_policies.syslog_severity, null)

            description = try(access_policy.description, null)
            domain_name = domain.name

            rules = [for rule in try(access_policy.access_rules, []) : {
              name          = rule.name
              action        = rule.action
              category_name = try(rule.category, null)
              description   = try(rule.description, null)

              destination_dynamic_objects = [for destination_dynamic_object in try(rule.destination_dynamic_objects, []) : {
                id   = local.map_dynamic_objects[destination_dynamic_object].id
                type = local.map_dynamic_objects[destination_dynamic_object].type
              }]
              destination_network_literals = [for destination_network_literal in try(rule.destination_network_literals, []) : {
                value = destination_network_literal
                type  = can(regex("/", destination_network_literal)) ? "Network" : "Host"
              }]
              destination_network_objects = [for destination_network_object in try(rule.destination_network_objects, []) : {
                id   = try(local.map_network_objects[destination_network_object].id, local.map_network_group_objects[destination_network_object].id)
                type = try(local.map_network_objects[destination_network_object].type, local.map_network_group_objects[destination_network_object].type)
              }]
              destination_port_literals = [for destination_port_literal in try(rule.destination_port_literals, []) : {
                protocol  = local.help_protocol_mapping[destination_port_literal.protocol]
                port      = try(destination_port_literal.port, null)
                icmp_type = try(destination_port_literal.icmp_type, null)
                icmp_code = try(destination_port_literal.icmp_code, null)
                type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              destination_port_objects = [for destination_port_object in try(rule.destination_port_objects, []) : {
                id   = try(local.map_services[destination_port_object].id, local.map_service_groups[destination_port_object].id)
                type = try(local.map_services[destination_port_object].type, local.map_service_groups[destination_port_object].type)
              }]
              destination_sgt_objects = [for destination_sgt in try(rule.destination_sgts, []) : {
                name = local.map_sgts[destination_sgt].name
                id   = local.map_sgts[destination_sgt].id
                type = local.map_sgts[destination_sgt].type
              }]
              destination_zones = [for destination_zone in try(rule.destination_zones, []) : {
                id = local.map_security_zones[destination_zone].id
              }]

              enabled = try(rule.enabled, local.defaults.fmc.domains.policies.access_policies.access_rules.enabled, null)
              endpoint_device_types = [for endpoint_device_type in try(rule.endpoint_device_types, []) : {
                id   = local.map_endpoint_device_types[endpoint_device_type].id
                type = local.map_endpoint_device_types[endpoint_device_type].type
                name = local.map_endpoint_device_types[endpoint_device_type].name
              }]

              applications = [for application in try(rule.applications, []) : {
                id = try(data.fmc_applications.module[domain.name].items[application].id, null)
              }]

              file_policy_id      = try(local.map_file_policies[rule.file_policy].id, null)
              intrusion_policy_id = try(local.map_intrusion_policies[rule.intrusion_policy].id, local.defaults.fmc.domains.policies.access_policies.access_rules.intrusion_policy, null)
              log_begin           = try(rule.log_connection_begin, local.defaults.fmc.domains.policies.access_policies.access_rules.log_connection_begin, null)
              log_end             = try(rule.log_connection_end, local.defaults.fmc.domains.policies.access_policies.access_rules.log_connection_end, null)
              log_files           = try(rule.log_files, local.defaults.fmc.domains.policies.access_policies.access_rules.log_files, null)
              section             = try(rule.section, local.defaults.fmc.domains.policies.access_policies.access_rules.section, null)
              send_events_to_fmc  = try(rule.send_events_to_fmc, local.defaults.fmc.domains.policies.access_policies.access_rules.send_events_to_fmc, null)
              send_syslog         = try(rule.enable_syslog, local.defaults.fmc.domains.policies.access_policies.access_rules.enable_syslog, null)
              snmp_config_id      = try(local.map_snmp_alerts[rule.snmp_alert].id, null)
              source_dynamic_objects = [for source_dynamic_object in try(rule.source_dynamic_objects, []) : {
                id   = local.map_dynamic_objects[source_dynamic_object].id
                type = local.map_dynamic_objects[source_dynamic_object].type
              }]
              source_network_literals = [for source_network_literal in try(rule.source_network_literals, []) : {
                value = source_network_literal
                type  = can(regex("/", source_network_literal)) ? "Network" : "Host"
              }]
              source_network_objects = [for source_network_object in try(rule.source_network_objects, []) : {
                id   = try(local.map_network_objects[source_network_object].id, local.map_network_group_objects[source_network_object].id, null)
                type = try(local.map_network_objects[source_network_object].type, local.map_network_group_objects[source_network_object].type, null)
              }]
              source_port_literals = [for source_port_literal in try(rule.source_port_literals, []) : {
                protocol  = local.help_protocol_mapping[source_port_literal.protocol]
                port      = try(source_port_literal.port, null)
                icmp_type = try(source_port_literal.icmp_type, null)
                icmp_code = try(source_port_literal.icmp_code, null)
                type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              source_port_objects = [for source_port_object in try(rule.source_port_objects, []) : {
                id   = try(local.map_services[source_port_object].id, local.map_service_groups[source_port_object].id)
                type = try(local.map_services[source_port_object].type, local.map_service_groups[source_port_object].type)

              }]
              source_zones = [for source_zone in try(rule.source_zones, []) : {
                id = local.map_security_zones[source_zone].id
              }]
              source_sgt_objects = [for source_sgt in try(rule.source_sgts, []) : {
                name = local.map_sgts[source_sgt].name
                id   = local.map_sgts[source_sgt].id
                type = local.map_sgts[source_sgt].type
              }]
              syslog_config_id = try(local.map_syslog_alerts[rule.syslog_alert].id, null)
              syslog_severity  = try(rule.syslog_severity, local.defaults.fmc.domains.policies.access_policies.syslog_severity, null)
              url_categories = [for url_category in try(rule.url_categories, []) : {
                id         = try(local.map_url_categories[url_category.category].id)
                reputation = try(url_category.reputation, null)
              }]
              url_objects = [for url_object in try(rule.url_objects, []) : {
                id = try(local.map_urls[url_object].id, local.map_url_groups[url_object].id)
              }]
              variable_set_id = try(local.map_variable_sets[rule.variable_set].id, null)
              time_range_id   = try(local.map_time_ranges[rule.time_range].id, null)
              vlan_tag_literals = [for vlan_tag_literal in try(rule.vlan_tag_literals, []) : {
                start_tag = vlan_tag_literal.start_tag
                end_tag   = try(vlan_tag_literal.end_tag, vlan_tag_literal.start_tag)
              }]
              vlan_tag_objects = [for vlan_tag_object in try(rule.vlan_tag_objects, []) : {
                id = try(local.map_vlan_tags[vlan_tag_object].id, local.map_vlan_tag_groups[vlan_tag_object].id)
              }]
              }
            ]
          }
        ] if !contains(try(keys(local.data_access_control_policy), []), access_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_access_control_policy), []), item.name)
  }

}

resource "fmc_access_control_policy" "module" {
  for_each = local.resource_access_control_policy

  # Mandatory
  name                = each.key
  default_action      = each.value.default_action
  prefilter_policy_id = each.value.prefilter_policy_id
  # Optional
  default_action_intrusion_policy_id = each.value.default_action_intrusion_policy_id
  default_action_log_begin           = each.value.default_action_log_begin
  default_action_log_end             = each.value.default_action_log_end
  default_action_send_events_to_fmc  = each.value.default_action_send_events_to_fmc
  default_action_send_syslog         = each.value.default_action_send_syslog
  default_action_snmp_config_id      = each.value.default_action_snmp_config_id
  default_action_syslog_config_id    = each.value.default_action_syslog_config_id
  default_action_syslog_severity     = each.value.default_action_syslog_severity
  description                        = each.value.description

  categories = each.value.categories
  rules      = each.value.rules

  domain = each.value.domain_name

  depends_on = [
    data.fmc_security_zones.module,
    fmc_security_zones.module,
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    data.fmc_ranges.module,
    fmc_ranges.module,
    fmc_network_groups.module,
    data.fmc_dynamic_objects.module,
    fmc_dynamic_objects.module,
    data.fmc_ports.module,
    fmc_ports.module,
    data.fmc_intrusion_policy.module,
    fmc_intrusion_policy.module,
    data.fmc_access_control_policy.module,
    fmc_file_policy.module,
    data.fmc_file_policy.module,
    fmc_prefilter_policy.module,
    data.fmc_prefilter_policy.module,
  ]

}

##########################################################
###    FTD NAT Policy
##########################################################
locals {
  resource_ftd_nat_policy = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_nat_policy in try(domain.policies.ftd_nat_policies, []) : [
          {
            name        = ftd_nat_policy.name
            description = try(ftd_nat_policy.description, null)
            domain_name = domain.name

            auto_nat_rules = [for auto_rule in try(ftd_nat_policy.ftd_auto_nat_rules, []) : {
              # Mandatory
              nat_type = auto_rule.nat_type
              # Optional
              destination_interface_id                    = try(local.map_security_zones[auto_rule.destination_interface].id, null)
              fall_through                                = try(auto_rule.fall_through, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.fall_through, null)
              ipv6                                        = try(auto_rule.ipv6, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.ipv6, null)
              net_to_net                                  = try(auto_rule.net_to_net, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.net_to_net, null)
              no_proxy_arp                                = try(auto_rule.no_proxy_arp, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.no_proxy_arp, null)
              original_network_id                         = try(local.map_network_objects[auto_rule.original_network].id, local.map_network_group_objects[auto_rule.original_network].id, null)
              original_port                               = try(auto_rule.original_port, null)
              route_lookup                                = try(auto_rule.perform_route_lookup, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
              protocol                                    = try(auto_rule.protocol, null)
              source_interface_id                         = try(local.map_security_zones[auto_rule.source_interface].id, null)
              translate_dns                               = try(auto_rule.translate_dns, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_auto_nat_rules.translate_dns, null)
              translated_network_id                       = try(local.map_network_objects[auto_rule.translated_network].id, local.map_network_group_objects[auto_rule.translated_network].id, null)
              translated_network_is_destination_interface = try(auto_rule.translated_network_is_destination_interface, null)
              translated_port                             = try(auto_rule.translated_port, null)
            }]

            manual_nat_rules = [for manual_rule in try(ftd_nat_policy.ftd_manual_nat_rules, []) : {
              # Mandatory
              nat_type = manual_rule.nat_type
              section  = upper(manual_rule.section)
              # Optional
              description                       = try(manual_rule.description, null)
              destination_interface_id          = try(local.map_security_zones[manual_rule.destination_interface].id, null)
              enabled                           = try(manual_rule.enabled, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.enabled, null)
              fall_through                      = try(manual_rule.fall_through, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.fall_through, null)
              interface_in_original_destination = try(manual_rule.interface_in_original_destination, null)
              interface_in_translated_source    = try(manual_rule.interface_in_translated_source, null)
              ipv6                              = try(manual_rule.ipv6, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.ipv6, null)
              net_to_net                        = try(manual_rule.net_to_net, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.net_to_net, null)
              no_proxy_arp                      = try(manual_rule.no_proxy_arp, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.no_proxy_arp, null)
              original_destination_id           = try(local.map_network_objects[manual_rule.original_destination].id, local.map_network_group_objects[manual_rule.original_destination].id, null)
              original_destination_port_id      = try(local.map_services[manual_rule.original_destination_port].id, local.map_service_groups[manual_rule.original_destination_port].id, null)
              original_source_id                = try(local.map_network_objects[manual_rule.original_source].id, local.map_network_group_objects[manual_rule.original_source].id, null)
              original_source_port_id           = try(local.map_services[manual_rule.original_source_port].id, local.map_service_groups[manual_rule.original_source_port].id, null)
              route_lookup                      = try(manual_rule.perform_route_lookup, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.perform_route_lookup, null)
              source_interface_id               = try(local.map_security_zones[manual_rule.source_interface].id, null)
              translate_dns                     = try(manual_rule.translate_dns, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.translate_dns, null)
              translated_destination_id         = try(local.map_network_objects[manual_rule.translated_destination].id, local.map_network_group_objects[manual_rule.translated_destination].id, null)
              translated_destination_port_id    = try(local.map_services[manual_rule.translated_destination_port].id, local.map_service_groups[manual_rule.translated_destination_port].id, null)
              translated_source_id              = try(local.map_network_objects[manual_rule.translated_source].id, local.map_network_group_objects[manual_rule.translated_source].id, null)
              translated_source_port_id         = try(local.map_services[manual_rule.translated_source_port].id, local.map_service_groups[manual_rule.translated_source_port].id, null)
              unidirectional                    = try(manual_rule.unidirectional, local.defaults.fmc.domains.policies.ftd_nat_policies.ftd_manual_nat_rules.unidirectional, null)
            }]
        }] if !contains(try(keys(local.data_ftd_nat_policy), []), ftd_nat_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_ftd_nat_policy), []), item.name)
  }

}

resource "fmc_ftd_nat_policy" "module" {
  for_each = local.resource_ftd_nat_policy

  # Mandatory
  name = each.key

  # Optional
  description      = each.value.description
  manual_nat_rules = each.value.manual_nat_rules
  auto_nat_rules   = each.value.auto_nat_rules

  domain = each.value.domain_name

  depends_on = [
    data.fmc_security_zones.module,
    fmc_security_zones.module,
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    data.fmc_ranges.module,
    fmc_ranges.module,
    fmc_network_groups.module,
    data.fmc_ports.module,
    fmc_ports.module,
    data.fmc_ftd_nat_policy.module,
  ]
}

##########################################################
###    Intrusion Policy (IPS)
##########################################################
locals {
  resource_intrusion_policy = {
    for item in flatten([
      for domain in local.domains : [
        for intrusion_policy in try(domain.policies.intrusion_policies, []) : [
          {
            name            = intrusion_policy.name
            domain_name     = domain.name
            description     = try(intrusion_policy.description, null)
            base_policy_id  = try(data.fmc_intrusion_policy.module[intrusion_policy.base_policy].id, null)
            inspection_mode = try(intrusion_policy.inspection_mode, null)
        }] if !contains(try(keys(local.data_intrusion_policy), []), intrusion_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_intrusion_policy), []), item.name)
  }

}

resource "fmc_intrusion_policy" "module" {
  for_each = local.resource_intrusion_policy

  # Mandatory
  name           = each.key
  base_policy_id = each.value.base_policy_id

  # Optional
  description     = each.value.description
  inspection_mode = each.value.inspection_mode

  domain = each.value.domain_name

  depends_on = [
    data.fmc_intrusion_policy.module,
  ]
}

##########################################################
###    File Policy
##########################################################
locals {
  resource_file_policy = {
    for item in flatten([
      for domain in local.domains : [
        for file_policy in try(domain.policies.file_policies, []) : [
          {
            # Mandatory
            name = file_policy.name
            # Optional
            block_encrypted_archives     = try(file_policy.block_encrypted_archives, local.defaults.fmc.domains.policies.file_policies.block_encrypted_archives, null)
            block_uninspectable_archives = try(file_policy.block_uninspectable_archives, local.defaults.fmc.domains.policies.file_policies.block_uninspectable_archives, null)
            clean_list                   = try(file_policy.clean_list, local.defaults.fmc.domains.policies.file_policies.clean_list, null)
            custom_detection_list        = try(file_policy.custom_detection_list, local.defaults.fmc.domains.policies.file_policies.custom_detection_list, null)
            description                  = try(file_policy.description, null)
            first_time_file_analysis     = try(file_policy.first_time_file_analysis, local.defaults.fmc.domains.policies.file_policies.first_time_file_analysis, null)
            inspect_archives             = try(file_policy.inspect_archives, local.defaults.fmc.domains.policies.file_policies.inspect_archives, null)
            max_archive_depth            = try(file_policy.max_archive_depth, local.defaults.fmc.domains.policies.file_policies.max_archive_depth, null)
            threat_score                 = try(file_policy.threat_score, local.defaults.fmc.domains.policies.file_policies.threat_score, null)

            domain_name = domain.name

            file_rules = [for file_rule in try(file_policy.file_rules, []) : {
              # Mandatory
              action                = file_rule.action
              application_protocol  = file_rule.application_protocol
              direction_of_transfer = file_rule.direction_of_transfer
              # Optional
              file_categories = [for file_category in try(file_rule.file_categories, []) : {
                name = file_category
                id   = try(data.fmc_file_categories.module[domain.name].items[file_category].id, null)
              }]
              file_types = [for file_type in try(file_rule.file_types, []) : {
                name = file_type
                id   = try(data.fmc_file_types.module[domain.name].items[file_type].id, null)
              }]
              store_files = try(file_rule.store_files, null)
            }]

        }] if !contains(try(keys(local.data_file_policy), []), file_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_file_policy), []), item.name)
  }

}

resource "fmc_file_policy" "module" {
  for_each = local.resource_file_policy

  # Mandatory
  name = each.key

  # Optional
  block_encrypted_archives     = each.value.block_encrypted_archives
  block_uninspectable_archives = each.value.block_uninspectable_archives
  clean_list                   = each.value.clean_list
  custom_detection_list        = each.value.custom_detection_list
  description                  = each.value.description
  first_time_file_analysis     = each.value.first_time_file_analysis
  inspect_archives             = each.value.inspect_archives
  max_archive_depth            = each.value.max_archive_depth
  threat_score                 = each.value.threat_score

  file_rules = each.value.file_rules

  domain = each.value.domain_name

  depends_on = [
    data.fmc_file_types.module,
    data.fmc_file_categories.module,
    data.fmc_file_policy.module,
  ]
}

##########################################################
###    Network Analysis Policy
##########################################################
locals {
  resource_network_analysis_policy = {
    for item in flatten([
      for domain in local.domains : [
        for network_analysis_policy in try(domain.policies.network_analysis_policies, []) : [
          {
            # Mandatory
            name           = network_analysis_policy.name
            base_policy_id = data.fmc_network_analysis_policy.module[network_analysis_policy.base_policy].id
            # Optional
            description     = try(network_analysis_policy.description, null)
            inspection_mode = try(network_analysis_policy.inspection_mode, null)

            domain_name = domain.name

        }] if !contains(try(keys(local.data_network_analysis_policy), []), network_analysis_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

resource "fmc_network_analysis_policy" "module" {
  for_each = local.resource_network_analysis_policy

  # Mandatory
  name           = each.key
  base_policy_id = each.value.base_policy_id

  # Optional
  description     = each.value.description
  inspection_mode = each.value.inspection_mode

  domain = each.value.domain_name

}

##########################################################
###    Prefilter Policy
##########################################################
locals {
  resource_prefilter_policy = {
    for item in flatten([
      for domain in local.domains : [
        for prefilter_policy in try(domain.policies.prefilter_policies, []) : [
          {
            name           = prefilter_policy.name
            default_action = try(prefilter_policy.default_action, local.defaults.fmc.domains.policies.prefilter_policies.default_action)

            default_action_log_begin          = try(prefilter_policy.log_begin, local.defaults.fmc.domains.policies.prefilter_policies.log_begin, null)
            default_action_log_end            = try(prefilter_policy.log_end, local.defaults.fmc.domains.policies.prefilter_policies.log_end, null)
            default_action_send_events_to_fmc = try(prefilter_policy.send_events_to_fmc, local.defaults.fmc.domains.policies.prefilter_policies.send_events_to_fmc, null)
            #default_action_send_syslog         = try(prefilter_policy.enable_syslog, local.defaults.fmc.domains.policies.prefilter_policies.enable_syslog, null)

            default_action_snmp_config_id   = try(local.map_snmp_alerts[prefilter_policy.snmp_alert].id, null)
            default_action_syslog_config_id = try(local.map_syslog_alerts[prefilter_policy.syslog_alert].id, null)
            default_action_syslog_severity  = try(prefilter_policy.syslog_severity, local.defaults.fmc.domains.policies.prefilter_policies.syslog_severity, null)

            description = try(prefilter_policy.description, null)

            rules = [for rule in try(prefilter_policy.rules, []) : {
              name      = rule.name
              action    = rule.action
              rule_type = rule.rule_type

              #description   = try(rule.description, null)

              bidirectional = try(rule.bidirectional, null)
              destination_interfaces = [for destination_interface in try(rule.destination_interfaces, []) : {
                id = local.map_security_zones[destination_interface].id
              }]
              destination_network_literals = [for destination_network_literal in try(rule.destination_network_literals, []) : {
                value = destination_network_literal
                type  = can(regex("/", destination_network_literal)) ? "Network" : "Host"
              }]
              destination_network_objects = [for destination_network_object in try(rule.destination_network_objects, []) : {
                id   = try(local.map_network_objects[destination_network_object].id, local.map_network_group_objects[destination_network_object].id)
                type = try(local.map_network_objects[destination_network_object].type, local.map_network_group_objects[destination_network_object].type)
              }]
              destination_port_literals = [for destination_port_literal in try(rule.destination_port_literals, []) : {
                protocol = local.help_protocol_mapping[destination_port_literal.protocol]
                port     = try(destination_port_literal.port, null)
                #type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              destination_port_objects = [for destination_port_object in try(rule.destination_port_objects, []) : {
                id   = try(local.map_services[destination_port_object].id, local.map_service_groups[destination_port_object].id)
                type = try(local.map_services[destination_port_object].type, local.map_service_groups[destination_port_object].type)

              }]

              enabled             = try(rule.enabled, local.defaults.fmc.domains.policies.prefilter_policies.rules.enabled, null)
              encapsulation_ports = try(rule.encapsulation_ports, local.defaults.fmc.domains.policies.prefilter_policies.rules.encapsulation_ports, null)

              log_begin          = try(rule.log_connection_begin, local.defaults.fmc.domains.policies.prefilter_policies.rules.log_connection_begin, null)
              log_end            = try(rule.log_connection_end, local.defaults.fmc.domains.policies.prefilter_policies.rules.log_connection_end, null)
              log_files          = try(rule.log_files, local.defaults.fmc.domains.policies.prefilter_policies.rules.log_files, null)
              section            = try(rule.section, local.defaults.fmc.domains.policies.prefilter_policies.rules.section, null)
              send_events_to_fmc = try(rule.send_events_to_fmc, local.defaults.fmc.domains.policies.prefilter_policies.rules.send_events_to_fmc, null)
              send_syslog        = try(rule.enable_syslog, local.defaults.fmc.domains.policies.prefilter_policies.rules.enable_syslog, null)
              snmp_config_id     = try(local.map_snmp_alerts[rule.snmp_alert].id, null)
              source_interfaces = [for source_interface in try(rule.source_interfaces, []) : {
                id = local.map_security_zones[source_interface].id
              }]
              source_network_literals = [for source_network_literal in try(rule.source_network_literals, []) : {
                value = source_network_literal
                type  = can(regex("/", source_network_literal)) ? "Network" : "Host"
              }]
              source_network_objects = [for source_network_object in try(rule.source_network_objects, []) : {
                id   = try(local.map_network_objects[source_network_object].id, local.map_network_group_objects[source_network_object].id, null)
                type = try(local.map_network_objects[source_network_object].type, local.map_network_group_objects[source_network_object].type, null)
              }]
              source_port_literals = [for source_port_literal in try(rule.source_port_literals, []) : {
                protocol = local.help_protocol_mapping[source_port_literal.protocol]
                port     = try(source_port_literal.port, null)
                #type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
              }]
              source_port_objects = [for source_port_object in try(rule.source_port_objects, []) : {
                id   = try(local.map_services[source_port_object].id, local.map_service_groups[source_port_object].id)
                type = try(local.map_services[source_port_object].type, local.map_service_groups[source_port_object].type)
              }]
              syslog_config_id = try(local.map_syslog_alerts[rule.syslog_alert].id, null)
              syslog_severity  = try(rule.syslog_severity, local.defaults.fmc.domains.policies.prefilter_policies.syslog_severity, null)
              tunnel_zone_id   = try(local.map_tunnel_zones[rule.tunnel_zone].id, null)
              time_range_id    = try(local.map_time_ranges[rule.time_range].id, null)
              vlan_tag_literals = [for vlan_tag_literal in try(rule.vlan_tag_literals, []) : {
                start_tag = vlan_tag_literal.start_tag
                end_tag   = try(vlan_tag_literal.end_tag, vlan_tag_literal.start_tag)
              }]
              vlan_tag_objects = [for vlan_tag_object in try(rule.vlan_tag_objects, []) : {
                id = try(local.map_vlan_tags[vlan_tag_object].id, local.map_vlan_tag_groups[vlan_tag_object].id)
              }]
            }]
            domain_name = domain.name
        }] if !contains(try(keys(local.data_tunnel_zones), []), prefilter_policy.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_file_policy), []), item.name)
  }

}

resource "fmc_prefilter_policy" "module" {
  for_each                          = local.resource_prefilter_policy
  name                              = each.key
  description                       = each.value.description
  default_action                    = each.value.default_action
  default_action_log_begin          = each.value.default_action_log_begin
  default_action_log_end            = each.value.default_action_log_end
  default_action_send_events_to_fmc = each.value.default_action_send_events_to_fmc
  default_action_syslog_config_id   = each.value.default_action_syslog_config_id
  default_action_snmp_config_id     = each.value.default_action_snmp_config_id

  rules = each.value.rules

  domain = each.value.domain_name

  depends_on = [
    data.fmc_security_zones.module,
    fmc_security_zones.module,
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    data.fmc_ranges.module,
    fmc_ranges.module,
    fmc_network_groups.module,
    data.fmc_dynamic_objects.module,
    fmc_dynamic_objects.module,
    data.fmc_ports.module,
    fmc_ports.module,
    data.fmc_intrusion_policy.module,
    fmc_intrusion_policy.module,
    data.fmc_access_control_policy.module,
  ]
}
##########################################################
###    Create maps for combined set of _data and _resources network objects
##########################################################

######
### map_access_control_policies
######
locals {
  map_access_control_policies = merge({
    for item in flatten([
      for access_control_policy_key, access_control_policy_value in local.resource_access_control_policy : {
        name        = access_control_policy_key
        id          = try(fmc_access_control_policy.module[access_control_policy_key].id, null)
        type        = try(fmc_access_control_policy.module[access_control_policy_key].type, null)
        domain_name = access_control_policy_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for access_control_policy_key, access_control_policy_value in local.data_access_control_policy : {
          name        = access_control_policy_key
          id          = try(data.fmc_access_control_policy.module[access_control_policy_key].id, null)
          type        = try(data.fmc_access_control_policy.module[access_control_policy_key].type, null)
          domain_name = access_control_policy_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}

######
### map_ftd_nat_policies
######
locals {
  map_ftd_nat_policies = merge({
    for item in flatten([
      for ftd_nat_policy_key, ftd_nat_policy_value in local.resource_ftd_nat_policy : {
        name        = ftd_nat_policy_key
        id          = try(fmc_ftd_nat_policy.module[ftd_nat_policy_key].id, null)
        type        = try(fmc_ftd_nat_policy.module[ftd_nat_policy_key].type, null)
        domain_name = ftd_nat_policy_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for ftd_nat_policy_key, ftd_nat_policy_value in local.data_ftd_nat_policy : {
          name        = ftd_nat_policy_key
          id          = try(data.fmc_ftd_nat_policy.module[ftd_nat_policy_key].id, null)
          type        = try(data.fmc_ftd_nat_policy.module[ftd_nat_policy_key].type, null)
          domain_name = ftd_nat_policy_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}

######
### map_intrusion_policies
######
locals {
  map_intrusion_policies = merge({
    for item in flatten([
      for intrusion_policy_key, intrusion_policy_value in local.resource_intrusion_policy : {
        name        = intrusion_policy_key
        id          = try(fmc_intrusion_policy.module[intrusion_policy_key].id, null)
        type        = try(fmc_intrusion_policy.module[intrusion_policy_key].type, null)
        domain_name = intrusion_policy_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for intrusion_policy_key, intrusion_policy_value in local.data_intrusion_policy : {
          name        = intrusion_policy_key
          id          = try(data.fmc_intrusion_policy.module[intrusion_policy_key].id, null)
          type        = try(data.fmc_intrusion_policy.module[intrusion_policy_key].type, null)
          domain_name = intrusion_policy_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}

######
### map_file_policies
######
locals {
  map_file_policies = merge({
    for item in flatten([
      for file_policy_key, file_policy_value in local.resource_file_policy : {
        name        = file_policy_key
        id          = try(fmc_file_policy.module[file_policy_key].id, null)
        type        = try(fmc_file_policy.module[file_policy_key].type, null)
        domain_name = file_policy_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for file_policy_key, file_policy_value in local.data_file_policy : {
          name        = file_policy_key
          id          = try(data.fmc_file_policy.module[file_policy_key].id, null)
          type        = try(data.fmc_file_policy.module[file_policy_key].type, null)
          domain_name = file_policy_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}

######
### map_prefilter_policies
######
locals {
  map_prefilter_policies = merge({
    for item in flatten([
      for prefilter_policy_key, prefilter_policy_value in local.resource_prefilter_policy : {
        name        = prefilter_policy_key
        id          = try(fmc_prefilter_policy.module[prefilter_policy_key].id, null)
        type        = try(fmc_prefilter_policy.module[prefilter_policy_key].type, null)
        domain_name = prefilter_policy_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for prefilter_policy_key, prefilter_policy_value in local.data_prefilter_policy : {
          name        = prefilter_policy_key
          id          = try(data.fmc_prefilter_policy.module[prefilter_policy_key].id, null)
          type        = try(data.fmc_prefilter_policy.module[prefilter_policy_key].type, null)
          domain_name = prefilter_policy_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}


######
### map_snmp_alerts
######
locals {
  map_snmp_alerts = merge(
    #{
    #  for item in flatten([
    #    for domain_key, domain_value in local.resource_snmp_alerts :
    #      flatten([ for item_key, item_value in domain_value.items : {
    #        name        = item_key
    #        id          = fmc_snmp_alerts.module[domain_key].items[item_key].id
    #        #type = fmc_urls.urls[domain_key].items[item_key].type
    #        domain_name = domain_key
    #      }])
    #    ]) : item.name => item if contains(keys(item), "name" )
    #},
    {
      for item in flatten([
        for domain_key, domain_value in local.data_snmp_alerts :
        flatten([for element in keys(domain_value.items) : {
          name = element
          id   = data.fmc_snmp_alerts.module[domain_key].items[element].id
          #type        = data.fmc_snmp_alerts.module[domain_key].items[element].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_snmp_alerts
######
locals {
  map_syslog_alerts = merge(
    #{
    #  for item in flatten([
    #    for domain_key, domain_value in local.resource_sysylog_alerts :
    #      flatten([ for item_key, item_value in domain_value.items : {
    #        name        = item_key
    #        id          = fmc_syslog_alerts.module[domain_key].items[item_key].id
    #        #type = fmc_urls.urls[domain_key].items[item_key].type
    #        domain_name = domain_key
    #      }])
    #    ]) : item.name => item if contains(keys(item), "name" )
    #},
    {
      for item in flatten([
        for domain_key, domain_value in local.data_syslog_alerts :
        flatten([for element in keys(domain_value.items) : {
          name = element
          id   = data.fmc_syslog_alerts.module[domain_key].items[element].id
          #type        = data.fmc_syslog_alerts.module[domain_key].items[element].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}
