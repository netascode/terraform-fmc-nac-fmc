##########################################################
###    Content of the file:
##########################################################
#
###
#  Resources
####
# resource "fmc_hosts" "module" 
# resource "fmc_networks" "module" 
# resource "fmc_ranges" "module" 
# resource "fmc_fqdn_objects" "module" 
# resource "fmc_network_groups" "module" 
# resource "fmc_ports" "module"
# resource "fmc_icmpv4_objects" "module" 
# resource "fmc_port_groups" "module" 
# resource "fmc_dynamic_objects" "module" 
# resource "fmc_urls" "module" 
# resource "fmc_url_groups" "module" 
# resource "fmc_vlan_tags" "module" 
# resource "fmc_vlan_tag_groups" "module" 
# resource "fmc_sgts" "module" 
# resource "fmc_tunnel_zones" "module" 
# resource "fmc_security_zones" "module"
# resource "fmc_standard_acl" "module" 
# resource "fmc_extended_acl" "module" 
# resource "fmc_application_filters" "module" 
# resource "fmc_time_ranges" "module" 
# resource "fmc_ipv4_address_pools" "module" 
# resource "fmc_ipv6_address_pools" "module" 
#
###  
#  Local variables
###
# local.resource_hosts
# local.resource_networks
# local.resource_ranges
# local.resource_fqdns
# local.resource_network_groups
# local.resource_ports
# local.resource_icmpv4s
# local.resource_port_groups
# local.resource_dynamic_objects
# local.resource_urls
# local.resource_url_groups
# local.resource_vlan_tags
# local.resource_vlan_tag_groups
# local.resource_sgts
# local.resource_tunnel_zones
# local.resource_security_zones
# local.resource_standard_acl
# local.resource_extended_acl
# local.resource_application_filters
# local.resource_time_ranges
# local.resource_ipv4_address_pools
# local.resource_ipv6_address_pools
#
# local.map_network_objects
# local.map_dynamic_objects
# local.map_services
# local.map_service_groups
# local.map_network_group_objects
# local.map_urls
# local.map_url_groups
# local.map_vlan_tags
# local.map_vlan_tag_groups
# local.map_sgts
# local.map_tunnel_zones
# local.map_application_filters
# local.map_time_ranges
# local.map_security_zones
# local.map_variable_sets
# local.map_standard_acls
# local.map_extended_acls
# local.map_ipv4_address_pools
# local.map_ipv6_address_pools
# local.map_url_categories - fake
# local.map_ipv6_dhcp_pools - fake
# local.map_route_maps - fake  
# local.map_prefix_lists - fake   
# 
###

##########################################################
###    HOSTS
##########################################################
locals {
  hosts_bulk = try(local.fmc.module_configuration.hosts_bulk, false)

  # Create a map, key is domain name, value is list of hosts for that domain
  resource_hosts = {
    for domain in local.domains : domain.name => [
      for host in try(domain.objects.hosts, []) : {
        domain      = domain.name
        name        = host.name
        ip          = host.ip
        description = try(host.description, local.defaults.fmc.domains.objects.hosts.description, "")
      } if !contains(try(keys(local.data_hosts[domain.name].items), []), host.name)
    ] if length(try(domain.objects.hosts, [])) > 0
  }
}

# module "hosts" {
#   source   = "./modules/terraform-fmc-hosts"
#   for_each = local.resource_hosts
#   bulk     = hosts_bulk

#   domain = each.key
#   hosts  = each.value
# }

# Handle bulk mode (resource per domain)
resource "fmc_hosts" "module" {
  for_each = local.hosts_bulk ? local.resource_hosts : {}

  domain = each.key
  items  = { for host in each.value : host.name => host }
}

# Handle individual mode (resource per host) 
resource "fmc_host" "module" {
  for_each = !local.hosts_bulk ? {
    for item in flatten([
      for domain, hosts in local.resource_hosts : [
        for host in hosts : {
          key  = "${domain}:${host.name}"
          item = host
        }
      ]
    ]) : item.key => item
  } : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  ip          = each.value.item.ip
  description = each.value.item.description
}


##########################################################
###    NETWORKS
##########################################################
locals {

  resource_networks = {
    for domain in local.domains : domain.name => {
      items = {
        for network in try(domain.objects.networks, []) : network.name => {
          prefix      = network.prefix
          description = try(network.description, local.defaults.fmc.domains.objects.networks.description, null)
        } if !contains(try(local.data_networks[domain.name].itmes, []), network.name)
      }
    } if length(try(domain.objects.networks, [])) > 0
  }

}

resource "fmc_networks" "module" {
  for_each = local.resource_networks

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_networks.module,
  ]
}

