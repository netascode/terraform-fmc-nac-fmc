##########################################################
###    HOSTS
##########################################################
locals {
  data_hosts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for host in try(domain.objects.hosts, []) : host.name => {}
      }
    } if length(try(domain.objects.hosts, [])) > 0
  }

  hosts_bulk = try(local.fmc.nac_configuration.hosts_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  # Create a map, key is domain name, value is list of hosts for that domain
  resource_hosts = {
    for domain in local.domains : domain.name => [
      for host in try(domain.objects.hosts, []) : {
        domain      = domain.name
        name        = host.name
        ip          = lower(host.ip)
        description = try(host.description, local.defaults.fmc.domains.objects.hosts.description, null)
        overridable = try(host.overridable, local.defaults.fmc.domains.objects.hosts.overridable, null)
      } if !contains(try(keys(local.data_hosts[domain.name].items), []), host.name)
    ] if length(try(domain.objects.hosts, [])) > 0
  }

  # Convert the map for need of individual host resources
  resource_host = !local.hosts_bulk ? {
    for item in flatten([
      for domain, hosts in local.resource_hosts : [
        for host in hosts : {
          key  = "${domain}:${host.name}"
          item = host
        }
      ]
    ]) : item.key => item
  } : {}
}

# Data source to get existing hosts
data "fmc_hosts" "hosts" {
  for_each = local.data_hosts

  items  = each.value.items
  domain = each.key
}

# Handle bulk mode (resource per domain)
resource "fmc_hosts" "hosts" {
  for_each = local.hosts_bulk ? local.resource_hosts : {}

  domain = each.key
  items  = { for host in each.value : host.name => host }
}

