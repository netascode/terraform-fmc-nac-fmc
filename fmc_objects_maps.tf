##########################################################
###    MAP combines data sources and resources for individual and bulk modes
###    of one or more types
##########################################################

######
### map_network_objects
######
locals {
  map_network_objects = merge(

    # Hosts - bulk mode outputs
    local.hosts_bulk ? merge([
      for domain, hosts in fmc_hosts.hosts : {
        for host_name, host_values in hosts.items : "${domain}:${host_name}" => { id = host_values.id, type = host_values.type }
      }
    ]...) : {},

    # Hosts - individual mode outputs
    !local.hosts_bulk ? { for key, resource in fmc_host.host : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Hosts - data sources
    merge([
      for domain, hosts in data.fmc_hosts.hosts : {
        for host_name, host_values in hosts.items : "${domain}:${host_name}" => { id = host_values.id, type = host_values.type }
      }
    ]...),

    # Networks - bulk mode outputs
    local.networks_bulk ? merge([
      for domain, networks in fmc_networks.networks : {
        for network_name, network_values in networks.items : "${domain}:${network_name}" => { id = network_values.id, type = network_values.type }
      }
    ]...) : {},

    # Networks - individual mode outputs
    !local.networks_bulk ? { for key, resource in fmc_network.network : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Networks - data sources
    merge([
      for domain, networks in data.fmc_networks.networks : {
        for network_name, network_values in networks.items : "${domain}:${network_name}" => { id = network_values.id, type = network_values.type }
      }
    ]...),

    # Ranges - bulk mode outputs
    local.ranges_bulk ? merge([
      for domain, ranges in fmc_ranges.ranges : {
        for range_name, range_values in ranges.items : "${domain}:${range_name}" => { id = range_values.id, type = range_values.type }
      }
    ]...) : {},

    # Ranges - individual mode outputs
    !local.ranges_bulk ? { for key, resource in fmc_range.range : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Ranges - data sources
    merge([
      for domain, ranges in data.fmc_ranges.ranges : {
        for range_name, range_values in ranges.items : "${domain}:${range_name}" => { id = range_values.id, type = range_values.type }
      }
    ]...),

    # FQDNs - bulk mode outputs
    local.fqdns_bulk ? merge([
      for domain, fqdns in fmc_fqdns.fqdns : {
        for fqdn_name, fqdn_values in fqdns.items : "${domain}:${fqdn_name}" => { id = fqdn_values.id, type = fqdn_values.type }
      }
    ]...) : {},

    # FQDNs - individual mode outputs
    !local.fqdns_bulk ? { for key, resource in fmc_fqdn.fqdn : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # FQDNs - data sources
    merge([
      for domain, fqdns in data.fmc_fqdns.fqdns : {
        for fqdn_name, fqdn_values in fqdns.items : "${domain}:${fqdn_name}" => { id = fqdn_values.id, type = fqdn_values.type }
      }
    ]...),
  )
}

######
### map_network_group_objects
######
locals {
  map_network_group_objects = merge(

    # Network Groups - bulk mode outputs
    merge([
      for domain, network_groups in fmc_network_groups.network_groups : {
        for network_group_name, network_group_values in network_groups.items : "${domain}:${network_group_name}" => { id = network_group_values.id, type = network_group_values.type }
      }
    ]...),

    # Network Groups - data sources
    merge([
      for domain, network_groups in data.fmc_network_groups.network_groups : {
        for network_group_name, network_group_values in network_groups.items : "${domain}:${network_group_name}" => { id = network_group_values.id, type = network_group_values.type }
      }
    ]...),
  )
}

######
### map_services => Port, ICMPv4, ICMPv6
######
locals {
  map_services = merge(

    # Ports - bulk mode outputs
    local.ports_bulk ? merge([
      for domain, ports in fmc_ports.ports : {
        for port_name, port_values in ports.items : "${domain}:${port_name}" => { id = port_values.id, type = port_values.type }
      }
    ]...) : {},

    # Ports - individual mode outputs
    !local.ports_bulk ? { for key, resource in fmc_port.port : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Ports - data sources
    merge([
      for domain, ports in data.fmc_ports.ports : {
        for port_name, port_values in ports.items : "${domain}:${port_name}" => { id = port_values.id, type = port_values.type }
      }
    ]...),

    # ICMPv4s - bulk mode outputs
    local.icmpv4s_bulk ? merge([
      for domain, icmpv4s in fmc_icmpv4s.icmpv4s : {
        for icmpv4_name, icmpv4_values in icmpv4s.items : "${domain}:${icmpv4_name}" => { id = icmpv4_values.id, type = icmpv4_values.type }
      }
    ]...) : {},

    # ICMPv4s - individual mode outputs
    !local.icmpv4s_bulk ? { for key, resource in fmc_icmpv4.icmpv4 : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # ICMPv4s - data sources
    merge([
      for domain, icmpv4s in data.fmc_icmpv4s.icmpv4s : {
        for icmpv4_name, icmpv4_values in icmpv4s.items : "${domain}:${icmpv4_name}" => { id = icmpv4_values.id, type = icmpv4_values.type }
      }
    ]...),

    # ICMPv6s - bulk mode outputs
    local.icmpv6s_bulk ? merge([
      for domain, icmpv6s in fmc_icmpv6s.icmpv6s : {
        for icmpv6_name, icmpv6_values in icmpv6s.items : "${domain}:${icmpv6_name}" => { id = icmpv6_values.id, type = icmpv6_values.type }
      }
    ]...) : {},

    # ICMPv6s - individual mode outputs
    !local.icmpv6s_bulk ? { for key, resource in fmc_icmpv6.icmpv6 : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # ICMPv6s - data sources
    merge([
      for domain, icmpv6s in data.fmc_icmpv6s.icmpv6s : {
        for icmpv6_name, icmpv6_values in icmpv6s.items : "${domain}:${icmpv6_name}" => { id = icmpv6_values.id, type = icmpv6_values.type }
      }
    ]...),
  )
}

######
### map_port_groups
######
locals {
  map_port_groups = merge(

    # Port Groups - bulk mode outputs
    merge([
      for domain, port_groups in fmc_port_groups.port_groups : {
        for port_group_name, port_group_values in port_groups.items : "${domain}:${port_group_name}" => { id = port_group_values.id, type = port_group_values.type }
      }
    ]...),

    # Port Groups - individual mode outputs
    !local.port_groups_bulk ? { for key, resource in fmc_port_group.port_group : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Port Groups - data sources
    merge([
      for domain, port_groups in data.fmc_port_groups.port_groups : {
        for port_group_name, port_group_values in port_groups.items : "${domain}:${port_group_name}" => { id = port_group_values.id, type = port_group_values.type }
      }
    ]...),
  )
}

######
### map_dynamic_objects
######
locals {
  map_dynamic_objects = merge(

    # Dynamic Objects - bulk mode outputs
    merge([
      for domain, dynamic_objects in fmc_dynamic_objects.dynamic_objects : {
        for dynamic_object_name, dynamic_object_values in dynamic_objects.items : "${domain}:${dynamic_object_name}" => { id = dynamic_object_values.id, type = dynamic_object_values.type }
      }
    ]...),

    # Dynamic Objects - data sources
    merge([
      for domain, dynamic_objects in data.fmc_dynamic_objects.dynamic_objects : {
        for dynamic_object_name, dynamic_object_values in dynamic_objects.items : "${domain}:${dynamic_object_name}" => { id = dynamic_object_values.id, type = dynamic_object_values.type }
      }
    ]...),
  )
}

######
### map_urls
######
locals {
  map_urls = merge(

    # URLs - bulk mode outputs
    local.urls_bulk ? merge([
      for domain, urls in fmc_urls.urls : {
        for url_name, url_values in urls.items : "${domain}:${url_name}" => { id = url_values.id, type = url_values.type }
      }
    ]...) : {},

    # URLs - individual mode outputs
    !local.urls_bulk ? { for key, resource in fmc_url.url : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # URLs - data sources
    merge([
      for domain, urls in data.fmc_urls.urls : {
        for url_name, url_values in urls.items : "${domain}:${url_name}" => { id = url_values.id, type = url_values.type }
      }
    ]...),
  )
}

######
### map_url_groups
######
locals {
  map_url_groups = merge(

    # URL Groups - bulk mode outputs
    local.url_groups_bulk ? merge([
      for domain, url_groups in fmc_url_groups.url_groups : {
        for url_group_name, url_group_values in url_groups.items : "${domain}:${url_group_name}" => { id = url_group_values.id, type = url_group_values.type }
      }
    ]...) : {},

    # URL Groups - individual mode outputs
    !local.url_groups_bulk ? { for key, resource in fmc_url_group.url_group : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # URL Groups - data sources
    merge([
      for domain, url_groups in data.fmc_url_groups.url_groups : {
        for url_group_name, url_group_values in url_groups.items : "${domain}:${url_group_name}" => { id = url_group_values.id, type = url_group_values.type }
      }
    ]...),
  )
}

######
### map_vlan_tags
######
locals {
  map_vlan_tags = merge(

    # VLAN Tags - bulk mode outputs
    local.vlan_tags_bulk ? merge([
      for domain, vlan_tags in fmc_vlan_tags.vlan_tags : {
        for vlan_tag_name, vlan_tag_values in vlan_tags.items : "${domain}:${vlan_tag_name}" => { id = vlan_tag_values.id, type = vlan_tag_values.type }
      }
    ]...) : {},

    # VLAN Tags - individual mode outputs
    !local.vlan_tags_bulk ? { for key, resource in fmc_vlan_tag.vlan_tag : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # VLAN Tags - data sources
    merge([
      for domain, vlan_tags in data.fmc_vlan_tags.vlan_tags : {
        for vlan_tag_name, vlan_tag_values in vlan_tags.items : "${domain}:${vlan_tag_name}" => { id = vlan_tag_values.id, type = vlan_tag_values.type }
      }
    ]...),
  )
}

######
### map_vlan_tag_groups
######
locals {
  map_vlan_tag_groups = merge(
    #
    # VLAN Tag Groups - bulk mode outputs
    local.vlan_tag_groups_bulk ? merge([
      for domain, vlan_tag_groups in fmc_vlan_tag_groups.vlan_tag_groups : {
        for vlan_tag_group_name, vlan_tag_group_values in vlan_tag_groups.items : "${domain}:${vlan_tag_group_name}" => { id = vlan_tag_group_values.id, type = vlan_tag_group_values.type }
      }
    ]...) : {},

    # VLAN Tag Groups - individual mode outputs
    !local.vlan_tag_groups_bulk ? { for key, resource in fmc_vlan_tag_group.vlan_tag_group : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # VLAN Tag Groups - data sources
    merge([
      for domain, vlan_tag_groups in data.fmc_vlan_tag_groups.vlan_tag_groups : {
        for vlan_tag_group_name, vlan_tag_group_values in vlan_tag_groups.items : "${domain}:${vlan_tag_group_name}" => { id = vlan_tag_group_values.id, type = vlan_tag_group_values.type }
      }
    ]...),
  )
}

######
### map_sgts - SGT (data source + resource) + ISE SGT (data source)
######
locals {
  map_sgts = merge(

    # SGT - bulk mode outputs
    local.sgts_bulk ? merge([
      for domain, sgts in fmc_sgts.sgts : {
        for sgt_name, sgt_values in sgts.items : "${domain}:${sgt_name}" => { id = sgt_values.id, type = sgt_values.type }
      }
    ]...) : {},

    # SGT - individual mode outputs
    !local.sgts_bulk ? { for key, resource in fmc_sgt.sgt : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # SGT - data sources
    merge([
      for domain, sgts in data.fmc_sgts.sgts : {
        for sgt_name, sgt_values in sgts.items : "${domain}:${sgt_name}" => { id = sgt_values.id, type = sgt_values.type }
      }
    ]...),

    # ISE SGT - data sources
    merge([
      for domain, ise_sgts in data.fmc_ise_sgts.ise_sgts : {
        for ise_sgt_name, ise_sgt_values in ise_sgts.items : "${domain}:${ise_sgt_name}" => { id = ise_sgt_values.id, type = ise_sgt_values.type }
      }
    ]...),
  )
}

######
### map_tunnel_zones
######
locals {
  map_tunnel_zones = merge(

    # Tunnel Zones - bulk mode outputs
    local.tunnel_zones_bulk ? merge([
      for domain, tunnel_zones in fmc_tunnel_zones.tunnel_zones : {
        for tunnel_zone_name, tunnel_zone_values in tunnel_zones.items : "${domain}:${tunnel_zone_name}" => { id = tunnel_zone_values.id, type = tunnel_zone_values.type }
      }
    ]...) : {},

    # Tunnel Zones - individual mode outputs
    !local.tunnel_zones_bulk ? { for key, resource in fmc_tunnel_zone.tunnel_zone : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Tunnel Zones - data sources
    merge([
      for domain, tunnel_zones in data.fmc_tunnel_zones.tunnel_zones : {
        for tunnel_zone_name, tunnel_zone_values in tunnel_zones.items : "${domain}:${tunnel_zone_name}" => { id = tunnel_zone_values.id, type = tunnel_zone_values.type }
      }
    ]...),
  )
}

######
### map_security_zones
######
locals {
  map_security_zones = merge(

    # Security Zones - bulk mode outputs
    local.security_zones_bulk ? merge([
      for domain, security_zones in fmc_security_zones.security_zones : {
        for security_zone_name, security_zone_values in security_zones.items : "${domain}:${security_zone_name}" => { id = security_zone_values.id, type = security_zone_values.type }
      }
    ]...) : {},

    # Security Zones - individual mode outputs
    !local.security_zones_bulk ? { for key, resource in fmc_security_zone.security_zone : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Security Zones - data sources
    merge([
      for domain, security_zones in data.fmc_security_zones.security_zones : {
        for security_zone_name, security_zone_values in security_zones.items : "${domain}:${security_zone_name}" => { id = security_zone_values.id, type = security_zone_values.type }
      }
    ]...),
  )
}

######
### map_interface_groups
######
locals {
  map_interface_groups = merge(

    # Interface Groups - bulk mode outputs
    local.interface_groups_bulk ? merge([
      for domain, interface_groups in fmc_interface_groups.interface_groups : {
        for interface_group_name, interface_group_values in interface_groups.items : "${domain}:${interface_group_name}" => { id = interface_group_values.id, type = interface_group_values.type }
      }
    ]...) : {},

    # Interface Groups - individual mode outputs
    !local.interface_groups_bulk ? { for key, resource in fmc_interface_group.interface_group : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Interface Groups - data sources
    merge([
      for domain, interface_group in data.fmc_interface_groups.interface_groups : {
        for interface_group_name, interface_group_values in interface_group.items : "${domain}:${interface_group_name}" => { id = interface_group_values.id, type = interface_group_values.type }
      }
    ]...)
  )
}

######
### map_security_zones_and_interface_groups
######
locals {
  map_security_zones_and_interface_groups = merge(
    local.map_security_zones,
    local.map_interface_groups,
  )
}

######
### map_application_filters
######
locals {
  map_application_filters = merge(

    # Application Filters - bulk mode outputs
    local.application_filters_bulk ? merge([
      for domain, application_filters in fmc_application_filters.application_filters : {
        for application_filter_name, application_filter_values in application_filters.items : "${domain}:${application_filter_name}" => { id = application_filter_values.id, type = application_filter_values.type }
      }
    ]...) : {},

    # Application Filters - individual mode outputs
    !local.application_filters_bulk ? { for key, resource in fmc_application_filter.application_filter : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Application Filters - data sources
    merge([
      for domain, application_filters in data.fmc_application_filters.application_filters : {
        for application_filter_name, application_filter_values in application_filters.items : "${domain}:${application_filter_name}" => { id = application_filter_values.id, type = application_filter_values.type }
      }
    ]...),
  )
}

######
### map_time_ranges
######
locals {
  map_time_ranges = merge(

    # Time ranges - bulk mode outputs
    local.time_ranges_bulk ? merge([
      for domain, time_ranges in fmc_time_ranges.time_ranges : {
        for time_range_name, time_range_values in time_ranges.items : "${domain}:${time_range_name}" => { id = time_range_values.id, type = time_range_values.type }
      }
    ]...) : {},

    # Time ranges - individual mode outputs
    !local.time_ranges_bulk ? { for key, resource in fmc_time_range.time_range : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Time ranges - data sources
    merge([
      for domain, time_ranges in data.fmc_time_ranges.time_ranges : {
        for time_range_name, time_range_values in time_ranges.items : "${domain}:${time_range_name}" => { id = time_range_values.id, type = time_range_values.type }
      }
    ]...),
  )
}

######
### map_ipv4_address_pools
######
locals {
  map_ipv4_address_pools = merge(

    # IPv4 Address Pools - bulk mode outputs
    local.ipv4_address_pools_bulk ? merge([
      for domain, ipv4_address_pools in fmc_ipv4_address_pools.ipv4_address_pools : {
        for ipv4_address_pool_name, ipv4_address_pool_values in ipv4_address_pools.items : "${domain}:${ipv4_address_pool_name}" => { id = ipv4_address_pool_values.id, type = ipv4_address_pool_values.type }
      }
    ]...) : {},

    # IPv4 Address Pools - individual mode outputs
    !local.ipv4_address_pools_bulk ? { for key, resource in fmc_ipv4_address_pool.ipv4_address_pool : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IPv4 Address Pools - data sources
    merge([
      for domain, ipv4_address_pools in data.fmc_ipv4_address_pools.ipv4_address_pools : {
        for ipv4_address_pool_name, ipv4_address_pool_values in ipv4_address_pools.items : "${domain}:${ipv4_address_pool_name}" => { id = ipv4_address_pool_values.id, type = ipv4_address_pool_values.type }
      }
    ]...)
  )
}

######
### map_ipv6_address_pools
######
locals {
  map_ipv6_address_pools = merge(

    # IPv6 Address Pools - bulk mode outputs
    local.ipv6_address_pools_bulk ? merge([
      for domain, ipv6_address_pools in fmc_ipv6_address_pools.ipv6_address_pools : {
        for ipv6_address_pool_name, ipv6_address_pool_values in ipv6_address_pools.items : "${domain}:${ipv6_address_pool_name}" => { id = ipv6_address_pool_values.id, type = ipv6_address_pool_values.type }
      }
    ]...) : {},

    # IPv6 Address Pools - individual mode outputs
    !local.ipv6_address_pools_bulk ? { for key, resource in fmc_ipv6_address_pool.ipv6_address_pool : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IPv6 Address Pools - data sources
    merge([
      for domain, ipv6_address_pools in data.fmc_ipv6_address_pools.ipv6_address_pools : {
        for ipv6_address_pool_name, ipv6_address_pool_values in ipv6_address_pools.items : "${domain}:${ipv6_address_pool_name}" => { id = ipv6_address_pool_values.id, type = ipv6_address_pool_values.type }
      }
    ]...)
  )
}

######
### map_resource_profiles
######
locals {
  map_resource_profiles = merge(

    # Resource Profiles - bulk mode outputs
    local.resource_profiles_bulk ? merge([
      for domain, resource_profiles in fmc_resource_profiles.resource_profiles : {
        for resource_profile_name, resource_profile_values in resource_profiles.items : "${domain}:${resource_profile_name}" => { id = resource_profile_values.id, type = resource_profile_values.type }
      }
    ]...) : {},

    # Resource Profiles - individual mode outputs
    !local.resource_profiles_bulk ? { for key, resource in fmc_resource_profile.resource_profile : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Resource Profiles - data sources
    merge([
      for domain, resource_profiles in data.fmc_resource_profiles.resource_profiles : {
        for resource_profile_name, resource_profile_values in resource_profiles.items : "${domain}:${resource_profile_name}" => { id = resource_profile_values.id, type = resource_profile_values.type }
      }
    ]...),
  )
}

######
### map_as_paths
######
locals {
  map_as_paths = merge(

    # As Paths - bulk mode outputs
    local.as_paths_bulk ? merge([
      for domain, as_paths in fmc_as_paths.as_paths : {
        for as_path_name, as_path_values in as_paths.items : "${domain}:${as_path_name}" => { id = as_path_values.id, type = as_path_values.type }
      }
    ]...) : {},

    # As Paths - individual mode outputs
    !local.as_paths_bulk ? { for key, resource in fmc_as_path.as_path : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # As Paths - data sources
    merge([
      for domain, as_paths in data.fmc_as_paths.as_paths : {
        for as_path_name, as_path_values in as_paths.items : "${domain}:${as_path_name}" => { id = as_path_values.id, type = as_path_values.type }
      }
    ]...),
  )
}

######
### map_standard_access_lists
######
locals {
  map_standard_access_lists = merge(

    # Standard Access Lists - individual mode outputs
    { for key, resource in fmc_standard_access_list.standard_access_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Standard Access Lists - data sources
    merge([
      for domain, standard_acls in data.fmc_standard_access_list.standard_access_list : {
        for standard_acl_name, standard_acl_values in standard_acls.items : "${domain}:${standard_acl_name}" => { id = standard_acl_values.id, type = standard_acl_values.type }
      }
    ]...)
  )
}

######
### map_extended_access_lists
######
locals {
  map_extended_access_lists = merge(

    # Extended Access Lists - individual mode outputs
    { for key, resource in fmc_extended_access_list.extended_access_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Extended Access Lists - data sources
    merge([
      for domain, extended_acls in data.fmc_extended_access_list.extended_access_list : {
        for extended_acl_name, extended_acl_values in extended_acls.items : "${domain}:${extended_acl_name}" => { id = extended_acl_values.id, type = extended_acl_values.type }
      }
    ]...)
  )
}

######
### map_access_lists
######
locals {
  map_access_lists = merge(
    local.map_standard_access_lists,
    local.map_extended_access_lists,
  )
}

######
### map_bfd_templates
######
locals {
  map_bfd_templates = merge(

    # BFD Templates - bulk mode outputs
    local.bfd_templates_bulk ? merge([
      for domain, bfd_templates in fmc_bfd_templates.bfd_templates : {
        for bfd_template_name, bfd_template_values in bfd_templates.items : "${domain}:${bfd_template_name}" => { id = bfd_template_values.id, type = bfd_template_values.type }
      }
    ]...) : {},

    # BFD Templates - individual mode outputs
    !local.bfd_templates_bulk ? { for key, resource in fmc_bfd_template.bfd_template : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # BFD Templates - data sources
    merge([
      for domain, bfd_templates in data.fmc_bfd_templates.bfd_templates : {
        for bfd_template_name, bfd_template_values in bfd_templates.items : "${domain}:${bfd_template_name}" => { id = bfd_template_values.id, type = bfd_template_values.type }
      }
    ]...),
  )
}

######
### map_variable_sets
######
locals {
  map_variable_sets = merge(

    # Variable Sets - data sources
    { for key, resource in data.fmc_variable_set.variable_set : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },
  )
}

######
### map_ipv4_prefix_lists
######
locals {
  map_ipv4_prefix_lists = merge(

    # IPv4 Prefix Lists - bulk mode outputs
    local.ipv4_prefix_lists_bulk ? merge([
      for domain, ipv4_prefix_lists in fmc_ipv4_prefix_lists.ipv4_prefix_lists : {
        for ipv4_prefix_list_name, ipv4_prefix_list_values in ipv4_prefix_lists.items : "${domain}:${ipv4_prefix_list_name}" => { id = ipv4_prefix_list_values.id, type = ipv4_prefix_list_values.type }
      }
    ]...) : {},

    # IPv4 Prefix Lists - individual mode outputs
    !local.ipv4_prefix_lists_bulk ? { for key, resource in fmc_ipv4_prefix_list.ipv4_prefix_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IPv4 Prefix Lists - data sources
    merge([
      for domain, ipv4_prefix_lists in data.fmc_ipv4_prefix_lists.ipv4_prefix_lists : {
        for ipv4_prefix_list_name, ipv4_prefix_list_values in ipv4_prefix_lists.items : "${domain}:${ipv4_prefix_list_name}" => { id = ipv4_prefix_list_values.id, type = ipv4_prefix_list_values.type }
      }
    ]...)
  )
}

######
### map_ipv6_prefix_lists
######
locals {
  map_ipv6_prefix_lists = merge(

    # IPv6 Prefix Lists - bulk mode outputs
    local.ipv6_prefix_lists_bulk ? merge([
      for domain, ipv6_prefix_lists in fmc_ipv6_prefix_lists.ipv6_prefix_lists : {
        for ipv6_prefix_list_name, ipv6_prefix_list_values in ipv6_prefix_lists.items : "${domain}:${ipv6_prefix_list_name}" => { id = ipv6_prefix_list_values.id, type = ipv6_prefix_list_values.type }
      }
    ]...) : {},

    # IPv6 Prefix Lists - individual mode outputs
    !local.ipv6_prefix_lists_bulk ? { for key, resource in fmc_ipv6_prefix_list.ipv6_prefix_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IPv6 Prefix Lists - data sources
    merge([
      for domain, ipv6_prefix_lists in data.fmc_ipv6_prefix_lists.ipv6_prefix_lists : {
        for ipv6_prefix_list_name, ipv6_prefix_list_values in ipv6_prefix_lists.items : "${domain}:${ipv6_prefix_list_name}" => { id = ipv6_prefix_list_values.id, type = ipv6_prefix_list_values.type }
      }
    ]...)
  )
}

######
### map_community_lists
######
locals {
  map_community_lists = merge(

    # Standard Community Lists - bulk mode outputs
    local.standard_community_lists_bulk ? merge([
      for domain, standard_community_lists in fmc_standard_community_lists.standard_community_lists : {
        for standard_community_list_name, standard_community_list_values in standard_community_lists.items : "${domain}:${standard_community_list_name}" => { id = standard_community_list_values.id, type = standard_community_list_values.type }
      }
    ]...) : {},

    # Standard Community Lists - individual mode outputs
    !local.standard_community_lists_bulk ? { for key, resource in fmc_standard_community_list.standard_community_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Standard Community Lists - data sources
    merge([
      for domain, standard_community_lists in data.fmc_standard_community_lists.standard_community_lists : {
        for standard_community_list_name, standard_community_list_values in standard_community_lists.items : "${domain}:${standard_community_list_name}" => { id = standard_community_list_values.id, type = standard_community_list_values.type }
      }
    ]...),

    # Expanded Community Lists - bulk mode outputs
    local.expanded_community_lists_bulk ? merge([
      for domain, expanded_community_lists in fmc_expanded_community_lists.expanded_community_lists : {
        for expanded_community_list_name, expanded_community_list_values in expanded_community_lists.items : "${domain}:${expanded_community_list_name}" => { id = expanded_community_list_values.id, type = expanded_community_list_values.type }
      }
    ]...) : {},

    # Expanded Community Lists - individual mode outputs
    !local.expanded_community_lists_bulk ? { for key, resource in fmc_expanded_community_list.expanded_community_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Expanded Community Lists - data sources
    merge([
      for domain, expanded_community_lists in data.fmc_expanded_community_lists.expanded_community_lists : {
        for expanded_community_list_name, expanded_community_list_values in expanded_community_lists.items : "${domain}:${expanded_community_list_name}" => { id = expanded_community_list_values.id, type = expanded_community_list_values.type }
      }
    ]...)
  )
}

######
### map_extended_community_lists
######
locals {
  map_extended_community_lists = merge(

    # Extended Community Lists - bulk mode outputs
    local.extended_community_lists_bulk ? merge([
      for domain, extended_community_lists in fmc_extended_community_lists.extended_community_lists : {
        for extended_community_list_name, extended_community_list_values in extended_community_lists.items : "${domain}:${extended_community_list_name}" => { id = extended_community_list_values.id, type = extended_community_list_values.type }
      }
    ]...) : {},

    # Extended Community Lists - individual mode outputs
    !local.extended_community_lists_bulk ? { for key, resource in fmc_extended_community_list.extended_community_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Extended Community Lists - data sources
    merge([
      for domain, extended_community_lists in data.fmc_extended_community_lists.extended_community_lists : {
        for extended_community_list_name, extended_community_list_values in extended_community_lists.items : "${domain}:${extended_community_list_name}" => { id = extended_community_list_values.id, type = extended_community_list_values.type }
      }
    ]...),
  )
}

######
### map_policy_lists
######
locals {
  map_policy_lists = merge(

    # Policy lists - bulk mode outputs
    local.policy_lists_bulk ? merge([
      for domain, policy_lists in fmc_policy_lists.policy_lists : {
        for policy_list_name, policy_list_values in policy_lists.items : "${domain}:${policy_list_name}" => { id = policy_list_values.id, type = policy_list_values.type }
      }
    ]...) : {},

    # Policy lists - individual mode outputs
    !local.policy_lists_bulk ? { for key, resource in fmc_policy_list.policy_list : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Policy lists - data sources
    merge([
      for domain, policy_lists in data.fmc_policy_lists.policy_lists : {
        for policy_list_name, policy_list_values in policy_lists.items : "${domain}:${policy_list_name}" => { id = policy_list_values.id, type = policy_list_values.type }
      }
    ]...),
  )
}

######
### map_route_maps
######
locals {
  map_route_maps = merge(

    # Route Maps - individual mode outputs
    { for key, resource in fmc_route_map.route_map : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Route Maps - data sources
    { for key, data_source in data.fmc_route_map.route_map : "${data_source.domain}:${data_source.name}" => { id = data_source.id, type = data_source.type } },
  )
}

######
### map_geolocation_sources
######
locals {
  map_geolocation_sources = merge(

    # Countries - data sources
    merge([
      for domain, countries in data.fmc_countries.countries : {
        for country_name, country_values in countries.items : "${domain}:${country_name}" => { id = country_values.id, type = country_values.type }
      }
    ]...),

    # Continents - data sources
    merge([
      for domain, continents in data.fmc_continents.continents : {
        for continent_name, continent_values in continents.items : "${domain}:${continent_name}" => { id = continent_values.id, type = continent_values.type }
      }
    ]...),

    # Geolocations - bulk mode outputs
    local.geolocations_bulk ? merge([
      for domain, geolocations in fmc_geolocations.geolocations : {
        for geolocation_name, geolocation_values in geolocations.items : "${domain}:${geolocation_name}" => { id = geolocation_values.id, type = geolocation_values.type }
      }
    ]...) : {},

    # Geolocations - individual mode outputs
    !local.geolocations_bulk ? { for key, resource in fmc_geolocation.geolocation : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # Geolocations - data sources
    merge([
      for domain, geolocations in data.fmc_geolocations.geolocations : {
        for geolocation_name, geolocation_values in geolocations.items : "${domain}:${geolocation_name}" => { id = geolocation_values.id, type = geolocation_values.type }
      }
    ]...),
  )
}

######
### map_ikev1_policies
######
locals {
  map_ikev1_policies = merge(

    # IKEv1 Policies - bulk mode outputs
    merge([
      for domain, ikev1_policies in fmc_ikev1_policies.ikev1_policies : {
        for ikev1_policy_name, ikev1_policy_values in ikev1_policies.items : "${domain}:${ikev1_policy_name}" => { id = ikev1_policy_values.id, type = ikev1_policy_values.type }
      }
    ]...),

    # IKEv1 Policies - individual mode outputs
    !local.ikev1_policies_bulk ? { for key, resource in fmc_ikev1_policy.ikev1_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IKEv1 Policies - data sources
    merge([
      for domain, ikev1_policies in data.fmc_ikev1_policies.ikev1_policies : {
        for ikev1_policy_name, ikev1_policy_values in ikev1_policies.items : "${domain}:${ikev1_policy_name}" => { id = ikev1_policy_values.id, type = ikev1_policy_values.type }
      }
    ]...),
  )
}

######
### map_ikev2_policies
######
locals {
  map_ikev2_policies = merge(

    # IKEv2 Policies - bulk mode outputs
    merge([
      for domain, ikev2_policies in fmc_ikev2_policies.ikev2_policies : {
        for ikev2_policy_name, ikev2_policy_values in ikev2_policies.items : "${domain}:${ikev2_policy_name}" => { id = ikev2_policy_values.id, type = ikev2_policy_values.type }
      }
    ]...),

    # IKEv2 Policies - individual mode outputs
    !local.ikev2_policies_bulk ? { for key, resource in fmc_ikev2_policy.ikev2_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IKEv2 Policies - data sources
    merge([
      for domain, ikev2_policies in data.fmc_ikev2_policies.ikev2_policies : {
        for ikev2_policy_name, ikev2_policy_values in ikev2_policies.items : "${domain}:${ikev2_policy_name}" => { id = ikev2_policy_values.id, type = ikev2_policy_values.type }
      }
    ]...),
  )
}

######
### map_ikev1_ipsec_proposals
######
locals {
  map_ikev1_ipsec_proposals = merge(

    # IKEv1 IPsec Proposals - bulk mode outputs
    merge([
      for domain, ikev1_ipsec_proposals in fmc_ikev1_ipsec_proposals.ikev1_ipsec_proposals : {
        for ikev1_ipsec_proposal_name, ikev1_ipsec_proposal_values in ikev1_ipsec_proposals.items : "${domain}:${ikev1_ipsec_proposal_name}" => { id = ikev1_ipsec_proposal_values.id, type = ikev1_ipsec_proposal_values.type }
      }
    ]...),

    # IKEv1 IPsec Proposals - individual mode outputs
    !local.ikev1_ipsec_proposals_bulk ? { for key, resource in fmc_ikev1_ipsec_proposal.ikev1_ipsec_proposal : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IKEv1 IPsec Proposals - data sources
    merge([
      for domain, ikev1_policies in data.fmc_ikev1_ipsec_proposals.ikev1_ipsec_proposals : {
        for ikev1_policy_name, ikev1_policy_values in ikev1_policies.items : "${domain}:${ikev1_policy_name}" => { id = ikev1_policy_values.id, type = ikev1_policy_values.type }
      }
    ]...),
  )
}

######
### map_ikev2_ipsec_proposals
######
locals {
  map_ikev2_ipsec_proposals = merge(

    # IKEv2 IPsec Proposals - bulk mode outputs
    merge([
      for domain, ikev2_ipsec_proposals in fmc_ikev2_ipsec_proposals.ikev2_ipsec_proposals : {
        for ikev2_ipsec_proposal_name, ikev2_ipsec_proposal_values in ikev2_ipsec_proposals.items : "${domain}:${ikev2_ipsec_proposal_name}" => { id = ikev2_ipsec_proposal_values.id, type = ikev2_ipsec_proposal_values.type }
      }
    ]...),

    # IKEv2 IPsec Proposals - individual mode outputs
    !local.ikev2_ipsec_proposals_bulk ? { for key, resource in fmc_ikev2_ipsec_proposal.ikev2_ipsec_proposal : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } } : {},

    # IKEv2 IPsec Proposals - data sources
    merge([
      for domain, ikev2_policies in data.fmc_ikev2_ipsec_proposals.ikev2_ipsec_proposals : {
        for ikev2_policy_name, ikev2_policy_values in ikev2_policies.items : "${domain}:${ikev2_policy_name}" => { id = ikev2_policy_values.id, type = ikev2_policy_values.type }
      }
    ]...),
  )
}

######
### map_certiticate_enrollments
######
locals {
  map_certificate_enrollments = merge(

    # Certificate Enrollments - individual mode outputs
    { for key, resource in fmc_certificate_enrollment.certificate_enrollment : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, name = resource.name } },

    # Certificate Enrollments ACME - individual mode outputs
    { for key, resource in fmc_certificate_enrollment.certificate_enrollment_acme : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, name = resource.name } },

    # Certificate Enrollments - data sources
    { for key, data_source in data.fmc_certificate_enrollment.certificate_enrollment : "${data_source.domain}:${data_source.name}" => { id = data_source.id, type = data_source.type, name = data_source.name } },
  )
}

######
### map_trusted_certificate_authorities
######
locals {
  map_trusted_certificate_authorities = merge(

    # Trusted Certificate Authorities - individual mode outputs
    { for key, resource in fmc_trusted_certificate_authority.trusted_certificate_authority : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Trusted Certificate Authorities - data sources
    { for key, data_source in data.fmc_trusted_certificate_authority.trusted_certificate_authority : "${data_source.domain}:${data_source.name}" => { id = data_source.id, type = data_source.type } },
  )
}

######
### FAKE - TODO
######
locals {
  map_url_categories  = {}
  map_ipv6_dhcp_pools = {}
}