##########################################################
###    RANGES
##########################################################
locals {

  resource_ranges = {
    for domain in local.domains : domain.name => {
      items = {
        for range in try(domain.objects.ranges, []) : range.name => {
          ip_range    = range.ip_range
          description = try(range.description, local.defaults.fmc.domains.objects.ranges.description, null)
        } if !contains(try(keys(local.data_ranges[domain.name].items), []), range.name)
      }
    } if length(try(domain.objects.ranges, [])) > 0
  }

}

resource "fmc_ranges" "module" {
  for_each = local.resource_ranges

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_ranges.module,
  ]
}

##########################################################
###    FQDNS
##########################################################
locals {

  resource_fqdns = {
    for domain in local.domains : domain.name => {
      items = {
        for fqdn in try(domain.objects.fqdns, []) : fqdn.name => {
          fqdn           = fqdn.fqdn
          dns_resolution = try(fqdn.dns_resolution, null)
          description    = try(fqdn.description, local.defaults.fmc.domains.objects.fqdns.description, null)
        } if !contains(try(keys(local.data_fqdns[domain.name].items), []), fqdn.name)
      }
    } if length(try(domain.objects.fqdns, [])) > 0
  }

}

resource "fmc_fqdn_objects" "module" {
  for_each = local.resource_fqdns

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_fqdn_objects.module
  ]
}

##########################################################
###    NETWORK GROUPS
##########################################################

locals {

  help_network_objects = flatten([
    for item in keys(local.map_network_objects) : item
  ])

  resource_network_groups = {
    for domain in local.domains : domain.name => {
      items = {
        for item in try(domain.objects.network_groups, {}) : item.name => {
          # Mandatory
          name = item.name
          objects = [for object_item in try(item.objects, []) : {
            id = local.map_network_objects[object_item].id
          } if contains(local.help_network_objects, object_item)]
          literals = [for literal_item in try(item.literals, []) : {
            value = literal_item
          }]
          network_groups = length([for object_item in try(item.objects, []) : object_item if !contains(local.help_network_objects, object_item)]) > 0 ? [for object_item in try(item.objects, []) : object_item if !contains(local.help_network_objects, object_item)] : null
          #network_groups = [for object_item in try(item.objects, []) : object_item if !contains(local.help_network_objects, object_item)]
          description = try(item.description, null)
        }
      } # no data source yet
      domain_name = domain.name
    } if length(try(domain.objects.network_groups, [])) > 0
  }

}

resource "fmc_network_groups" "module" {
  for_each = local.resource_network_groups

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.value.domain_name

  depends_on = [
    data.fmc_hosts.module,
    fmc_hosts.module,
    fmc_host.module,
    data.fmc_networks.module,
    fmc_networks.module,
    data.fmc_ranges.module,
    fmc_ranges.module,
    data.fmc_fqdn_objects.module,
    fmc_fqdn_objects.module,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

##########################################################
###    PORTS
##########################################################
locals {

  resource_ports = {
    for domain in local.domains : domain.name => {
      items = {
        for port in try(domain.objects.ports, []) : port.name => {
          protocol    = port.protocol
          port        = try(port.port, null)
          description = try(port.description, local.defaults.fmc.domains.objects.ports.description, null)
        } if !contains(try(keys(local.data_icmpv4s[domain.name].items), []), port.name)
      }
    } if length(try(domain.objects.ports, [])) > 0
  }
}

resource "fmc_ports" "module" {
  for_each = local.resource_ports

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_ports.module,
  ]
}

##########################################################
###    ICMPv4s
##########################################################
locals {

  resource_icmpv4s = {
    for domain in local.domains : domain.name => {
      items = {
        for icmpv4 in try(domain.objects.icmpv4s, []) : icmpv4.name => {
          icmp_type   = try(icmpv4.icmp_type, null)
          code        = try(icmpv4.code, null)
          description = try(icmpv4.description, local.defaults.fmc.domains.objects.icmpv4s.description, null)
        } if !contains(try(keys(local.data_icmpv4s[domain.name].items), []), icmpv4.name)
      }
    } if length(try(domain.objects.icmpv4s, [])) > 0
  }

}

resource "fmc_icmpv4_objects" "module" {
  for_each = local.resource_icmpv4s

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_icmpv4_objects.module,
  ]
}

##########################################################
###    Port_Groups
##########################################################
locals {

  resource_port_groups = {
    for domain in local.domains : domain.name => {
      items = {
        for port_group in try(domain.objects.port_groups, {}) : port_group.name => {
          # Mandatory
          name = port_group.name
          objects = [for object_item in try(port_group.objects, []) : {
            id   = local.map_services[object_item].id
            type = local.map_services[object_item].type
          }]
          description = try(port_group.description, local.defaults.fmc.domains.objects.port_groups.description, null)
        } if !contains(try(keys(local.data_port_groups[domain.name].items), []), port_group.name)
      }
    } if length(try(domain.objects.port_groups, [])) > 0
  }

}