# Handle individual mode (resource per host) 
resource "fmc_host" "host" {
  for_each = !local.hosts_bulk ? local.resource_host : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  ip          = each.value.item.ip
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    NETWORKS
##########################################################
locals {
  data_networks = {
    for domain in local.data_existing : domain.name => {
      items = {
        for network in try(domain.objects.networks, []) : network.name => {}
      }
    } if length(try(domain.objects.networks, [])) > 0
  }

  networks_bulk = try(local.fmc.nac_configuration.networks_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_networks = {
    for domain in local.domains : domain.name => [
      for network in try(domain.objects.networks, []) : {
        domain      = domain.name
        name        = network.name
        prefix      = lower(network.prefix)
        description = try(network.description, local.defaults.fmc.domains.objects.networks.description, null)
        overridable = try(network.overridable, local.defaults.fmc.domains.objects.networks.overridable, null)
      } if !contains(try(keys(local.data_networks[domain.name].items), []), network.name)
    ] if length(try(domain.objects.networks, [])) > 0
  }

  resource_network = !local.networks_bulk ? {
    for item in flatten([
      for domain, networks in local.resource_networks : [
        for network in networks : {
          key  = "${domain}:${network.name}"
          item = network
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_networks" "networks" {
  for_each = local.data_networks

  items  = each.value.items
  domain = each.key
}

resource "fmc_networks" "networks" {
  for_each = local.networks_bulk ? local.resource_networks : {}

  domain = each.key
  items  = { for network in each.value : network.name => network }
}

resource "fmc_network" "network" {
  for_each = !local.networks_bulk ? local.resource_network : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  prefix      = each.value.item.prefix
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    RANGES
##########################################################
locals {
  data_ranges = {
    for domain in local.data_existing : domain.name => {
      items = {
        for range in try(domain.objects.ranges, []) : range.name => {}
      }
    } if length(try(domain.objects.ranges, [])) > 0
  }

  ranges_bulk = try(local.fmc.nac_configuration.ranges_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ranges = {
    for domain in local.domains : domain.name => [
      for range in try(domain.objects.ranges, []) : {
        domain      = domain.name
        name        = range.name
        ip_range    = range.ip_range
        description = try(range.description, local.defaults.fmc.domains.objects.ranges.description, null)
        overridable = try(range.overridable, local.defaults.fmc.domains.objects.ranges.overridable, null)
      } if !contains(try(keys(local.data_ranges[domain.name].items), []), range.name)
    ] if length(try(domain.objects.ranges, [])) > 0
  }

  resource_range = !local.ranges_bulk ? {
    for item in flatten([
      for domain, ranges in local.resource_ranges : [
        for range in ranges : {
          key  = "${domain}:${range.name}"
          item = range
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ranges" "ranges" {
  for_each = local.data_ranges

  items  = each.value.items
  domain = each.key
}

resource "fmc_ranges" "ranges" {
  for_each = local.ranges_bulk ? local.resource_ranges : {}

  domain = each.key
  items  = { for range in each.value : range.name => range }
}

resource "fmc_range" "range" {
  for_each = !local.ranges_bulk ? local.resource_range : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  ip_range    = each.value.item.ip_range
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    FQDNS
##########################################################
locals {
  data_fqdns = {
    for domain in local.data_existing : domain.name => {
      items = {
        for fqdn in try(domain.objects.fqdns, []) : fqdn.name => {}
      }
    } if length(try(domain.objects.fqdns, [])) > 0
  }

  fqdns_bulk = try(local.fmc.nac_configuration.fqdns_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_fqdns = {
    for domain in local.domains : domain.name => [
      for fqdn in try(domain.objects.fqdns, []) : {
        domain         = domain.name
        name           = fqdn.name
        fqdn           = fqdn.fqdn
        description    = try(fqdn.description, local.defaults.fmc.domains.objects.fqdns.description, null)
        dns_resolution = try(fqdn.dns_resolution, local.defaults.fmc.domains.objects.fqdns.dns_resolution, null)
        overridable    = try(fqdn.overridable, local.defaults.fmc.domains.objects.fqdns.overridable, null)
      } if !contains(try(keys(local.data_fqdns[domain.name].items), []), fqdn.name)
    ] if length(try(domain.objects.fqdns, [])) > 0
  }

  resource_fqdn = !local.fqdns_bulk ? {
    for item in flatten([
      for domain, fqdns in local.resource_fqdns : [
        for fqdn in fqdns : {
          key  = "${domain}:${fqdn.name}"
          item = fqdn
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_fqdns" "fqdns" {
  for_each = local.data_fqdns

  items  = each.value.items
  domain = each.key
}

resource "fmc_fqdns" "fqdns" {
  for_each = local.fqdns_bulk ? local.resource_fqdns : {}

  domain = each.key
  items  = { for fqdn in each.value : fqdn.name => fqdn }
}

resource "fmc_fqdn" "fqdn" {
  for_each = !local.fqdns_bulk ? local.resource_fqdn : {}

  domain         = each.value.item.domain
  name           = each.value.item.name
  fqdn           = each.value.item.fqdn
  description    = each.value.item.description
  dns_resolution = each.value.item.dns_resolution
  overridable    = each.value.item.overridable
}

##########################################################
###    NETWORK GROUPS
##########################################################
locals {
  data_network_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for network_group in try(domain.objects.network_groups, []) : network_group.name => {}
      }
    } if length(try(domain.objects.network_groups, [])) > 0
  }

  # Helper list of all network object names and network group data source names
  help_network_objects = flatten([
    flatten([for item in keys(local.map_network_objects) : item]),
    flatten([for domain in keys(local.data_network_groups) : [for k in keys(local.data_network_groups[domain].items) : "${domain}:${k}"]])
  ])

  resource_network_groups = {
    for domain in local.domains : domain.name => {
      for network_group in try(domain.objects.network_groups, {}) : network_group.name => {
        name   = network_group.name
        domain = domain.name
        literals = [for literal in try(network_group.literals, []) : {
          value = literal
        }]
        objects = [for object_item in try(network_group.objects, []) : {
          id = try(
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${object_item}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${object_item}")
            })[0],
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_network_groups.network_groups[domain_path].items[object_item].id
              if contains(keys(try(data.fmc_network_groups.network_groups[domain_path].items, {})), object_item)
            })[0],
          )
          name = object_item
          } if anytrue([
            for domain_path in local.related_domains[domain.name] :
            contains(local.help_network_objects, "${domain_path}:${object_item}")
          ])
        ]
        network_groups = [for object_item in try(network_group.objects, []) : object_item if !anytrue([
          for domain_path in local.related_domains[domain.name] :
          contains(local.help_network_objects, "${domain_path}:${object_item}")
        ])]
        description = try(network_group.description, local.defaults.fmc.domains.objects.network_groups.description, null)
        overridable = try(network_group.overridable, local.defaults.fmc.domains.objects.network_groups.overridable, null)
      } if !contains(try(keys(local.data_network_groups[domain.name].items), []), network_group.name)
    } if length(try(domain.objects.network_groups, [])) > 0
  }
}

data "fmc_network_groups" "network_groups" {
  for_each = local.data_network_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_network_groups" "network_groups" {
  for_each = local.resource_network_groups

  domain = each.key
  items  = { for network_group in each.value : network_group.name => network_group }
}

##########################################################
###    PORTS
##########################################################
locals {
  data_ports = {
    for domain in local.data_existing : domain.name => {
      items = {
        for port in try(domain.objects.ports, []) : port.name => {}
      }
    } if length(try(domain.objects.ports, [])) > 0
  }

  ports_bulk = try(local.fmc.nac_configuration.ports_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ports = {
    for domain in local.domains : domain.name => {
      for port in try(domain.objects.ports, []) : port.name => {
        domain      = domain.name
        name        = port.name
        protocol    = port.protocol
        port        = try(port.port, null)
        description = try(port.description, local.defaults.fmc.domains.objects.ports.description, null)
        overridable = try(port.overridable, local.defaults.fmc.domains.objects.ports.overridable, null)
      } if !contains(try(keys(local.data_ports[domain.name].items), []), port.name)
    } if length(try(domain.objects.ports, [])) > 0
  }

  resource_port = !local.ports_bulk ? {
    for item in flatten([
      for domain, ports in local.resource_ports : [
        for port in values(ports) : {
          key  = "${domain}:${port.name}"
          item = port
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_ports" "ports" {
  for_each = local.data_ports

  items  = each.value.items
  domain = each.key
}

resource "fmc_ports" "ports" {
  for_each = local.ports_bulk ? local.resource_ports : {}

  domain = each.key
  items  = { for port in values(each.value) : port.name => port }
}

resource "fmc_port" "port" {
  for_each = !local.ports_bulk ? local.resource_port : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  protocol    = each.value.item.protocol
  port        = each.value.item.port
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    ICMPv4s
##########################################################
locals {
  data_icmpv4s = {
    for domain in local.data_existing : domain.name => {
      items = {
        for icmpv4 in try(domain.objects.icmpv4s, []) : icmpv4.name => {}
      }
    } if length(try(domain.objects.icmpv4s, [])) > 0
  }

  icmpv4s_bulk = try(local.fmc.nac_configuration.icmpv4s_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_icmpv4s = {
    for domain in local.domains : domain.name => {
      for icmpv4 in try(domain.objects.icmpv4s, []) : icmpv4.name => {
        domain      = domain.name
        name        = icmpv4.name
        icmp_type   = try(icmpv4.icmp_type, null)
        code        = try(icmpv4.code, null)
        description = try(icmpv4.description, local.defaults.fmc.domains.objects.icmpv4s.description, null)
        overridable = try(icmpv4.overridable, local.defaults.fmc.domains.objects.icmpv4s.overridable, null)
      } if !contains(try(keys(local.data_icmpv4s[domain.name].items), []), icmpv4.name)
    } if length(try(domain.objects.icmpv4s, [])) > 0
  }

  resource_icmpv4 = !local.icmpv4s_bulk ? {
    for item in flatten([
      for domain, icmpv4s in local.resource_icmpv4s : [
        for icmpv4 in values(icmpv4s) : {
          key  = "${domain}:${icmpv4.name}"
          item = icmpv4
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_icmpv4s" "icmpv4s" {
  for_each = local.data_icmpv4s

  items  = each.value.items
  domain = each.key
}

resource "fmc_icmpv4s" "icmpv4s" {
  for_each = local.icmpv4s_bulk ? local.resource_icmpv4s : {}

  domain = each.key
  items  = { for icmpv4 in values(each.value) : icmpv4.name => icmpv4 }
}

resource "fmc_icmpv4" "icmpv4" {
  for_each = !local.icmpv4s_bulk ? local.resource_icmpv4 : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  icmp_type   = each.value.item.icmp_type
  code        = each.value.item.code
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    PORT GROUPS
##########################################################
locals {
  data_port_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for port_group in try(domain.objects.port_groups, []) : port_group.name => {}
      }
    } if length(try(domain.objects.port_groups, [])) > 0
  }

  port_groups_bulk = try(local.fmc.nac_configuration.port_groups_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_port_groups = {
    for domain in local.domains : domain.name => {
      for port_group in try(domain.objects.port_groups, {}) : port_group.name => {
        domain = domain.name
        name   = port_group.name
        objects = [for object_item in try(port_group.objects, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_services["${domain_path}:${object_item}"].id
            if contains(keys(local.map_services), "${domain_path}:${object_item}")
          })[0]
          type = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_services["${domain_path}:${object_item}"].type
            if contains(keys(local.map_services), "${domain_path}:${object_item}")
          })[0]
        }]
        description = try(port_group.description, local.defaults.fmc.domains.objects.port_groups.description, null)
        overridable = try(port_group.overridable, local.defaults.fmc.domains.objects.port_groups.overridable, null)
      } if !contains(try(keys(local.data_port_groups[domain.name].items), []), port_group.name)
    } if length(try(domain.objects.port_groups, [])) > 0
  }

  resource_port_group = !local.port_groups_bulk ? {
    for item in flatten([
      for domain, port_groups in local.resource_port_groups : [
        for port_group in values(port_groups) : {
          key  = "${domain}:${port_group.name}"
          item = port_group
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_port_groups" "port_groups" {
  for_each = local.data_port_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_port_groups" "port_groups" {
  for_each = local.port_groups_bulk ? local.resource_port_groups : {}

  domain = each.key
  items  = { for port_group in values(each.value) : port_group.name => port_group }
}

resource "fmc_port_group" "port_group" {
  for_each = !local.port_groups_bulk ? local.resource_port_group : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  objects     = each.value.item.objects
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    DYNAMIC OBJECTS
##########################################################
locals {
  data_dynamic_objects = {
    for domain in local.data_existing : domain.name => {
      items = {
        for dynamic_object in try(domain.objects.dynamic_objects, []) : dynamic_object.name => {}
      }
    } if length(try(domain.objects.dynamic_objects, [])) > 0
  }

  resource_dynamic_objects = {
    for domain in local.domains : domain.name => {
      for dynamic_object in try(domain.objects.dynamic_objects, []) : dynamic_object.name => {
        domain      = domain.name
        name        = dynamic_object.name
        object_type = try(dynamic_object.type, local.defaults.fmc.domains.objects.dynamic_objects.object_type)
        mappings    = try(dynamic_object.mappings, [])
        description = try(dynamic_object.description, local.defaults.fmc.domains.objects.dynamic_objects.description, null)
      } if !contains(try(keys(local.data_dynamic_objects[domain.name].items), []), dynamic_object.name)
    } if length(try(domain.objects.dynamic_objects, [])) > 0
  }
}

data "fmc_dynamic_objects" "dynamic_objects" {
  for_each = local.data_dynamic_objects

  items  = each.value.items
  domain = each.key
}

resource "fmc_dynamic_objects" "dynamic_objects" {
  for_each = local.resource_dynamic_objects

  domain = each.key
  items  = { for dynamic_object in each.value : dynamic_object.name => dynamic_object }
}

##########################################################
###    URLs
##########################################################
locals {
  data_urls = {
    for domain in local.data_existing : domain.name => {
      items = {
        for url in try(domain.objects.urls, []) : url.name => {}
      }
    } if length(try(domain.objects.urls, [])) > 0
  }

  urls_bulk = try(local.fmc.nac_configuration.urls_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_urls = {
    for domain in local.domains : domain.name => {
      for url in try(domain.objects.urls, []) : url.name => {
        domain      = domain.name
        name        = url.name
        url         = url.url
        description = try(url.description, local.defaults.fmc.domains.objects.urls.description, null)
        overridable = try(url.overridable, local.defaults.fmc.domains.objects.urls.overridable, null)
      } if !contains(try(keys(local.data_urls[domain.name].items), []), url.name)
    } if length(try(domain.objects.urls, [])) > 0
  }

  resource_url = !local.urls_bulk ? {
    for item in flatten([
      for domain, urls in local.resource_urls : [
        for url in values(urls) : {
          key  = "${domain}:${url.name}"
          item = url
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_urls" "urls" {
  for_each = local.data_urls

  items  = each.value.items
  domain = each.key
}

resource "fmc_urls" "urls" {
  for_each = local.urls_bulk ? local.resource_urls : {}

  domain = each.key
  items  = { for url in each.value : url.name => url }
}

resource "fmc_url" "url" {
  for_each = !local.urls_bulk ? local.resource_url : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  url         = each.value.item.url
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    URL_Groups
##########################################################
locals {
  data_url_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for url_group in try(domain.objects.url_groups, []) : url_group.name => {}
      }
    } if length(try(domain.objects.url_groups, [])) > 0
  }

  url_groups_bulk = try(local.fmc.nac_configuration.url_groups_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_url_groups = {
    for domain in local.domains : domain.name => {
      for url_group in try(domain.objects.url_groups, {}) : url_group.name => {
        domain = domain.name
        name   = url_group.name
        urls = [for url in try(url_group.urls, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_urls["${domain_path}:${url}"].id
            if contains(keys(local.map_urls), "${domain_path}:${url}")
          })[0]
        }]
        literals = [for literal_item in try(url_group.literals, []) : {
          url = literal_item
        }]
        description = try(url_group.description, local.defaults.fmc.domains.objects.url_groups.description, null)
        overridable = try(url_group.overridable, local.defaults.fmc.domains.objects.url_groups.overridable, null)
      } if !contains(try(keys(local.data_url_groups[domain.name].items), []), url_group.name)
    } if length(try(domain.objects.url_groups, [])) > 0
  }

  resource_url_group = !local.url_groups_bulk ? {
    for item in flatten([
      for domain, url_groups in local.resource_url_groups : [
        for url_group in values(url_groups) : {
          key  = "${domain}:${url_group.name}"
          item = url_group
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_url_groups" "url_groups" {
  for_each = local.data_url_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_url_groups" "url_groups" {
  for_each = local.url_groups_bulk ? local.resource_url_groups : {}

  domain = each.key
  items  = { for url_group in each.value : url_group.name => url_group }
}

resource "fmc_url_group" "url_group" {
  for_each = !local.url_groups_bulk ? local.resource_url_group : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  urls        = each.value.item.urls
  literals    = each.value.item.literals
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    VLAN Tags
##########################################################
locals {
  data_vlan_tags = {
    for domain in local.data_existing : domain.name => {
      items = {
        for vlan_tag in try(domain.objects.vlan_tags, []) : vlan_tag.name => {}
      }
    } if length(try(domain.objects.vlan_tags, [])) > 0
  }

  vlan_tags_bulk = try(local.fmc.nac_configuration.vlan_tags_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_vlan_tags = {
    for domain in local.domains : domain.name => {
      for vlan_tag in try(domain.objects.vlan_tags, []) : vlan_tag.name => {
        domain      = domain.name
        name        = vlan_tag.name
        start_tag   = vlan_tag.start_tag
        end_tag     = try(vlan_tag.end_tag, vlan_tag.start_tag)
        description = try(vlan_tag.description, local.defaults.fmc.domains.objects.vlan_tags.description, null)
        overridable = try(vlan_tag.overridable, local.defaults.fmc.domains.objects.vlan_tags.overridable, null)
      } if !contains(try(keys(local.data_vlan_tags[domain.name].items), []), vlan_tag.name)
    } if length(try(domain.objects.vlan_tags, [])) > 0
  }

  resource_vlan_tag = !local.vlan_tags_bulk ? {
    for item in flatten([
      for domain, vlan_tags in local.resource_vlan_tags : [
        for vlan_tag in values(vlan_tags) : {
          key  = "${domain}:${vlan_tag.name}"
          item = vlan_tag
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_vlan_tags" "vlan_tags" {
  for_each = local.data_vlan_tags

  items  = each.value.items
  domain = each.key
}

resource "fmc_vlan_tags" "vlan_tags" {
  for_each = local.vlan_tags_bulk ? local.resource_vlan_tags : {}

  domain = each.key
  items  = { for vlan_tag in each.value : vlan_tag.name => vlan_tag }
}

resource "fmc_vlan_tag" "vlan_tag" {
  for_each = !local.vlan_tags_bulk ? local.resource_vlan_tag : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  start_tag   = each.value.item.start_tag
  end_tag     = each.value.item.end_tag
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    VLAN TAG GROUPS
##########################################################
locals {
  data_vlan_tag_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for vlan_tag_group in try(domain.objects.vlan_tag_groups, []) : vlan_tag_group.name => {}
      }
    } if length(try(domain.objects.vlan_tag_groups, [])) > 0
  }

  vlan_tag_groups_bulk = try(local.fmc.nac_configuration.vlan_tag_groups_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_vlan_tag_groups = {
    for domain in local.domains : domain.name => {
      for vlan_tag_group in try(domain.objects.vlan_tag_groups, {}) : vlan_tag_group.name => {
        domain = domain.name
        name   = vlan_tag_group.name
        vlan_tags = [for vlan_tag in try(vlan_tag_group.vlan_tags, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_vlan_tags["${domain_path}:${vlan_tag}"].id
            if contains(keys(local.map_vlan_tags), "${domain_path}:${vlan_tag}")
          })[0]
        }]
        literals = [for literal_item in try(vlan_tag_group.literals, {}) : {
          start_tag = literal_item.start_tag
          end_tag   = try(literal_item.end_tag, literal_item.start_tag)
        }]
        description = try(vlan_tag_group.description, local.defaults.fmc.domains.objects.vlan_tag_groups.description, null)
        overridable = try(vlan_tag_group.overridable, local.defaults.fmc.domains.objects.vlan_tag_groups.overridable, null)
      } if !contains(try(keys(local.data_vlan_tag_groups[domain.name].items), []), vlan_tag_group.name)
    } if length(try(domain.objects.vlan_tag_groups, [])) > 0
  }

  resource_vlan_tag_group = !local.vlan_tag_groups_bulk ? {
    for item in flatten([
      for domain, vlan_tag_groups in local.resource_vlan_tag_groups : [
        for vlan_tag_group in values(vlan_tag_groups) : {
          key  = "${domain}:${vlan_tag_group.name}"
          item = vlan_tag_group
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_vlan_tag_groups" "vlan_tag_groups" {
  for_each = local.data_vlan_tag_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_vlan_tag_groups" "vlan_tag_groups" {
  for_each = local.vlan_tag_groups_bulk ? local.resource_vlan_tag_groups : {}

  domain = each.key
  items  = { for vlan_tag_group in each.value : vlan_tag_group.name => vlan_tag_group }
}

resource "fmc_vlan_tag_group" "vlan_tag_group" {
  for_each = !local.vlan_tag_groups_bulk ? local.resource_vlan_tag_group : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  vlan_tags   = each.value.item.vlan_tags
  literals    = each.value.item.literals
  description = each.value.item.description
  overridable = each.value.item.overridable
}

##########################################################
###    Security Group Tags (SGT)
##########################################################
locals {
  data_sgts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for sgt in try(domain.objects.sgts, []) : sgt.name => {}
      }
    } if length(try(domain.objects.sgts, [])) > 0
  }

  sgts_bulk = try(local.fmc.nac_configuration.sgts_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_sgts = {
    for domain in local.domains : domain.name => {
      for sgt in try(domain.objects.sgts, []) : sgt.name => {
        domain      = domain.name
        name        = sgt.name
        tag         = sgt.tag
        description = try(sgt.description, local.defaults.fmc.domains.objects.sgts.description, null)
      } if !contains(try(keys(local.data_sgts[domain.name].items), []), sgt.name)
    } if length(try(domain.objects.sgts, [])) > 0
  }

  resource_sgt = !local.sgts_bulk ? {
    for item in flatten([
      for domain, sgts in local.resource_sgts : [
        for sgt in values(sgts) : {
          key  = "${domain}:${sgt.name}"
          item = sgt
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_sgts" "sgts" {
  for_each = local.data_sgts

  items  = each.value.items
  domain = each.key
}

resource "fmc_sgts" "sgts" {
  for_each = local.sgts_bulk ? local.resource_sgts : {}

  domain = each.key
  items  = { for sgt in each.value : sgt.name => sgt }
}

resource "fmc_sgt" "sgt" {
  for_each = !local.sgts_bulk ? local.resource_sgt : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  tag         = each.value.item.tag
  description = each.value.item.description
}

##########################################################
###    ISE SECURITY GROUP TAGS (SGT)
##########################################################
locals {
  data_ise_sgts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ise_sgt in try(domain.objects.ise_sgts, []) : ise_sgt.name => {}
      }
    } if length(try(domain.objects.ise_sgts, [])) > 0
  }
}

data "fmc_ise_sgts" "ise_sgts" {
  for_each = local.data_ise_sgts

  items  = each.value.items
  domain = each.key
}

##########################################################
###    TUNNEL ZONES
##########################################################
locals {
  data_tunnel_zones = {
    for domain in local.data_existing : domain.name => {
      items = {
        for tunnel_zone in try(domain.objects.tunnel_zones, []) : tunnel_zone.name => {}
      }
    } if length(try(domain.objects.tunnel_zones, [])) > 0
  }

  tunnel_zones_bulk = try(local.fmc.nac_configuration.tunnel_zones_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_tunnel_zones = {
    for domain in local.domains : domain.name => {
      for tunnel_zone in try(domain.objects.tunnel_zones, []) : tunnel_zone.name => {
        domain      = domain.name
        name        = tunnel_zone.name
        description = try(tunnel_zone.description, local.defaults.fmc.domains.objects.tunnel_zones.description, null)
      } if !contains(try(keys(local.data_tunnel_zones[domain.name].items), []), tunnel_zone.name)
    } if length(try(domain.objects.tunnel_zones, [])) > 0
  }

  resource_tunnel_zone = !local.tunnel_zones_bulk ? {
    for item in flatten([
      for domain, tunnel_zones in local.resource_tunnel_zones : [
        for tunnel_zone in values(tunnel_zones) : {
          key  = "${domain}:${tunnel_zone.name}"
          item = tunnel_zone
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_tunnel_zones" "tunnel_zones" {
  for_each = local.data_tunnel_zones

  items  = each.value.items
  domain = each.key
}

resource "fmc_tunnel_zones" "tunnel_zones" {
  for_each = local.tunnel_zones_bulk ? local.resource_tunnel_zones : {}

  domain = each.key
  items  = { for tunnel_zone in each.value : tunnel_zone.name => tunnel_zone }
}

resource "fmc_tunnel_zone" "tunnel_zone" {
  for_each = !local.tunnel_zones_bulk ? local.resource_tunnel_zone : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  description = each.value.item.description
}

##########################################################
###    SECURITY ZONE
##########################################################
locals {
  data_security_zones = {
    for domain in local.data_existing : domain.name => {
      items = {
        for security_zone in try(domain.objects.security_zones, []) : security_zone.name => {}
      }
    } if length(try(domain.objects.security_zones, [])) > 0
  }

  security_zones_bulk = try(local.fmc.nac_configuration.security_zones_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_security_zones = {
    for domain in local.domains : domain.name => {
      for security_zone in try(domain.objects.security_zones, []) : security_zone.name => {
        domain         = domain.name
        name           = security_zone.name
        interface_type = try(security_zone.interface_type, local.defaults.fmc.domains.objects.security_zones.interface_type)
      } if !contains(try(keys(local.data_security_zones[domain.name].items), []), security_zone.name)
    } if length(try(domain.objects.security_zones, [])) > 0
  }

  resource_security_zone = !local.security_zones_bulk ? {
    for item in flatten([
      for domain, security_zones in local.resource_security_zones : [
        for security_zone in values(security_zones) : {
          key  = "${domain}:${security_zone.name}"
          item = security_zone
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_security_zones" "security_zones" {
  for_each = local.data_security_zones

  items  = each.value.items
  domain = each.key
}

resource "fmc_security_zones" "security_zones" {
  for_each = local.security_zones_bulk ? local.resource_security_zones : {}

  domain = each.key
  items  = { for security_zone in each.value : security_zone.name => security_zone }
}

resource "fmc_security_zone" "security_zone" {
  for_each = !local.security_zones_bulk ? local.resource_security_zone : {}

  domain         = each.value.item.domain
  name           = each.value.item.name
  interface_type = each.value.item.interface_type
}

##########################################################
###    APPLICATION FILTERS
##########################################################
locals {
  data_application_filters = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_filter in try(domain.objects.application_filters, {}) : application_filter.name => {}
      }
    } if length(try(domain.objects.application_filters, [])) > 0
  }

  application_filters_bulk = try(local.fmc.nac_configuration.application_filters_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_application_filters = {
    for domain in local.domains : domain.name => {
      for application_filter in try(domain.objects.application_filters, []) : application_filter.name => {
        domain = domain.name
        name   = application_filter.name
        applications = [for application in try(application_filter.applications, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => data.fmc_applications.applications[domain_path].items[application].id
            if try(data.fmc_applications.applications[domain_path].items[application].id, "") != ""
          })[0]
          name = application
        }]
        filters = [for filter in try(application_filter.filters, []) : {
          business_relevances = [for business_relevance in try(filter.business_relevances, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_application_business_relevances.application_business_relevances[domain_path].items[business_relevance].id
              if try(data.fmc_application_business_relevances.application_business_relevances[domain_path].items[business_relevance].id, "") != ""
            })[0]
          }]
          categories = [for category in try(filter.categories, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_application_categories.application_categories[domain_path].items[category].id
              if try(data.fmc_application_categories.application_categories[domain_path].items[category].id, "") != ""
            })[0]
          }]
          risks = [for risks in try(filter.risks, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_application_risks.application_risks[domain_path].items[risks].id
              if try(data.fmc_application_risks.application_risks[domain_path].items[risks].id, "") != ""
            })[0]
          }]
          types = [for type in try(filter.types, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_application_types.application_types[domain_path].items[type].id
              if try(data.fmc_application_types.application_types[domain_path].items[type].id, "") != ""
            })[0]
          }]
          tags = [for tag in try(filter.tags, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_application_tags.application_tags[domain_path].items[tag].id
              if try(data.fmc_application_tags.application_tags[domain_path].items[tag].id, "") != ""
            })[0]
          }]
          } if length(try(application_filter.filters, [])) > 0
        ]
      } if !contains(try(keys(local.data_application_filters[domain.name].items), []), application_filter.name)
    } if length(try(domain.objects.application_filters, [])) > 0
  }

  resource_application_filter = !local.application_filters_bulk ? {
    for item in flatten([
      for domain, application_filters in local.resource_application_filters : [
        for application_filter in application_filters : {
          key  = "${domain}:${application_filter.name}"
          item = application_filter
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_application_filters" "application_filters" {
  for_each = local.data_application_filters

  items  = each.value.items
  domain = each.key
}

resource "fmc_application_filters" "application_filters" {
  for_each = local.application_filters_bulk ? local.resource_application_filters : {}

  domain = each.key
  items  = { for application_filter in each.value : application_filter.name => application_filter }
}

resource "fmc_application_filter" "application_filter" {
  for_each = !local.application_filters_bulk ? local.resource_application_filter : {}

  domain       = each.value.item.domain
  name         = each.value.item.name
  applications = each.value.item.applications
  filters      = each.value.item.filters
}

##########################################################
###    TIME RANGES
##########################################################
locals {

  data_time_ranges = {
    for domain in local.data_existing : domain.name => {
      items = {
        for time_range in try(domain.objects.time_ranges, []) : time_range.name => {}
      }
    } if length(try(domain.objects.time_ranges, [])) > 0
  }

  time_ranges_bulk = try(local.fmc.nac_configuration.time_ranges_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_time_ranges = {
    for domain in local.domains : domain.name => [
      for time_range in try(domain.objects.time_ranges, []) : {
        domain     = domain.name
        name       = time_range.name
        start_time = try(time_range.start_time, null)
        end_time   = try(time_range.end_time, null)
        recurrence_list = [for recurrence in try(time_range.recurrences, []) : {
          recurrence_type  = recurrence.recurrence_type
          daily_days       = recurrence.recurrence_type == "DAILY_INTERVAL" ? try(recurrence.daily_days, []) : null
          daily_end_time   = try(recurrence.daily_end_time, null)
          daily_start_time = try(recurrence.daily_start_time, null)
          range_end_day    = try(recurrence.range_end_day, null)
          range_end_time   = try(recurrence.range_end_time, null)
          range_start_day  = try(recurrence.range_start_day, null)
          range_start_time = try(recurrence.range_start_time, null)
        }]
        description = try(time_range.description, local.defaults.fmc.domains.objects.time_ranges.description, null)
      } if !contains(try(keys(local.data_time_ranges[domain.name].items), []), time_range.name)
    ] if length(try(domain.objects.time_ranges, [])) > 0
  }

  resource_time_range = !local.time_ranges_bulk ? {
    for item in flatten([
      for domain, time_ranges in local.resource_time_ranges : [
        for time_range in time_ranges : {
          key  = "${domain}:${time_range.name}"
          item = time_range
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_time_ranges" "time_ranges" {
  for_each = local.data_time_ranges

  items  = each.value.items
  domain = each.key
}

resource "fmc_time_ranges" "time_ranges" {
  for_each = local.time_ranges_bulk ? local.resource_time_ranges : {}

  domain = each.key
  items  = { for time_range in each.value : time_range.name => time_range }
}

resource "fmc_time_range" "time_range" {
  for_each = !local.time_ranges_bulk ? local.resource_time_range : {}

  domain          = each.value.item.domain
  name            = each.value.item.name
  start_time      = each.value.item.start_time
  end_time        = each.value.item.end_time
  recurrence_list = each.value.item.recurrence_list
  description     = each.value.item.description
}

##########################################################
###    IPV4 ADDRESS POOLS
##########################################################
locals {
  data_ipv4_address_pools = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ipv4_address_pool in try(domain.objects.ipv4_address_pools, []) : ipv4_address_pool.name => {}
      }
    } if length(try(domain.objects.ipv4_address_pools, [])) > 0
  }

  ipv4_address_pools_bulk = try(local.fmc.nac_configuration.ipv4_address_pools_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ipv4_address_pools = {
    for domain in local.domains : domain.name => {
      for ipv4_address_pool in try(domain.objects.ipv4_address_pools, []) : ipv4_address_pool.name => {
        domain      = domain.name
        name        = ipv4_address_pool.name
        range       = ipv4_address_pool.range
        netmask     = ipv4_address_pool.netmask
        overridable = try(ipv4_address_pool.overridable, local.defaults.fmc.domains.objects.ipv4_address_pools.overridable, null)
        description = try(ipv4_address_pool.description, local.defaults.fmc.domains.objects.ipv4_address_pools.description, null)
      } if !contains(try(keys(local.data_ipv4_address_pools[domain.name].items), []), ipv4_address_pool.name)
    } if length(try(domain.objects.ipv4_address_pools, [])) > 0
  }

  resource_ipv4_address_pool = !local.ipv4_address_pools_bulk ? {
    for item in flatten([
      for domain, ipv4_address_pools in local.resource_ipv4_address_pools : [
        for ipv4_address_pool in values(ipv4_address_pools) : {
          key  = "${domain}:${ipv4_address_pool.name}"
          item = ipv4_address_pool
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ipv4_address_pools" "ipv4_address_pools" {
  for_each = local.data_ipv4_address_pools

  items  = each.value.items
  domain = each.key
}

resource "fmc_ipv4_address_pools" "ipv4_address_pools" {
  for_each = local.ipv4_address_pools_bulk ? local.resource_ipv4_address_pools : {}

  domain = each.key
  items  = { for ipv4_address_pool in each.value : ipv4_address_pool.name => ipv4_address_pool }
}

resource "fmc_ipv4_address_pool" "ipv4_address_pool" {
  for_each = !local.ipv4_address_pools_bulk ? local.resource_ipv4_address_pool : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  range       = each.value.item.range
  netmask     = each.value.item.netmask
  overridable = each.value.item.overridable
  description = each.value.item.description
}

##########################################################
###    IPV6 ADDRESS POOLS
##########################################################
locals {

  data_ipv6_address_pools = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ipv6_address_pool in try(domain.objects.ipv6_address_pools, []) : ipv6_address_pool.name => {}
      }
    } if length(try(domain.objects.ipv6_address_pools, [])) > 0
  }

  ipv6_address_pools_bulk = try(local.fmc.nac_configuration.ipv6_address_pools_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ipv6_address_pools = {
    for domain in local.domains : domain.name => {
      for ipv6_address_pool in try(domain.objects.ipv6_address_pools, []) : ipv6_address_pool.name => {
        domain              = domain.name
        name                = ipv6_address_pool.name
        start_address       = ipv6_address_pool.start_address
        number_of_addresses = ipv6_address_pool.number_of_addresses
        overridable         = try(ipv6_address_pool.overridable, local.defaults.fmc.domains.objects.ipv6_address_pools.overridable, null)
        description         = try(ipv6_address_pool.description, local.defaults.fmc.domains.objects.ipv6_address_pools.description, null)
      } if !contains(try(keys(local.data_ipv6_address_pools[domain.name].items), []), ipv6_address_pool.name)
    } if length(try(domain.objects.ipv6_address_pools, [])) > 0
  }
  resource_ipv6_address_pool = !local.ipv6_address_pools_bulk ? {
    for item in flatten([
      for domain, ipv6_address_pools in local.resource_ipv6_address_pools : [
        for ipv6_address_pool in values(ipv6_address_pools) : {
          key  = "${domain}:${ipv6_address_pool.name}"
          item = ipv6_address_pool
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ipv6_address_pools" "ipv6_address_pools" {
  for_each = local.data_ipv6_address_pools

  items  = each.value.items
  domain = each.key
}

resource "fmc_ipv6_address_pools" "ipv6_address_pools" {
  for_each = local.ipv6_address_pools_bulk ? local.resource_ipv6_address_pools : {}

  domain = each.key
  items  = { for ipv6_address_pool in each.value : ipv6_address_pool.name => ipv6_address_pool }
}

resource "fmc_ipv6_address_pool" "ipv6_address_pool" {
  for_each = !local.ipv6_address_pools_bulk ? local.resource_ipv6_address_pool : {}

  domain              = each.value.item.domain
  name                = each.value.item.name
  start_address       = each.value.item.start_address
  number_of_addresses = each.value.item.number_of_addresses
  overridable         = each.value.item.overridable
  description         = each.value.item.description
}

##########################################################
###    STANDARD ACCESS LISTS
##########################################################
locals {
  data_standard_access_list = {
    for item in flatten([
      for domain in local.data_existing : [
        for standard_access_list in try(domain.objects.standard_access_lists, {}) : {
          name   = standard_access_list.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_standard_access_list = {
    for item in flatten([
      for domain in local.domains : [
        for standard_access_list in try(domain.objects.standard_access_lists, {}) : {
          domain = domain.name
          name   = standard_access_list.name
          entries = [for entry in standard_access_list.entries : {
            action = entry.action
            literals = [for literal in try(entry.literals, []) : {
              value = literal
            }]
            objects = [for object_item in try(entry.objects, []) : {
              id = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${object_item}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${object_item}")
                })[0],
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_group_objects["${domain_path}:${object_item}"].id
                  if contains(keys(local.map_network_group_objects), "${domain_path}:${object_item}")
                })[0],
              )
              type = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${object_item}"].type
                  if contains(keys(local.map_network_objects), "${domain_path}:${object_item}")
                })[0],
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_group_objects["${domain_path}:${object_item}"].type
                  if contains(keys(local.map_network_group_objects), "${domain_path}:${object_item}")
                })[0],
              )
            }]
          }]
          description = try(standard_access_list.description, local.defaults.fmc.domains.objects.standard_access_lists.description, null)
        } if !contains(try(keys(local.data_standard_access_list), {}), "${domain.name}:${standard_access_list.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_standard_access_list" "standard_access_list" {
  for_each = local.data_standard_access_list

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_standard_access_list" "standard_access_list" {
  for_each = local.resource_standard_access_list

  domain      = each.value.domain
  name        = each.value.name
  entries     = each.value.entries
  description = each.value.description
}

##########################################################
###    EXTENDED ACCESS LISTS
##########################################################
locals {
  data_extended_access_list = {
    for item in flatten([
      for domain in local.data_existing : [
        for extended_access_list in try(domain.objects.extended_access_lists, {}) : {
          name   = extended_access_list.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_extended_access_list = {
    for item in flatten([
      for domain in local.domains : [
        for extended_access_list in try(domain.objects.extended_access_lists, {}) : {
          domain = domain.name
          name   = extended_access_list.name
          entries = [for entry in extended_access_list.entries : {
            action       = entry.action
            logging      = try(entry.logging, local.defaults.fmc.domains.objects.extended_access_lists.entries.logging)
            log_interval = try(entry.log_interval, local.defaults.fmc.domains.objects.extended_access_lists.entries.log_interval)
            log_level    = try(entry.log_level, local.defaults.fmc.domains.objects.extended_access_lists.entries.log_level)

            destination_network_literals = [for destination_network_literal in try(entry.destination_network_literals, []) : {
              value = destination_network_literal
              type  = strcontains(destination_network_literal, "/") ? "Network" : "Host"
            }]
            destination_network_objects = [for destination_network_object in try(entry.destination_network_objects, []) : {
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
            }]
            destination_port_objects = [for destination_port_object in try(entry.destination_port_objects, []) : {
              id = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_services["${domain_path}:${destination_port_object}"].id
                  if contains(keys(local.map_services), "${domain_path}:${destination_port_object}")
                })[0],
              )
            }]
            destination_port_literals = [for destination_port_literal in try(entry.destination_port_literals, []) : {
              protocol  = local.help_protocol_mapping[destination_port_literal.protocol]
              port      = try(destination_port_literal.port, null)
              icmp_type = try(destination_port_literal.icmp_type, null)
              icmp_code = try(destination_port_literal.icmp_code, null)
              type      = destination_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
            }]

            source_network_literals = [for source_network_literal in try(entry.source_network_literals, []) : {
              value = source_network_literal
              type  = strcontains(source_network_literal, "/") ? "Network" : "Host"
            }]
            source_network_objects = [for source_network_object in try(entry.source_network_objects, []) : {
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
            }]
            source_port_objects = [for source_port_object in try(entry.source_port_objects, []) : {
              id = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_services["${domain_path}:${source_port_object}"].id
                  if contains(keys(local.map_services), "${domain_path}:${source_port_object}")
                })[0],
              )
            }]
            source_port_literals = [for source_port_literal in try(entry.source_port_literals, []) : {
              protocol  = local.help_protocol_mapping[source_port_literal.protocol]
              port      = try(source_port_literal.port, null)
              icmp_type = try(source_port_literal.icmp_type, null)
              icmp_code = try(source_port_literal.icmp_code, null)
              type      = source_port_literal.protocol == "ICMP" ? "ICMPv4PortLiteral" : "PortLiteral"
            }]
            source_sgt_objects = [for source_sgt_object in try(entry.source_sgt_objects, []) : {
              id = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_sgts["${domain_path}:${source_sgt_object}"].id
                  if contains(keys(local.map_sgts), "${domain_path}:${source_sgt_object}")
                })[0],
              )
            }]
          }]
        } if !contains(try(keys(local.data_extended_access_list), {}), "${domain.name}:${extended_access_list.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_extended_access_list" "extended_access_list" {
  for_each = local.data_extended_access_list

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_extended_access_list" "extended_access_list" {
  for_each = local.resource_extended_access_list

  name    = each.value.name
  entries = each.value.entries
  domain  = each.value.domain
}

##########################################################
###    BFD TEMPLATES
##########################################################
locals {
  data_bfd_template = {
    for item in flatten([
      for domain in local.data_existing : [
        for bfd_template in try(domain.objects.bfd_templates, []) : [
          {
            name   = bfd_template.name
            domain = domain.name
        }]
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_bfd_template = {
    for item in flatten([
      for domain in local.domains : [
        for bfd_template in try(domain.objects.bfd_templates, []) : {
          domain                             = domain.name
          name                               = bfd_template.name
          hop_type                           = bfd_template.hop_type
          echo                               = bfd_template.hop_type == "SINGLE_HOP" ? try(bfd_template.echo, local.defaults.fmc.domains.objects.bfd_templates.echo) == true ? "ENABLED" : "DISABLED" : null
          interval_type                      = try(bfd_template.interval_type, null)
          multiplier                         = try(bfd_template.multiplier, null)
          minimum_transmit                   = try(bfd_template.minimum_transmit, null)
          minimum_receive                    = try(bfd_template.minimum_receive, null)
          authentication_type                = try(bfd_template.authentication_type, local.defaults.fmc.domains.objects.bfd_templates.authentication_type, null)
          authentication_password            = try(bfd_template.authentication_password, null)
          authentication_password_encryption = try(bfd_template.authentication_password_encryption, null)
          authentication_key_id              = try(bfd_template.authentication_key_id, null)
        } if !contains(try(keys(local.data_bfd_template), {}), "${domain.name}:${bfd_template.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_bfd_template" "bfd_template" {
  for_each = local.data_bfd_template

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_bfd_template" "bfd_template" {
  for_each = local.resource_bfd_template

  name                               = each.value.name
  domain                             = each.value.domain
  hop_type                           = each.value.hop_type
  echo                               = each.value.echo
  interval_type                      = each.value.interval_type
  minimum_transmit                   = each.value.minimum_transmit
  multiplier                         = each.value.multiplier
  minimum_receive                    = each.value.minimum_receive
  authentication_password            = each.value.authentication_password
  authentication_password_encryption = each.value.authentication_password_encryption
  authentication_key_id              = each.value.authentication_key_id
  authentication_type                = each.value.authentication_type
}

##########################################################
###    MAPS combine _data and _resources for a given object type
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
### map_services => Port, ICMPv4
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
### map_bfd_templates
######
locals {
  map_bfd_templates = merge(

    # BFD Templates - individual mode outputs
    { for key, resource in fmc_bfd_template.bfd_template : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # BFD Templates - data sources
    { for key, data_source in data.fmc_bfd_template.bfd_template : "${data_source.domain}:${data_source.name}" => { id = data_source.id, type = data_source.type } },
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
### FAKE - TODO
######

locals {
  map_url_categories  = {}
  map_ipv6_dhcp_pools = {}
  map_route_maps      = {}
  map_prefix_lists    = {}
}