resource "fmc_port_groups" "module" {
  for_each = local.resource_port_groups

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_ports.module,
    fmc_ports.module,
    data.fmc_icmpv4_objects.module,
    fmc_icmpv4_objects.module,
    data.fmc_port_groups.module,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

##########################################################
###    DYNAMIC OBJECT
##########################################################
locals {

  resource_dynamic_objects = {
    for domain in local.domains : domain.name => {
      items = {
        for dynamic_object in try(domain.objects.dynamic_objects, []) : dynamic_object.name => {
          object_type = try(dynamic_object.type, local.defaults.fmc.domains.objects.dynamic_objects.type, null)
          mappings    = try(dynamic_object.mappings, null)
          description = try(dynamic_object.description, local.defaults.fmc.domains.objects.dynamic_objects.description, null)
        } if !contains(try(keys(local.data_dynamic_objects[domain.name].items), []), dynamic_object.name)
      }
    } if length(try(domain.objects.dynamic_objects, [])) > 0
  }

}

resource "fmc_dynamic_objects" "module" {
  for_each = local.resource_dynamic_objects

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_dynamic_objects.module,
  ]
}

##########################################################
###    URLs
##########################################################
locals {

  resource_urls = {
    for domain in local.domains : domain.name => {
      items = {
        for url in try(domain.objects.urls, []) : url.name => {
          url         = url.url
          description = try(url.description, local.defaults.fmc.domains.objects.urls.description, null)
        } if !contains(try(keys(local.data_urls[domain.name].items), []), url.name)
      }
    } if length(try(domain.objects.urls, [])) > 0
  }

}

resource "fmc_urls" "module" {
  for_each = local.resource_urls

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_urls.module,
  ]
}

##########################################################
###    URL_Groups
##########################################################
locals {

  resource_url_groups = {
    for domain in local.domains : domain.name => {
      items = {
        for url_group in try(domain.objects.url_groups, {}) : url_group.name => {
          name = url_group.name
          urls = [for url_item in try(url_group.urls, []) : {
            id = local.map_urls[url_item].id
          }]
          literals = [for literal_item in try(url_group.literals, []) : {
            url = literal_item
          }]

          description = try(url_group.description, null)
        } if !contains(try(keys(local.data_url_groups[domain.name].items), []), url_group.name)
      }
    } if length(try(domain.objects.url_groups, [])) > 0
  }

}

resource "fmc_url_groups" "module" {
  for_each = local.resource_url_groups

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_urls.module,
    fmc_urls.module,
    data.fmc_url_groups.module,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

##########################################################
###    VLAN Tags (SGTs)
##########################################################

# TODO
locals {

  resource_vlan_tags = {
    for domain in local.domains : domain.name => {
      "items" = {
        for vlan_tag in try(domain.objects.vlan_tags, []) : vlan_tag.name => {
          start_tag   = vlan_tag.start_tag
          end_tag     = try(vlan_tag.end_tag, vlan_tag.start_tag)
          description = try(vlan_tag.description, local.defaults.fmc.domains.objects.vlan_tags.description, null)
        } if !contains(try(keys(local.data_vlan_tags[domain.name].items), []), vlan_tag.name)
      }
    } if length(try(domain.objects.vlan_tags, [])) > 0
  }

}

resource "fmc_vlan_tags" "module" {
  for_each = local.resource_vlan_tags

  items = each.value.items
  # Optional
  domain = each.key

  depends_on = [
    data.fmc_vlan_tags.module,
  ]
}

##########################################################
###    VLAN_Tag_Groups
##########################################################
locals {

  resource_vlan_tag_groups = {
    for domain in local.domains : domain.name => {
      items = {
        for vlan_tag_group in try(domain.objects.vlan_tag_groups, {}) : vlan_tag_group.name => {
          # Mandatory
          name = vlan_tag_group.name
          vlan_tags = [for vlan_tag_item in try(vlan_tag_group.vlan_tags, []) : {
            id = local.map_vlan_tags[vlan_tag_item].id
          }]
          literals = [for literal_item in try(vlan_tag_group.literals, {}) : {
            start_tag = literal_item.start_tag
            end_tag   = try(literal_item.end_tag, literal_item.start_tag)
          }]
          description = try(vlan_tag_group.description, null)
        } if !contains(try(keys(local.data_vlan_tag_groups[domain.name].items), []), vlan_tag_group.name)
      }
    } if length(try(domain.objects.vlan_tag_groups, [])) > 0
  }

}

resource "fmc_vlan_tag_groups" "module" {
  for_each = local.resource_vlan_tag_groups

  # Mandatory 
  items = each.value.items
  # Optional 
  domain = each.key

  depends_on = [
    data.fmc_vlan_tags.module,
    fmc_vlan_tags.module,
    data.fmc_vlan_tag_groups.module,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

##########################################################
###    Security Group Tags
##########################################################
locals {

  resource_sgts = {
    for domain in local.domains : domain.name => {
      "items" = {
        for sgt in try(domain.objects.sgts, []) : sgt.name =>
        {
          tag         = sgt.tag
          description = try(sgt.description, null)
        } if !contains(try(keys(local.data_sgts[domain.name].items), []), sgt.name)
      }
    } if length(try(domain.objects.sgts, [])) > 0
  }

}

resource "fmc_sgts" "module" {
  for_each = local.resource_sgts

  # Mandatory 
  items = each.value.items
  # Optional 
  domain = each.key

  depends_on = [
    data.fmc_sgts.module,
  ]

}
##########################################################
###    Tunnel Zones
##########################################################

locals {

  resource_tunnel_zones = {
    for domain in local.domains : domain.name => {
      "items" = {
        for tunnel_zone in try(domain.objects.tunnel_zones, []) : tunnel_zone.name => {
          description = try(tunnel_zone.description, local.defaults.fmc.domains.objects.tunnel_zones.description, null)
        } if !contains(try(keys(local.data_tunnel_zones[domain.name].items), []), tunnel_zone.name)
      }
    } if length(try(domain.objects.tunnel_zones, [])) > 0
  }

}

resource "fmc_tunnel_zones" "module" {
  for_each = local.resource_tunnel_zones

  items = each.value.items
  # Optional
  domain = each.key

  depends_on = [
    data.fmc_tunnel_zones.module,
  ]
}
##########################################################
###    SECURITY ZONE
##########################################################
locals {

  resource_security_zones = {
    for domain in local.domains : domain.name => {
      items = {
        for security_zone in try(domain.objects.security_zones, []) : security_zone.name =>
        {
          # Mandatory 
          interface_type = try(security_zone.interface_type, local.defaults.fmc.domains.objects.security_zones.interface_type)
        } if !contains(try(keys(local.data_security_zones[domain.name].items), []), security_zone.name)
      }
    } if length(try(domain.objects.security_zones, [])) > 0

  }

}

resource "fmc_security_zones" "module" {
  for_each = local.resource_security_zones

  # Mandatory 
  items = each.value.items

  # Optional
  domain = each.key
}

##########################################################
###    STANDARS/EXTENDED ACL
##########################################################
locals {

  resource_standard_acl = {
    for item in flatten([
      for domain in local.domains : [
        for standard_access_list in try(domain.objects.standard_access_lists, {}) : {
          # Mandatory
          name = standard_access_list.name
          entries = [for entry in standard_access_list.entries : {
            # Mandatory
            action = entry.action
            # Optional
            literals = [for literal in try(entry.literals, []) : {
              value = literal
            }]
            objects = [for obcject in try(entry.objects, []) : {
              id = try(local.map_network_objects[obcject].id, local.map_network_group_objects[obcject].id, null)
            }]
          }]
          # Optional
          description = try(standard_access_list.description, null)
          domain_name = domain.name
        }
      ]
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name") && !contains(try(keys(local.data_standard_acl), {}), "${item.domain_name}:${item.name}")
  }

}


resource "fmc_standard_acl" "module" {
  for_each = local.resource_standard_acl
  # Mandatory 
  name = each.value.name

  # Optional
  entries     = each.value.entries
  description = each.value.description
  domain      = each.value.domain_name

}

locals {
  resource_extended_acl = {
    for item in flatten([
      for domain in local.domains : [
        for extended_access_list in try(domain.objects.extended_access_lists, {}) : {
          # Mandatory
          name = extended_access_list.name
          entries = [for entry in extended_access_list.entries : {
            # Mandatory
            action  = entry.action
            logging = entry.logging
            # Optional
            destination_network_literals = [for destination_network_literal in try(entry.destination_network_literals, []) : {
              value = destination_network_literal
              type  = can(regex("/", destination_network_literal)) ? "Network" : "Host"
            }]
            destination_network_objects = [for destination_network_object in try(entry.destination_network_objects, []) : {
              id = try(local.map_network_objects[destination_network_object].id, local.map_network_group_objects[destination_network_object].id, null)
            }]
            destination_port_objects = [for destination_port_object in try(entry.destination_port_objects, []) : {
              id = try(local.map_services[destination_port_object].id, local.map_service_groups[destination_port_object].id, null)
            }]
            destination_port_literals = [for destination_port_literal in try(entry.destination_port_literals, []) : {
              protocol  = local.help_protocol_mapping[destination_port_literal.protocol]
              port      = try(destination_port_literal.port, null)
              icmp_type = try(destination_port_literal.icmp_type, null)
              icmp_code = try(destination_port_literal.icmp_code, null)
              type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
            }]

            log_interval_seconds = try(entry.log_interval_seconds, null)
            log_level            = try(entry.log_level, null)
            source_network_literals = [for source_network_literal in try(entry.source_network_literals, []) : {
              value = source_network_literal
              type  = can(regex("/", source_network_literal)) ? "Network" : "Host"
            }]
            source_network_objects = [for source_network_object in try(entry.source_network_objects, []) : {
              id = try(local.map_network_objects[source_network_object].id, local.map_network_group_objects[source_network_object].id, null)
            }]
            source_port_objects = [for source_port_object in try(entry.source_port_objects, []) : {
              id = try(local.map_services[source_port_object].id, local.map_service_groups[source_port_object].id, null)
            }]
            source_port_literals = [for source_port_literal in try(entry.source_port_literals, []) : {
              protocol  = local.help_protocol_mapping[source_port_literal.protocol]
              port      = try(source_port_literal.port, null)
              icmp_type = try(source_port_literal.icmp_type, null)
              icmp_code = try(source_port_literal.icmp_code, null)
              type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
            }]
            source_sgt_objects = [for source_sgt_object in try(entry.source_sgt_objects, []) : {
              id = try(local.map_sgts[source_sgt_object].id, null)
            }]
          }]
          description = try(extended_access_list.description, null)
          domain_name = domain.name

        }
      ]
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name") && !contains(try(keys(local.data_extended_acl), {}), "${item.domain_name}:${item.name}")
  }

}

resource "fmc_extended_acl" "module" {
  for_each = local.resource_extended_acl
  # Mandatory 
  name = each.value.name

  # Optional
  entries     = each.value.entries
  description = each.value.description
  domain      = each.value.domain_name
}

##########################################################
###    APPLICATION FILTERS
##########################################################
locals {

  resource_application_filters = {
    for domain in local.domains : domain.name => {
      items = {
        for application_filter in try(domain.objects.application_filters, []) : application_filter.name =>
        {
          applications = contains(try(keys(application_filter), []), "applications") ? [for application in application_filter.applications : {
            id   = data.fmc_applications.module[domain.name].items[application].id
            name = application
          }] : null
          filters = length(try(application_filter.filters, [])) > 0 ? [for filter in application_filter.filters : {
            business_relevances = contains(try(keys(filter), []), "business_relevances") ? [for business_relevance in filter.business_relevances : {
              id = data.fmc_application_business_relevances.module[domain.name].items[business_relevance].id
            }] : null

            categories = contains(try(keys(filter), []), "categories") ? [for category in filter.categories : {
              id = data.fmc_application_categories.module[domain.name].items[category].id
            }] : null

            risks = contains(try(keys(filter), []), "risks") ? [for risks in filter.risks : {
              id = data.fmc_application_risks.module[domain.name].items[risks].id
            }] : null

            types = contains(try(keys(filter), []), "types") ? [for type in filter.types : {
              id = data.fmc_application_types.module[domain.name].items[type].id
            }] : null

            tags = contains(try(keys(filter), []), "tags") ? [for tag in filter.tags : {
              id = data.fmc_application_tags.module[domain.name].items[tag].id
            }] : null

          }] : null

        } if !contains(try(keys(local.data_application_filters[domain.name].items), []), application_filter.name)
      }
    } if length(try(domain.objects.application_filters, [])) > 0

  }
}

resource "fmc_application_filters" "module" {
  for_each = local.resource_application_filters

  # Mandatory 
  items = each.value.items

  # Optional
  domain = each.key
  depends_on = [
    data.fmc_applications.module,
    data.fmc_application_business_relevances.module,
    data.fmc_application_categories.module,
    data.fmc_application_risks.module,
    data.fmc_application_tags.module,
    data.fmc_application_types.module,
  ]
}
##########################################################
###    TIME RANGES
##########################################################
locals {

  resource_time_ranges = {
    for domain in local.domains : domain.name => {
      items = {
        for time_range in try(domain.objects.time_ranges, []) : time_range.name =>
        {
          start_time = try(time_range.start_time, null)
          end_time   = try(time_range.end_time, null)
          recurrence_list = [for recurrence in try(time_range.recurrences, []) : {
            recurrence_type  = recurrence.recurrence_type
            daily_days       = try(recurrence.daily_days, null)
            daily_end_time   = try(recurrence.daily_end_time, null)
            daily_start_time = try(recurrence.daily_start_time, null)
            range_end_day    = try(recurrence.range_end_day, null)
            range_end_time   = try(recurrence.range_end_time, null)
            range_start_day  = try(recurrence.range_start_day, null)
            range_start_time = try(recurrence.range_start_time, null)
          }]

          description = try(time_range.description, null)
        } if !contains(try(keys(local.data_time_ranges[domain.name].items), []), time_range.name)
      }
    } if length(try(domain.objects.time_ranges, [])) > 0

  }

}

resource "fmc_time_ranges" "module" {
  for_each = local.resource_time_ranges

  # Mandatory 
  items = each.value.items

  # Optional
  domain = each.key
}

##########################################################
###    IPV4 ADDRESS POOL
##########################################################
locals {

  resource_ipv4_address_pools = {
    for domain in local.domains : domain.name => {
      items = {
        for ipv4_address_pool in try(domain.objects.ipv4_address_pools, []) : ipv4_address_pool.name => {
          range       = ipv4_address_pool.range
          netmask     = ipv4_address_pool.netmask
          overridable = try(ipv4_address_pool.overridable, local.defaults.fmc.domains.objects.ipv4_address_pool.overridable, null)
          description = try(ipv4_address_pool.description, local.defaults.fmc.domains.objects.ipv4_address_pool.description, null)
        } if !contains(try(keys(local.data_ipv4_address_pools[domain.name].items), []), ipv4_address_pool.name)
      }
    } if length(try(domain.objects.ipv4_address_pools, [])) > 0
  }

}

resource "fmc_ipv4_address_pools" "module" {
  for_each = local.resource_ipv4_address_pools

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_ipv4_address_pools.module,
  ]

}

##########################################################
###    IPV6 ADDRESS POOL
##########################################################
locals {

  resource_ipv6_address_pools = {
    for domain in local.domains : domain.name => {
      items = {
        for ipv6_address_pool in try(domain.objects.ipv6_address_pools, []) : ipv6_address_pool.name => {
          start_address       = ipv6_address_pool.start_address
          number_of_addresses = ipv6_address_pool.number_of_addresses
          overridable         = try(ipv6_address_pool.overridable, local.defaults.fmc.domains.objects.ipv6_address_pool.overridable, null)
          description         = try(ipv6_address_pool.description, local.defaults.fmc.domains.objects.ipv6_address_pool.description, null)
        } if !contains(try(keys(local.data_ipv6_address_pools[domain.name].items), []), ipv6_address_pool.name)
      }
    } if length(try(domain.objects.ipv6_address_pools, [])) > 0
  }

}

resource "fmc_ipv6_address_pools" "module" {
  for_each = local.resource_ipv6_address_pools

  # Mandatory
  items = each.value.items

  # Optional
  domain = each.key

  depends_on = [
    data.fmc_ipv6_address_pools.module,
  ]

}

##########################################################
###    Create maps for combined set of _data and _resources network objects 
##########################################################
######
### map_network_objects
######

locals {
  map_network_objects = merge(

    # Hosts - bulk mode outputs
    local.hosts_bulk ? merge([
      for domain, hosts in fmc_hosts.module : {
        for host_name, host_values in hosts.items : host_name => { id = host_values.id, type = host_values.type }
      }
    ]...) : {},

    # Hosts - individual mode outputs  
    !local.hosts_bulk ? { for key, resource in fmc_host.module : resource.name => { id = resource.id, type = resource.type } } : {},

    # Hosts - data sources
    merge([
      for domain, hosts in data.fmc_hosts.module : {
        for host_name, host_values in hosts.items : host_name => { id = host_values.id, type = host_values.type }
      }
    ]...),
    {
      for item in flatten([
        for domain_key, domain_value in local.resource_networks :
        flatten([for item_key, item_value in domain_value.items : {
          name        = item_key
          id          = fmc_networks.module[domain_key].items[item_key].id
          type        = fmc_networks.module[domain_key].items[item_key].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_networks :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_networks.module[domain_key].items[item].id
          type        = data.fmc_networks.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.resource_ranges :
        flatten([for item_key, item_value in domain_value.items : {
          name        = item_key
          id          = fmc_ranges.module[domain_key].items[item_key].id
          type        = fmc_ranges.module[domain_key].items[item_key].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_ranges :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_ranges.module[domain_key].items[item].id
          type        = data.fmc_ranges.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.resource_fqdns :
        flatten([for item_key, item_value in domain_value.items : {
          name        = item_key
          id          = fmc_fqdn_objects.module[domain_key].items[item_key].id
          type        = fmc_fqdn_objects.module[domain_key].items[item_key].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_fqdns :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_fqdn_objects.module[domain_key].items[item].id
          type        = data.fmc_fqdn_objects.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}

######
### map_dynamic_objects
######
locals {
  map_dynamic_objects = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_dynamic_objects :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_dynamic_objects.module[domain_key].items[item_key].id
        type        = fmc_dynamic_objects.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_dynamic_objects :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_dynamic_objects.module[domain_key].items[item].id
          type        = data.fmc_dynamic_objects.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )
}
######
### map_services - ports + icmpv4s
######
locals {
  map_services = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_ports :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_ports.module[domain_key].items[item_key].id
        type        = fmc_ports.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_ports :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_ports.module[domain_key].items[item].id
          type        = data.fmc_ports.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.resource_icmpv4s :
        flatten([for item_key, item_value in domain_value.items : {
          name        = item_key
          id          = fmc_icmpv4_objects.module[domain_key].items[item_key].id
          type        = fmc_icmpv4_objects.module[domain_key].items[item_key].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_icmpv4s :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_icmpv4_objects.module[domain_key].items[item].id
          type        = data.fmc_icmpv4_objects.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_service_groups
######
locals {
  map_service_groups = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_port_groups :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = try(fmc_port_groups.module[domain_key].items[item_key].id, null)
        type        = try(fmc_port_groups.module[domain_key].items[item_key].type, null)
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_port_groups :
        flatten([for item in domain_value.items : {
          name        = item
          id          = try(data.fmc_port_groups.module[domain_key].items[item].id, null)
          type        = try(data.fmc_port_groups.module[domain_key].items[item].type, null)
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_network_group_objects
######
locals {
  map_network_group_objects = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_network_groups :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = try(fmc_network_groups.module[domain_key].items[item_key].id, null)
        type        = "NetworkGroup"
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
  )

}
######
### map_urls - urls data + resource
######
locals {
  map_urls = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_urls :
      flatten([for item_key, item_value in domain_value.items : {
        name = item_key
        id   = fmc_urls.module[domain_key].items[item_key].id
        #type = fmc_urls.urls[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_urls :
        flatten([for item in keys(domain_value.items) : {
          name = item
          id   = data.fmc_urls.module[domain_key].items[item].id
          #type        = data.fmc_urls.urls[domain_key].items[item_key].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

  map_url_groups = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_url_groups :
      flatten([for item_key, item_value in domain_value.items : {
        name = item_key
        id   = fmc_url_groups.module[domain_key].items[item_key].id
        #type = fmc_urls.urls[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_url_groups :
        flatten([for item in keys(domain_value.items) : {
          name = item
          id   = data.fmc_url_groups.module[domain_key].items[item].id
          #type        = data.fmc_urls.urls[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )


}
######
### map_vlan_tags - vlan_tags data + resource
######
locals {
  map_vlan_tags = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_vlan_tags :
      flatten([for item_key, item_value in domain_value.items : {
        name = item_key
        id   = fmc_vlan_tags.module[domain_key].items[item_key].id
        #type = fmc_vlan_tags.vlan_tags[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_vlan_tags :
        flatten([for item in keys(domain_value.items) : {
          name = item
          id   = data.fmc_vlan_tags.module[domain_key].items[item].id
          #type        = data.fmc_vlan_tags.vlan_tags[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

  map_vlan_tag_groups = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_vlan_tag_groups :
      flatten([for item_key, item_value in domain_value.items : {
        name = item_key
        id   = fmc_vlan_tag_groups.module[domain_key].items[item_key].id
        #type = fmc_vlan_tags.vlan_tags[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_vlan_tag_groups :
        flatten([for item in keys(domain_value.items) : {
          name = item
          id   = data.fmc_vlan_tag_groups.module[domain_key].items[item].id
          #type        = data.fmc_vlan_tags.vlan_tags[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_sgts - security group tags (data source + resource) + ISE SGT (data source)
######
locals {
  map_sgts = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_sgts :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_sgts.module[domain_key].items[item_key].id
        type        = fmc_sgts.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_sgts :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_sgts.module[domain_key].items[item].id
          type        = data.fmc_sgts.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_ise_sgts :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_ise_sgts.module[domain_key].items[item].id
          type        = data.fmc_ise_sgts.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}
######
### map_tunnel_zones - tunnel zones/tegs data + resource
######
locals {
  map_tunnel_zones = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_tunnel_zones :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_tunnel_zones.module[domain_key].items[item_key].id
        type        = fmc_tunnel_zones.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_tunnel_zones :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_tunnel_zones.module[domain_key].items[item].id
          type        = data.fmc_tunnel_zones.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_application_filters - Application Filters data + resource
######
locals {
  map_application_filters = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_application_filters :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_application_filters.module[domain_key].items[item_key].id
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_time_ranges :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_application_filters.module[domain_key].items[item].id
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_time_ranges - Time Ranges data + resource
######
locals {
  map_time_ranges = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_time_ranges :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_time_ranges.module[domain_key].items[item_key].id
        type        = fmc_time_ranges.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_time_ranges :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_time_ranges.module[domain_key].items[item].id
          type        = data.fmc_time_ranges.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_security_zones - security zones data + resource
######
locals {
  map_security_zones = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_security_zones :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_security_zones.module[domain_key].items[item_key].id
        type        = fmc_security_zones.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_security_zones :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_security_zones.module[domain_key].items[item].id
          type        = data.fmc_security_zones.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_variable_sets - variable_set data only - no support for resource 
######

locals {
  map_variable_sets = merge({
    for item in flatten([
      for variable_set_key, variable_set_value in local.data_variable_set : {
        name        = variable_set_key
        type        = data.fmc_variable_set.module[variable_set_key].type
        id          = data.fmc_variable_set.module[variable_set_key].id
        domain_name = variable_set_value.domain_name
      }
    ]) : item.name => item
    },
  )
}

######
### map_standard_acls and map_extended_acls 
######
locals {
  map_standard_acls = merge({
    for item in flatten([
      for standard_acl_key, standard_acl_value in local.resource_standard_acl : {
        name        = standard_acl_value.name
        id          = try(fmc_standard_acl.module[standard_acl_key].id, null)
        type        = try(fmc_standard_acl.module[standard_acl_key].type, null)
        domain_name = standard_acl_value.domain_name
      }
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for standard_acl_key, standard_acl_value in local.data_standard_acl : {
          name        = standard_acl_value.name
          id          = try(data.fmc_standard_acl.module[standard_acl_key].id, null)
          type        = try(data.fmc_standard_acl.module[standard_acl_key].type, null)
          domain_name = standard_acl_value.domain_name
        }
      ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
    },
  )

  map_extended_acls = merge({
    for item in flatten([
      for extended_acl_key, extended_acl_value in local.resource_extended_acl : {
        name        = extended_acl_value.name
        id          = try(fmc_extended_acl.module[extended_acl_key].id, null)
        type        = try(fmc_extended_acl.module[extended_acl_key].type, null)
        domain_name = extended_acl_value.domain_name
      }
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for extended_acl_key, extended_acl_value in local.data_extended_acl : {
          name        = extended_acl_value.name
          id          = try(data.fmc_extended_acl.module[extended_acl_key].id, null)
          type        = try(data.fmc_extended_acl.module[extended_acl_key].type, null)
          domain_name = extended_acl_value.domain_name
        }
      ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
    },
  )

}

######
### map_ipv4_address_pools - data + resource
######
locals {
  map_ipv4_address_pools = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_ipv4_address_pools :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_ipv4_address_pools.module[domain_key].items[item_key].id
        type        = fmc_ipv4_address_pools.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_ipv4_address_pools :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_ipv4_address_pools.module[domain_key].items[item].id
          type        = data.fmc_ipv4_address_pools.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_ipv6_address_pools - data + resource
######
locals {
  map_ipv6_address_pools = merge({
    for item in flatten([
      for domain_key, domain_value in local.resource_ipv6_address_pools :
      flatten([for item_key, item_value in domain_value.items : {
        name        = item_key
        id          = fmc_ipv6_address_pools.module[domain_key].items[item_key].id
        type        = fmc_ipv6_address_pools.module[domain_key].items[item_key].type
        domain_name = domain_key
      }])
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for domain_key, domain_value in local.data_ipv6_address_pools :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_ipv6_address_pools.module[domain_key].items[item].id
          type        = data.fmc_ipv6_address_pools.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### map_endpoint_device_types - data
######
locals {
  map_endpoint_device_types = merge(
    {
      for item in flatten([
        for domain_key, domain_value in local.data_endpoint_device_types :
        flatten([for item in keys(domain_value.items) : {
          name        = item
          id          = data.fmc_endpoint_device_types.module[domain_key].items[item].id
          type        = data.fmc_endpoint_device_types.module[domain_key].items[item].type
          domain_name = domain_key
        }])
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}


######
### FAKE - TODO
######

locals {
  map_url_categories  = {}
  map_ipv6_dhcp_pools = {}
  map_route_maps      = {}
  map_prefix_lists    = {}
}
