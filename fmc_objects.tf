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
###    ICMPv6s
##########################################################
locals {
  data_icmpv6s = {
    for domain in local.data_existing : domain.name => {
      items = {
        for icmpv6 in try(domain.objects.icmpv6s, []) : icmpv6.name => {}
      }
    } if length(try(domain.objects.icmpv6s, [])) > 0
  }

  icmpv6s_bulk = try(local.fmc.nac_configuration.icmpv6s_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_icmpv6s = {
    for domain in local.domains : domain.name => {
      for icmpv6 in try(domain.objects.icmpv6s, []) : icmpv6.name => {
        domain      = domain.name
        name        = icmpv6.name
        icmp_type   = try(icmpv6.icmp_type, null)
        code        = try(icmpv6.code, null)
        description = try(icmpv6.description, local.defaults.fmc.domains.objects.icmpv6s.description, null)
        overridable = try(icmpv6.overridable, local.defaults.fmc.domains.objects.icmpv6s.overridable, null)
      } if !contains(try(keys(local.data_icmpv6s[domain.name].items), []), icmpv6.name)
    } if length(try(domain.objects.icmpv6s, [])) > 0
  }

  resource_icmpv6 = !local.icmpv6s_bulk ? {
    for item in flatten([
      for domain, icmpv6s in local.resource_icmpv6s : [
        for icmpv6 in values(icmpv6s) : {
          key  = "${domain}:${icmpv6.name}"
          item = icmpv6
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_icmpv6s" "icmpv6s" {
  for_each = local.data_icmpv6s

  items  = each.value.items
  domain = each.key
}

resource "fmc_icmpv6s" "icmpv6s" {
  for_each = local.icmpv6s_bulk ? local.resource_icmpv6s : {}

  domain = each.key
  items  = { for icmpv6 in values(each.value) : icmpv6.name => icmpv6 }
}

resource "fmc_icmpv6" "icmpv6" {
  for_each = !local.icmpv6s_bulk ? local.resource_icmpv6 : {}

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
###    INTERFACE GROUP
##########################################################
locals {
  data_interface_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for interface_group in try(domain.objects.interface_groups, []) : interface_group.name => {}
      }
    } if length(try(domain.objects.interface_groups, [])) > 0
  }

  interface_groups_bulk = try(local.fmc.nac_configuration.interface_groups_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_interface_groups = {
    for domain in local.domains : domain.name => {
      for interface_group in try(domain.objects.interface_groups, []) : interface_group.name => {
        domain         = domain.name
        name           = interface_group.name
        interface_type = try(interface_group.interface_type, local.defaults.fmc.domains.objects.interface_groups.interface_type)
      } if !contains(try(keys(local.data_interface_groups[domain.name].items), []), interface_group.name)
    } if length(try(domain.objects.interface_groups, [])) > 0
  }

  resource_interface_group = !local.interface_groups_bulk ? {
    for item in flatten([
      for domain, interface_groups in local.resource_interface_groups : [
        for interface_group in values(interface_groups) : {
          key  = "${domain}:${interface_group.name}"
          item = interface_group
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_interface_groups" "interface_groups" {
  for_each = local.data_interface_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_interface_groups" "interface_groups" {
  for_each = local.interface_groups_bulk ? local.resource_interface_groups : {}

  domain = each.key
  items  = { for interface_group in each.value : interface_group.name => interface_group }
}

resource "fmc_interface_group" "interface_group" {
  for_each = !local.interface_groups_bulk ? local.resource_interface_group : {}

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
###    AS PATHS
##########################################################
locals {
  data_as_paths = {
    for domain in local.data_existing : domain.name => {
      items = {
        for as_path in try(domain.objects.as_paths, []) : as_path.name => {}
      }
    } if length(try(domain.objects.as_paths, [])) > 0
  }

  as_paths_bulk = try(local.fmc.nac_configuration.as_paths_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_as_paths = {
    for domain in local.domains : domain.name => [
      for as_path in try(domain.objects.as_paths, []) : {
        domain      = domain.name
        name        = as_path.name
        overridable = try(as_path.overridable, local.defaults.fmc.domains.objects.as_paths.overridable, null)
        entries = [for entry in as_path.entries : {
          action             = entry.action
          regular_expression = entry.regular_expression
        }]
      } if !contains(try(keys(local.data_as_paths[domain.name].items), []), as_path.name)
    ] if length(try(domain.objects.as_paths, [])) > 0
  }

  resource_as_path = !local.as_paths_bulk ? {
    for item in flatten([
      for domain, as_paths in local.resource_as_paths : [
        for as_path in as_paths : {
          key  = "${domain}:${as_path.name}"
          item = as_path
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_as_paths" "as_paths" {
  for_each = local.data_as_paths

  items  = each.value.items
  domain = each.key
}

resource "fmc_as_paths" "as_paths" {
  for_each = local.as_paths_bulk ? local.resource_as_paths : {}

  domain = each.key
  items  = { for as_path in each.value : as_path.name => as_path }
}

resource "fmc_as_path" "as_path" {
  for_each = !local.as_paths_bulk ? local.resource_as_path : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  overridable = each.value.item.overridable
  entries     = each.value.item.entries
}

##########################################################
###    IPv4 PREFIX LISTS
##########################################################
locals {
  data_ipv4_prefix_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ipv4_prefix_list in try(domain.objects.ipv4_prefix_lists, []) : ipv4_prefix_list.name => {}
      }
    } if length(try(domain.objects.ipv4_prefix_lists, [])) > 0
  }

  ipv4_prefix_lists_bulk = try(local.fmc.nac_configuration.ipv4_prefix_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ipv4_prefix_lists = {
    for domain in local.domains : domain.name => [
      for ipv4_prefix_list in try(domain.objects.ipv4_prefix_lists, []) : {
        domain = domain.name
        name   = ipv4_prefix_list.name
        entries = [for entry in ipv4_prefix_list.entries : {
          action            = entry.action
          prefix            = entry.prefix
          min_prefix_length = entry.min_prefix_length
          max_prefix_length = entry.max_prefix_length
        }]
      } if !contains(try(keys(local.data_ipv4_prefix_lists[domain.name].items), []), ipv4_prefix_list.name)
    ] if length(try(domain.objects.ipv4_prefix_lists, [])) > 0
  }

  resource_ipv4_prefix_list = !local.ipv4_prefix_lists_bulk ? {
    for item in flatten([
      for domain, ipv4_prefix_lists in local.resource_ipv4_prefix_lists : [
        for ipv4_prefix_list in ipv4_prefix_lists : {
          key  = "${domain}:${ipv4_prefix_list.name}"
          item = ipv4_prefix_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ipv4_prefix_lists" "ipv4_prefix_lists" {
  for_each = local.data_ipv4_prefix_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_ipv4_prefix_lists" "ipv4_prefix_lists" {
  for_each = local.ipv4_prefix_lists_bulk ? local.resource_ipv4_prefix_lists : {}

  domain = each.key
  items  = { for ipv4_prefix_list in each.value : ipv4_prefix_list.name => ipv4_prefix_list }
}

# Handle individual mode (resource per host) 
resource "fmc_ipv4_prefix_list" "ipv4_prefix_list" {
  for_each = !local.ipv4_prefix_lists_bulk ? local.resource_ipv4_prefix_list : {}

  domain  = each.value.item.domain
  name    = each.value.item.name
  entries = each.value.item.entries
}

##########################################################
###    IPv6 PREFIX LISTS
##########################################################
locals {
  data_ipv6_prefix_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ipv6_prefix_list in try(domain.objects.ipv6_prefix_lists, []) : ipv6_prefix_list.name => {}
      }
    } if length(try(domain.objects.ipv6_prefix_lists, [])) > 0
  }

  ipv6_prefix_lists_bulk = try(local.fmc.nac_configuration.ipv6_prefix_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ipv6_prefix_lists = {
    for domain in local.domains : domain.name => [
      for ipv6_prefix_list in try(domain.objects.ipv6_prefix_lists, []) : {
        domain = domain.name
        name   = ipv6_prefix_list.name
        entries = [for entry in ipv6_prefix_list.entries : {
          action            = entry.action
          prefix            = entry.prefix
          min_prefix_length = entry.min_prefix_length
          max_prefix_length = entry.max_prefix_length
        }]
      } if !contains(try(keys(local.data_ipv6_prefix_lists[domain.name].items), []), ipv6_prefix_list.name)
    ] if length(try(domain.objects.ipv6_prefix_lists, [])) > 0
  }

  resource_ipv6_prefix_list = !local.ipv6_prefix_lists_bulk ? {
    for item in flatten([
      for domain, ipv6_prefix_lists in local.resource_ipv6_prefix_lists : [
        for ipv6_prefix_list in ipv6_prefix_lists : {
          key  = "${domain}:${ipv6_prefix_list.name}"
          item = ipv6_prefix_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ipv6_prefix_lists" "ipv6_prefix_lists" {
  for_each = local.data_ipv6_prefix_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_ipv6_prefix_lists" "ipv6_prefix_lists" {
  for_each = local.ipv6_prefix_lists_bulk ? local.resource_ipv6_prefix_lists : {}

  domain = each.key
  items  = { for ipv6_prefix_list in each.value : ipv6_prefix_list.name => ipv6_prefix_list }
}

# Handle individual mode (resource per host) 
resource "fmc_ipv6_prefix_list" "ipv6_prefix_list" {
  for_each = !local.ipv6_prefix_lists_bulk ? local.resource_ipv6_prefix_list : {}

  domain  = each.value.item.domain
  name    = each.value.item.name
  entries = each.value.item.entries
}

##########################################################
###    STANDARD COMMUNITY LISTS
##########################################################
locals {
  data_standard_community_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for standard_community_list in try(domain.objects.standard_community_lists, []) : standard_community_list.name => {}
      }
    } if length(try(domain.objects.standard_community_lists, [])) > 0
  }

  standard_community_lists_bulk = try(local.fmc.nac_configuration.standard_community_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_standard_community_lists = {
    for domain in local.domains : domain.name => [
      for standard_community_list in try(domain.objects.standard_community_lists, []) : {
        domain = domain.name
        name   = standard_community_list.name
        entries = [for entry in standard_community_list.entries : {
          action       = entry.action
          communities  = join(" ", entry.communities)
          internet     = try(entry.internet, local.defaults.fmc.domains.objects.standard_community_lists.entries.internet, null)
          no_advertise = try(entry.no_advertise, local.defaults.fmc.domains.objects.standard_community_lists.entries.no_advertise, null)
          no_export    = try(entry.no_export, local.defaults.fmc.domains.objects.standard_community_lists.entries.no_export, null)
        }]
      } if !contains(try(keys(local.data_standard_community_lists[domain.name].items), []), standard_community_list.name)
    ] if length(try(domain.objects.standard_community_lists, [])) > 0
  }

  resource_standard_community_list = !local.standard_community_lists_bulk ? {
    for item in flatten([
      for domain, standard_community_lists in local.resource_standard_community_lists : [
        for standard_community_list in standard_community_lists : {
          key  = "${domain}:${standard_community_list.name}"
          item = standard_community_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_standard_community_lists" "standard_community_lists" {
  for_each = local.data_standard_community_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_standard_community_lists" "standard_community_lists" {
  for_each = local.standard_community_lists_bulk ? local.resource_standard_community_lists : {}

  domain = each.key
  items  = { for standard_community_list in each.value : standard_community_list.name => standard_community_list }
}

# Handle individual mode (resource per host) 
resource "fmc_standard_community_list" "standard_community_list" {
  for_each = !local.standard_community_lists_bulk ? local.resource_standard_community_list : {}

  domain  = each.value.item.domain
  name    = each.value.item.name
  entries = each.value.item.entries
}

##########################################################
###    EXPANDED COMMUNITY LISTS
##########################################################
locals {
  data_expanded_community_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for expanded_community_list in try(domain.objects.expanded_community_lists, []) : expanded_community_list.name => {}
      }
    } if length(try(domain.objects.expanded_community_lists, [])) > 0
  }

  expanded_community_lists_bulk = try(local.fmc.nac_configuration.expanded_community_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_expanded_community_lists = {
    for domain in local.domains : domain.name => [
      for expanded_community_list in try(domain.objects.expanded_community_lists, []) : {
        domain = domain.name
        name   = expanded_community_list.name
        entries = [for entry in expanded_community_list.entries : {
          action             = entry.action
          regular_expression = entry.regular_expression
        }]
      } if !contains(try(keys(local.data_expanded_community_lists[domain.name].items), []), expanded_community_list.name)
    ] if length(try(domain.objects.expanded_community_lists, [])) > 0
  }

  resource_expanded_community_list = !local.expanded_community_lists_bulk ? {
    for item in flatten([
      for domain, expanded_community_lists in local.resource_expanded_community_lists : [
        for expanded_community_list in expanded_community_lists : {
          key  = "${domain}:${expanded_community_list.name}"
          item = expanded_community_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_expanded_community_lists" "expanded_community_lists" {
  for_each = local.data_expanded_community_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_expanded_community_lists" "expanded_community_lists" {
  for_each = local.expanded_community_lists_bulk ? local.resource_expanded_community_lists : {}

  domain = each.key
  items  = { for expanded_community_list in each.value : expanded_community_list.name => expanded_community_list }
}

# Handle individual mode (resource per host) 
resource "fmc_expanded_community_list" "expanded_community_list" {
  for_each = !local.expanded_community_lists_bulk ? local.resource_expanded_community_list : {}

  domain  = each.value.item.domain
  name    = each.value.item.name
  entries = each.value.item.entries
}

##########################################################
###    EXTENDED COMMUNITY LISTS
##########################################################
locals {
  data_extended_community_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for extended_community_list in try(domain.objects.extended_community_lists, []) : extended_community_list.name => {}
      }
    } if length(try(domain.objects.extended_community_lists, [])) > 0
  }

  extended_community_lists_bulk = try(local.fmc.nac_configuration.extended_community_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_extended_community_lists = {
    for domain in local.domains : domain.name => [
      for extended_community_list in try(domain.objects.extended_community_lists, []) : {
        domain   = domain.name
        name     = extended_community_list.name
        sub_type = extended_community_list.sub_type
        entries = [for entry in extended_community_list.entries : {
          action             = entry.action
          route_target       = extended_community_list.sub_type == "Standard" ? entry.route_target : null
          regular_expression = extended_community_list.sub_type == "Expanded" ? entry.regular_expression : null
        }]
      } if !contains(try(keys(local.data_extended_community_lists[domain.name].items), []), extended_community_list.name)
    ] if length(try(domain.objects.extended_community_lists, [])) > 0
  }

  resource_extended_community_list = !local.extended_community_lists_bulk ? {
    for item in flatten([
      for domain, extended_community_lists in local.resource_extended_community_lists : [
        for extended_community_list in extended_community_lists : {
          key  = "${domain}:${extended_community_list.name}"
          item = extended_community_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_extended_community_lists" "extended_community_lists" {
  for_each = local.data_extended_community_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_extended_community_lists" "extended_community_lists" {
  for_each = local.extended_community_lists_bulk ? local.resource_extended_community_lists : {}

  domain = each.key
  items  = { for extended_community_list in each.value : extended_community_list.name => extended_community_list }
}

resource "fmc_extended_community_list" "extended_community_list" {
  for_each = !local.extended_community_lists_bulk ? local.resource_extended_community_list : {}

  domain   = each.value.item.domain
  name     = each.value.item.name
  sub_type = each.value.item.sub_type
  entries  = each.value.item.entries
}

##########################################################
###    POLICY LISTS
##########################################################
locals {
  data_policy_lists = {
    for domain in local.data_existing : domain.name => {
      items = {
        for policy_list in try(domain.objects.policy_lists, []) : policy_list.name => {}
      }
    } if length(try(domain.objects.policy_lists, [])) > 0
  }

  policy_lists_bulk = try(local.fmc.nac_configuration.policy_lists_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_policy_lists = {
    for domain in local.domains : domain.name => [
      for policy_list in try(domain.objects.policy_lists, []) : {
        domain = domain.name
        name   = policy_list.name
        action = policy_list.action
        interfaces = [for interface in try(policy_list.interfaces, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${interface}"].id
            if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${interface}")
          })[0]
        }]
        interface_names = length(try(policy_list.interface_literals, [])) > 0 ? policy_list.interface_literals : null
        address_standard_access_lists = length(try(policy_list.address_standard_access_lists, [])) > 0 ? [for address_standard_access_list in policy_list.address_standard_access_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_standard_access_lists["${domain_path}:${address_standard_access_list}"].id
            if contains(keys(local.map_standard_access_lists), "${domain_path}:${address_standard_access_list}")
          })[0]
        }] : null
        address_ipv4_prefix_lists = length(try(policy_list.address_ipv4_prefix_lists, [])) > 0 ? [for address_ipv4_prefix_list in policy_list.address_ipv4_prefix_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_ipv4_prefix_lists["${domain_path}:${address_ipv4_prefix_list}"].id
            if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${address_ipv4_prefix_list}")
          })[0]
        }] : null
        next_hop_standard_access_lists = length(try(policy_list.next_hop_standard_access_lists, [])) > 0 ? [for next_hop_standard_access_list in policy_list.next_hop_standard_access_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_standard_access_lists["${domain_path}:${next_hop_standard_access_list}"].id
            if contains(keys(local.map_standard_access_lists), "${domain_path}:${next_hop_standard_access_list}")
          })[0]
        }] : null
        next_hop_ipv4_prefix_lists = length(try(policy_list.next_hop_ipv4_prefix_lists, [])) > 0 ? [for next_hop_ipv4_prefix_list in policy_list.next_hop_ipv4_prefix_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_ipv4_prefix_lists["${domain_path}:${next_hop_ipv4_prefix_list}"].id
            if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${next_hop_ipv4_prefix_list}")
          })[0]
        }] : null
        route_source_standard_access_lists = length(try(policy_list.route_source_standard_access_lists, [])) > 0 ? [for route_source_standard_access_list in policy_list.route_source_standard_access_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_standard_access_lists["${domain_path}:${route_source_standard_access_list}"].id
            if contains(keys(local.map_standard_access_lists), "${domain_path}:${route_source_standard_access_list}")
          })[0]
        }] : null
        route_source_ipv4_prefix_lists = length(try(policy_list.route_source_ipv4_prefix_lists, [])) > 0 ? [for route_source_ipv4_prefix_list in policy_list.route_source_ipv4_prefix_lists : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_ipv4_prefix_lists["${domain_path}:${route_source_ipv4_prefix_list}"].id
            if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${route_source_ipv4_prefix_list}")
          })[0]
        }] : null
        as_paths = [for as_path in try(policy_list.as_paths, []) : {
          id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_as_paths["${domain_path}:${as_path}"].id
            if contains(keys(local.map_as_paths), "${domain_path}:${as_path}")
          })[0]
        }]
        community_lists = [for item in [
          for community_list in try(policy_list.community_lists, []) : {
            id = one([
              for domain_path in local.related_domains[domain.name] :
              local.map_community_lists["${domain_path}:${community_list}"].id
              if contains(keys(local.map_community_lists), "${domain_path}:${community_list}")
            ])
          }
        ] : item if item.id != null]
        extended_community_lists = [for item in [
          for extended_community_list in try(policy_list.community_lists, []) : {
            id = one([
              for domain_path in local.related_domains[domain.name] :
              local.map_extended_community_lists["${domain_path}:${extended_community_list}"].id
              if contains(keys(local.map_extended_community_lists), "${domain_path}:${extended_community_list}")
            ])
          }
        ] : item if item.id != null]
        _validate_community_lists = [
          for community_list in try(policy_list.community_lists, []) :
          anytrue([
            for domain_path in local.related_domains[domain.name] :
            contains(keys(local.map_community_lists), "${domain_path}:${community_list}") ||
            contains(keys(local.map_extended_community_lists), "${domain_path}:${community_list}")
          ]) ? true : tobool("ERROR: Community list '${community_list}' in policy list '${policy_list.name}' (domain: ${domain.name}) not found in map_community_lists or map_extended_community_lists")
        ]
        match_community_exactly = try(policy_list.match_community_exactly, local.defaults.fmc.domains.objects.policy_lists.match_community_exactly, null)
        metric                  = try(policy_list.metric, local.defaults.fmc.domains.objects.policy_lists.metric, null)
        tag                     = try(policy_list.tag, local.defaults.fmc.domains.objects.policy_lists.tag, null)
      } if !contains(try(keys(local.data_policy_lists[domain.name].items), []), policy_list.name)
    ] if length(try(domain.objects.policy_lists, [])) > 0
  }

  resource_policy_list = !local.policy_lists_bulk ? {
    for item in flatten([
      for domain, policy_lists in local.resource_policy_lists : [
        for policy_list in policy_lists : {
          key  = "${domain}:${policy_list.name}"
          item = policy_list
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_policy_lists" "policy_lists" {
  for_each = local.data_policy_lists

  items  = each.value.items
  domain = each.key
}

resource "fmc_policy_lists" "policy_lists" {
  for_each = local.policy_lists_bulk ? local.resource_policy_lists : {}

  domain = each.key
  items  = { for policy_list in each.value : policy_list.name => policy_list }
}

resource "fmc_policy_list" "policy_list" {
  for_each = !local.policy_lists_bulk ? local.resource_policy_list : {}

  domain                             = each.value.item.domain
  name                               = each.value.item.name
  action                             = each.value.item.action
  interfaces                         = each.value.item.interfaces
  interface_names                    = each.value.item.interface_names
  address_standard_access_lists      = each.value.item.address_standard_access_lists
  address_ipv4_prefix_lists          = each.value.item.address_ipv4_prefix_lists
  next_hop_standard_access_lists     = each.value.item.next_hop_standard_access_lists
  next_hop_ipv4_prefix_lists         = each.value.item.next_hop_ipv4_prefix_lists
  route_source_standard_access_lists = each.value.item.route_source_standard_access_lists
  route_source_ipv4_prefix_lists     = each.value.item.route_source_ipv4_prefix_lists
  as_paths                           = each.value.item.as_paths
  community_lists                    = each.value.item.community_lists
  extended_community_lists           = each.value.item.extended_community_lists
  match_community_exactly            = each.value.item.match_community_exactly
  metric                             = each.value.item.metric
  tag                                = each.value.item.tag
}

##########################################################
###    ROUTE MAPS
##########################################################
locals {
  data_route_map = {
    for item in flatten([
      for domain in local.data_existing : [
        for route_map in try(domain.objects.route_maps, {}) : {
          name   = route_map.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_route_map = {
    for item in flatten([
      for domain in local.domains : [
        for route_map in try(domain.objects.route_maps, {}) : {
          domain      = domain.name
          name        = route_map.name
          overridable = try(route_map.overridable, local.defaults.fmc.domains.objects.route_maps.overridable, null)
          entries = [for entry in route_map.entries : {
            action = entry.action
            match_security_zones = [for security_zone in try(entry.match.security_zones, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${security_zone}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${security_zone}")
              })[0]
            }]
            match_interface_names = try(entry.match.interface_literals, null)
            match_ipv4_address_access_lists = [for ipv4_address_access_list in try(entry.match.ipv4_address_access_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_address_access_list}"].id
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_address_access_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_address_access_list}"].type
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_address_access_list}")
              })[0]
            }]
            match_ipv4_address_prefix_lists = [for ipv4_address_prefix_list in try(entry.match.ipv4_address_prefix_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_address_prefix_list}"].id
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_address_prefix_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_address_prefix_list}"].type
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_address_prefix_list}")
              })[0]
            }]
            match_ipv4_next_hop_access_lists = [for ipv4_next_hop_access_list in try(entry.match.ipv4_next_hop_access_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_next_hop_access_list}"].id
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_next_hop_access_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_next_hop_access_list}"].type
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_next_hop_access_list}")
              })[0]
            }]
            match_ipv4_next_hop_prefix_lists = [for ipv4_next_hop_prefix_list in try(entry.match.ipv4_next_hop_prefix_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_next_hop_prefix_list}"].id
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_next_hop_prefix_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_next_hop_prefix_list}"].type
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_next_hop_prefix_list}")
              })[0]
            }]
            match_ipv4_route_source_access_lists = [for ipv4_route_source_access_list in try(entry.match.ipv4_route_source_access_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_route_source_access_list}"].id
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_route_source_access_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_lists["${domain_path}:${ipv4_route_source_access_list}"].type
                if contains(keys(local.map_access_lists), "${domain_path}:${ipv4_route_source_access_list}")
              })[0]
            }]
            match_ipv4_route_source_prefix_lists = [for ipv4_route_source_prefix_list in try(entry.match.ipv4_route_source_prefix_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_route_source_prefix_list}"].id
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_route_source_prefix_list}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_prefix_lists["${domain_path}:${ipv4_route_source_prefix_list}"].type
                if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${ipv4_route_source_prefix_list}")
              })[0]
            }]
            match_ipv6_address_extended_access_list_id = try(entry.match.ipv6_address_extended_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${entry.match.ipv6_address_extended_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${entry.match.ipv6_address_extended_access_list}")
            })[0] : null
            match_ipv6_address_prefix_list_id = try(entry.match.ipv6_address_prefix_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ipv6_prefix_lists["${domain_path}:${entry.match.ipv6_address_prefix_list}"].id
              if contains(keys(local.map_ipv6_prefix_lists), "${domain_path}:${entry.match.ipv6_address_prefix_list}")
            })[0] : null
            match_ipv6_next_hop_extended_access_list_id = try(entry.match.ipv6_next_hop_extended_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${entry.match.ipv6_next_hop_extended_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${entry.match.ipv6_next_hop_extended_access_list}")
            })[0] : null
            match_ipv6_next_hop_prefix_list_id = try(entry.match.ipv6_next_hop_prefix_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ipv6_prefix_lists["${domain_path}:${entry.match.ipv6_next_hop_prefix_list}"].id
              if contains(keys(local.map_ipv6_prefix_lists), "${domain_path}:${entry.match.ipv6_next_hop_prefix_list}")
            })[0] : null
            match_ipv6_route_source_extended_access_list_id = try(entry.match.ipv6_route_source_extended_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${entry.match.ipv6_route_source_extended_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${entry.match.ipv6_route_source_extended_access_list}")
            })[0] : null
            match_ipv6_route_source_prefix_list_id = try(entry.match.ipv6_route_source_prefix_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ipv6_prefix_lists["${domain_path}:${entry.match.ipv6_route_source_prefix_list}"].id
              if contains(keys(local.map_ipv6_prefix_lists), "${domain_path}:${entry.match.ipv6_route_source_prefix_list}")
            })[0] : null
            match_bgp_as_paths = [for as_path in try(entry.match.bgp_as_paths, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_as_paths["${domain_path}:${as_path}"].id
                if contains(keys(local.map_as_paths), "${domain_path}:${as_path}")
              })[0]
            }]
            match_bgp_community_lists = [for item in [
              for community_list in try(entry.match.bgp_community_lists, []) : {
                id = one([
                  for domain_path in local.related_domains[domain.name] :
                  local.map_community_lists["${domain_path}:${community_list}"].id
                  if contains(keys(local.map_community_lists), "${domain_path}:${community_list}")
                ])
              }
            ] : item if item.id != null]
            match_bgp_extended_community_lists = [for item in [
              for extended_community_list in try(entry.match.bgp_community_lists, []) : {
                id = one([
                  for domain_path in local.related_domains[domain.name] :
                  local.map_extended_community_lists["${domain_path}:${extended_community_list}"].id
                  if contains(keys(local.map_extended_community_lists), "${domain_path}:${extended_community_list}")
                ])
              }
            ] : item if item.id != null]
            match_bgp_policy_lists = [for bgp_policy_list in try(entry.match.bgp_policy_lists, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_policy_lists["${domain_path}:${bgp_policy_list}"].id
                if contains(keys(local.map_policy_lists), "${domain_path}:${bgp_policy_list}")
              })[0]
            }]
            _validate_bgp_community_lists = [
              for community_list in try(entry.match.bgp_community_lists, []) :
              anytrue([
                for domain_path in local.related_domains[domain.name] :
                contains(keys(local.map_community_lists), "${domain_path}:${community_list}") ||
                contains(keys(local.map_extended_community_lists), "${domain_path}:${community_list}")
              ]) ? true : tobool("ERROR: BGP community list '${community_list}' in route map '${route_map.name}' (domain: ${domain.name}) not found in map_community_lists or map_extended_community_lists")
            ]
            match_route_metrics                                    = try(entry.match.route_metrics, null)
            match_tags                                             = try(entry.match.tags, null)
            match_route_type_external_1                            = try(entry.match.route_type_external_1, null)
            match_route_type_external_2                            = try(entry.match.route_type_external_2, null)
            match_route_type_internal                              = try(entry.match.route_type_internal, null)
            match_route_type_local                                 = try(entry.match.route_type_local, null)
            match_route_type_nssa_external_1                       = try(entry.match.route_type_nssa_external_1, null)
            match_route_type_nssa_external_2                       = try(entry.match.route_type_nssa_external_2, null)
            set_metric_bandwidth                                   = try(entry.set.metric_bandwidth, null)
            set_metric_type                                        = try(entry.set.metric_type, null)
            set_bgp_as_path_prepend                                = try(entry.set.bgp_as_path_prepend, null)
            set_bgp_as_path_prepend_last_as                        = try(entry.set.bgp_as_path_prepend_last_as, null)
            set_bgp_as_path_convert_route_tag_into_as_path         = try(entry.set.bgp_as_path_convert_route_tag_into_as_path, null)
            set_bgp_community_none                                 = try(entry.set.bgp_community_none, null)
            set_bgp_community_specific_community                   = try(entry.set.bgp_community_specific_community, null)
            set_bgp_community_add_to_existing_communities          = try(entry.set.bgp_community_add_to_existing_communities, null)
            set_bgp_community_internet                             = try(entry.set.bgp_community_internet, null)
            set_bgp_community_no_advertise                         = try(entry.set.bgp_community_no_advertise, null)
            set_bgp_community_no_export                            = try(entry.set.bgp_community_no_export, null)
            set_bgp_community_route_target                         = try(join(",", entry.set.bgp_community_route_targets), null)
            set_bgp_community_add_to_existing_extended_communities = try(entry.set.bgp_community_add_to_existing_extended_communities, local.defaults.fmc.domains.objects.route_maps.entries.set.bgp_community_add_to_existing_extended_communities, null)
            set_bgp_automatic_tag                                  = try(entry.set.bgp_automatic_tag, null)
            set_bgp_local_preference                               = try(entry.set.bgp_local_preference, null)
            set_bgp_weight                                         = try(entry.set.bgp_weight, null)
            set_bgp_origin                                         = try(entry.set.bgp_origin, null)
            set_bgp_ipv4_next_hop                                  = try(entry.set.bgp_ipv4_next_hop, null)
            set_bgp_ipv4_next_hop_specific_ips                     = try(entry.set.bgp_ipv4_next_hop_specific_ips, null)
            set_bgp_ipv4_prefix_list_id = try(entry.set.bgp_ipv4_prefix_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ipv4_prefix_lists["${domain_path}:${entry.set.bgp_ipv4_prefix_list}"].id
              if contains(keys(local.map_ipv4_prefix_lists), "${domain_path}:${entry.set.bgp_ipv4_prefix_list}")
            })[0] : null
            set_bgp_ipv6_next_hop              = try(entry.set.bgp_ipv6_next_hop, null)
            set_bgp_ipv6_next_hop_specific_ips = try(entry.set.bgp_ipv6_next_hop_specific_ips, null)
            set_bgp_ipv6_prefix_list_id = try(entry.set.bgp_ipv6_prefix_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ipv6_prefix_lists["${domain_path}:${entry.set.bgp_ipv6_prefix_list}"].id
              if contains(keys(local.map_ipv6_prefix_lists), "${domain_path}:${entry.set.bgp_ipv6_prefix_list}")
            })[0] : null
          }]
        } if !contains(try(keys(local.data_route_map), {}), "${domain.name}:${route_map.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_route_map" "route_map" {
  for_each = local.data_route_map

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_route_map" "route_map" {
  for_each = local.resource_route_map

  domain      = each.value.domain
  name        = each.value.name
  entries     = each.value.entries
  overridable = each.value.overridable
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
  data_bfd_templates = {
    for domain in local.data_existing : domain.name => {
      items = {
        for bfd_template in try(domain.objects.bfd_templates, []) : bfd_template.name => {}
      }
    } if length(try(domain.objects.bfd_templates, [])) > 0
  }

  bfd_templates_bulk = try(local.fmc.nac_configuration.bfd_templates_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_bfd_templates = {
    for domain in local.domains : domain.name => [
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
      } if !contains(try(keys(local.data_bfd_templates[domain.name].items), []), bfd_template.name)
    ] if length(try(domain.objects.bfd_templates, [])) > 0
  }

  resource_bfd_template = !local.bfd_templates_bulk ? {
    for item in flatten([
      for domain, bfd_templates in local.resource_bfd_templates : [
        for bfd_template in bfd_templates : {
          key  = "${domain}:${bfd_template.name}"
          item = bfd_template
        }
      ]
    ]) : item.key => item
  } : {}

}

data "fmc_bfd_templates" "bfd_templates" {
  for_each = local.data_bfd_templates

  items  = each.value.items
  domain = each.key
}

resource "fmc_bfd_templates" "bfd_templates" {
  for_each = local.bfd_templates_bulk ? local.resource_bfd_templates : {}

  domain = each.key
  items  = { for bfd_template in each.value : bfd_template.name => bfd_template }
}

resource "fmc_bfd_template" "bfd_template" {
  for_each = !local.bfd_templates_bulk ? local.resource_bfd_template : {}

  name                               = each.value.item.name
  domain                             = each.value.item.domain
  hop_type                           = each.value.item.hop_type
  echo                               = each.value.item.echo
  interval_type                      = each.value.item.interval_type
  minimum_transmit                   = each.value.item.minimum_transmit
  multiplier                         = each.value.item.multiplier
  minimum_receive                    = each.value.item.minimum_receive
  authentication_password            = each.value.item.authentication_password
  authentication_password_encryption = each.value.item.authentication_password_encryption
  authentication_key_id              = each.value.item.authentication_key_id
  authentication_type                = each.value.item.authentication_type
}

##########################################################
###    RESOURCE PROFILES
##########################################################
locals {
  data_resource_profiles = {
    for domain in local.data_existing : domain.name => {
      items = {
        for resource_profile in try(domain.objects.resource_profiles, []) : resource_profile.name => {}
      }
    } if length(try(domain.objects.resource_profiles, [])) > 0
  }

  resource_profiles_bulk = try(local.fmc.nac_configuration.resource_profiles_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_resource_profiles = {
    for domain in local.domains : domain.name => [
      for resource_profile in try(domain.objects.resource_profiles, []) : {
        domain         = domain.name
        name           = resource_profile.name
        number_of_cpus = resource_profile.number_of_cpus
        description    = try(resource_profile.description, local.defaults.fmc.domains.objects.resource_profiles.description, null)
      } if !contains(try(keys(local.data_resource_profiles[domain.name].items), []), resource_profile.name)
    ] if length(try(domain.objects.resource_profiles, [])) > 0
  }

  resource_resource_profile = !local.resource_profiles_bulk ? {
    for item in flatten([
      for domain, resource_profiles in local.resource_resource_profiles : [
        for resource_profile in resource_profiles : {
          key  = "${domain}:${resource_profile.name}"
          item = resource_profile
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_resource_profiles" "resource_profiles" {
  for_each = local.data_resource_profiles

  items  = each.value.items
  domain = each.key
}

resource "fmc_resource_profiles" "resource_profiles" {
  for_each = local.resource_profiles_bulk ? local.resource_resource_profiles : {}

  domain = each.key
  items  = { for resource_profile in each.value : resource_profile.name => resource_profile }
}

resource "fmc_resource_profile" "resource_profile" {
  for_each = !local.resource_profiles_bulk ? local.resource_resource_profile : {}

  domain         = each.value.item.domain
  name           = each.value.item.name
  number_of_cpus = each.value.item.number_of_cpus
  description    = each.value.item.description
}

##########################################################
###    GEOLOCATIONS
##########################################################
locals {
  data_geolocations = {
    for domain in local.data_existing : domain.name => {
      items = {
        for geolocation in try(domain.objects.geolocations, []) : geolocation.name => {}
      }
    } if length(try(domain.objects.geolocations, [])) > 0
  }

  geolocations_bulk = try(local.fmc.nac_configuration.geolocations_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_geolocations = {
    for domain in local.domains : domain.name => [
      for geolocation in try(domain.objects.geolocations, []) : {
        domain = domain.name
        name   = geolocation.name
        continents = [for continent in try(geolocation.continents, []) : {
          id = data.fmc_continents.continents["Global"].items[continent].id
        }]
        countries = [for country in try(geolocation.countries, []) : {
          id = data.fmc_countries.countries["Global"].items[country].id
        }]
      } if !contains(try(keys(local.data_geolocations[domain.name].items), []), geolocation.name)
    ] if length(try(domain.objects.geolocations, [])) > 0
  }

  resource_geolocation = !local.geolocations_bulk ? {
    for item in flatten([
      for domain, geolocations in local.resource_geolocations : [
        for geolocation in geolocations : {
          key  = "${domain}:${geolocation.name}"
          item = geolocation
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_geolocations" "geolocations" {
  for_each = local.data_geolocations

  items  = each.value.items
  domain = each.key
}

resource "fmc_geolocations" "geolocations" {
  for_each = local.geolocations_bulk ? local.resource_geolocations : {}

  domain = each.key
  items  = { for geolocation in each.value : geolocation.name => geolocation }
}

resource "fmc_geolocation" "geolocation" {
  for_each = !local.geolocations_bulk ? local.resource_geolocation : {}

  domain     = each.value.item.domain
  name       = each.value.item.name
  continents = each.value.item.continents
  countries  = each.value.item.countries
}

##########################################################
###    SERVICE ACCESS
##########################################################
locals {
  data_service_access = {
    for item in flatten([
      for domain in local.data_existing : [
        for service_access in try(domain.objects.service_accesses, {}) : {
          name   = service_access.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_service_access = {
    for item in flatten([
      for domain in local.domains : [
        for service_access in try(domain.objects.service_accesses, {}) : {
          domain         = domain.name
          name           = service_access.name
          default_action = service_access.default_action
          rules = [for rule in service_access.rules : {
            action = rule.action
            geolocation_sources = [for geolocation_source in try(rule.geolocation_sources, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_geolocation_sources["${domain_path}:${geolocation_source}"].id
                if contains(keys(local.map_geolocation_sources), "${domain_path}:${geolocation_source}")
              })[0],
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_geolocation_sources["${domain_path}:${geolocation_source}"].type
                if contains(keys(local.map_geolocation_sources), "${domain_path}:${geolocation_source}")
              })[0],
            }]
          }]
        } if !contains(try(keys(local.data_service_access), {}), "${domain.name}:${service_access.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_service_access" "service_access" {
  for_each = local.data_service_access

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_service_access" "service_access" {
  for_each = local.resource_service_access

  domain         = each.value.domain
  name           = each.value.name
  default_action = each.value.default_action
  rules          = each.value.rules
}

##########################################################
###    IKEV1 IPSEC PROPOSALS
##########################################################
locals {
  data_ikev1_ipsec_proposals = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ikev1_ipsec_proposal in try(domain.objects.ikev1_ipsec_proposals, []) : ikev1_ipsec_proposal.name => {}
      }
    } if length(try(domain.objects.ikev1_ipsec_proposals, [])) > 0
  }

  ikev1_ipsec_proposals_bulk = try(local.fmc.nac_configuration.ikev1_ipsec_proposals_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ikev1_ipsec_proposals = {
    for domain in local.domains : domain.name => [
      for ikev1_ipsec_proposal in try(domain.objects.ikev1_ipsec_proposals, []) : {
        domain         = domain.name
        name           = ikev1_ipsec_proposal.name
        description    = try(ikev1_ipsec_proposal.description, local.defaults.fmc.domains.objects.ikev1_ipsec_proposals.description, null)
        esp_encryption = ikev1_ipsec_proposal.esp_encryption
        esp_hash       = ikev1_ipsec_proposal.esp_hash
    }] if length(try(domain.objects.ikev1_ipsec_proposals, [])) > 0
  }

  resource_ikev1_ipsec_proposal = !local.ikev1_ipsec_proposals_bulk ? {
    for item in flatten([
      for domain, ikev1_ipsec_proposals in local.resource_ikev1_ipsec_proposals : [
        for ikev1_ipsec_proposal in ikev1_ipsec_proposals : {
          key  = "${domain}:${ikev1_ipsec_proposal.name}"
          item = ikev1_ipsec_proposal
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ikev1_ipsec_proposals" "ikev1_ipsec_proposals" {
  for_each = local.data_ikev1_ipsec_proposals

  items  = each.value.items
  domain = each.key
}

resource "fmc_ikev1_ipsec_proposals" "ikev1_ipsec_proposals" {
  for_each = local.ikev1_ipsec_proposals_bulk ? local.resource_ikev1_ipsec_proposals : {}

  domain = each.key
  items  = { for ikev1_ipsec_proposal in each.value : ikev1_ipsec_proposal.name => ikev1_ipsec_proposal }
}

resource "fmc_ikev1_ipsec_proposal" "ikev1_ipsec_proposal" {
  for_each = !local.ikev1_ipsec_proposals_bulk ? local.resource_ikev1_ipsec_proposal : {}

  domain         = each.value.item.domain
  name           = each.value.item.name
  description    = each.value.item.description
  esp_encryption = each.value.item.esp_encryption
  esp_hash       = each.value.item.esp_hash
}

##########################################################
###    IKEV1 POLICIES
##########################################################
locals {
  data_ikev1_policies = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ikev1_policy in try(domain.objects.ikev1_policies, []) : ikev1_policy.name => {}
      }
    } if length(try(domain.objects.ikev1_policies, [])) > 0
  }

  ikev1_policies_bulk = try(local.fmc.nac_configuration.ikev1_policies_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ikev1_policies = {
    for domain in local.domains : domain.name => [
      for ikev1_policy in try(domain.objects.ikev1_policies, []) : {
        domain                = domain.name
        name                  = ikev1_policy.name
        description           = try(ikev1_policy.description, local.defaults.fmc.domains.objects.ikev1_policies.description, null)
        authentication_method = ikev1_policy.authentication_method
        dh_group              = ikev1_policy.dh_group
        encryption_algorithm  = ikev1_policy.encryption_algorithm
        hash                  = ikev1_policy.hash
        lifetime              = ikev1_policy.lifetime
        priority              = ikev1_policy.priority
    }] if length(try(domain.objects.ikev1_policies, [])) > 0
  }

  resource_ikev1_policy = !local.ikev1_policies_bulk ? {
    for item in flatten([
      for domain, ikev1_policies in local.resource_ikev1_policies : [
        for ikev1_policy in ikev1_policies : {
          key  = "${domain}:${ikev1_policy.name}"
          item = ikev1_policy
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ikev1_policies" "ikev1_policies" {
  for_each = local.data_ikev1_policies

  items  = each.value.items
  domain = each.key
}

resource "fmc_ikev1_policies" "ikev1_policies" {
  for_each = local.ikev1_policies_bulk ? local.resource_ikev1_policies : {}

  domain = each.key
  items  = { for ikev1_policy in each.value : ikev1_policy.name => ikev1_policy }
}

resource "fmc_ikev1_policy" "ikev1_policy" {
  for_each = !local.ikev1_policies_bulk ? local.resource_ikev1_policy : {}

  domain                = each.value.item.domain
  name                  = each.value.item.name
  description           = each.value.item.description
  authentication_method = each.value.item.authentication_method
  dh_group              = each.value.item.dh_group
  encryption_algorithm  = each.value.item.encryption_algorithm
  hash                  = each.value.item.hash
  lifetime              = each.value.item.lifetime
  priority              = each.value.item.priority
}

##########################################################
###    IKEV2 IPSEC PROPOSALS
##########################################################
locals {
  data_ikev2_ipsec_proposals = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ikev2_ipsec_proposal in try(domain.objects.ikev2_ipsec_proposals, []) : ikev2_ipsec_proposal.name => {}
      }
    } if length(try(domain.objects.ikev2_ipsec_proposals, [])) > 0
  }

  ikev2_ipsec_proposals_bulk = try(local.fmc.nac_configuration.ikev2_ipsec_proposals_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ikev2_ipsec_proposals = {
    for domain in local.domains : domain.name => [
      for ikev2_ipsec_proposal in try(domain.objects.ikev2_ipsec_proposals, []) : {
        domain          = domain.name
        name            = ikev2_ipsec_proposal.name
        description     = try(ikev2_ipsec_proposal.description, local.defaults.fmc.domains.objects.ikev2_ipsec_proposals.description, null)
        esp_encryptions = ikev2_ipsec_proposal.esp_encryptions
        esp_hashes      = ikev2_ipsec_proposal.esp_hashes
    }] if length(try(domain.objects.ikev2_ipsec_proposals, [])) > 0
  }

  resource_ikev2_ipsec_proposal = !local.ikev2_ipsec_proposals_bulk ? {
    for item in flatten([
      for domain, ikev2_ipsec_proposals in local.resource_ikev2_ipsec_proposals : [
        for ikev2_ipsec_proposal in ikev2_ipsec_proposals : {
          key  = "${domain}:${ikev2_ipsec_proposal.name}"
          item = ikev2_ipsec_proposal
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ikev2_ipsec_proposals" "ikev2_ipsec_proposals" {
  for_each = local.data_ikev2_ipsec_proposals
  items    = each.value.items
  domain   = each.key
}

resource "fmc_ikev2_ipsec_proposals" "ikev2_ipsec_proposals" {
  for_each = local.ikev2_ipsec_proposals_bulk ? local.resource_ikev2_ipsec_proposals : {}

  domain = each.key
  items  = { for ikev2_ipsec_proposal in each.value : ikev2_ipsec_proposal.name => ikev2_ipsec_proposal }
}

resource "fmc_ikev2_ipsec_proposal" "ikev2_ipsec_proposal" {
  for_each = !local.ikev2_ipsec_proposals_bulk ? local.resource_ikev2_ipsec_proposal : {}

  domain          = each.value.item.domain
  name            = each.value.item.name
  description     = each.value.item.description
  esp_encryptions = each.value.item.esp_encryptions
  esp_hashes      = each.value.item.esp_hashes
}

##########################################################
###    IKEV2 POLICIES
##########################################################
locals {
  data_ikev2_policies = {
    for domain in local.data_existing : domain.name => {
      items = {
        for ikev2_policy in try(domain.objects.ikev2_policies, []) : ikev2_policy.name => {}
      }
    } if length(try(domain.objects.ikev2_policies, [])) > 0
  }

  ikev2_policies_bulk = try(local.fmc.nac_configuration.ikev2_policies_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_ikev2_policies = {
    for domain in local.domains : domain.name => [
      for ikev2_policy in try(domain.objects.ikev2_policies, []) : {
        domain                = domain.name
        name                  = ikev2_policy.name
        description           = try(ikev2_policy.description, local.defaults.fmc.domains.objects.ikev2_policies.description, null)
        dh_groups             = ikev2_policy.dh_groups
        encryption_algorithms = ikev2_policy.encryption_algorithms
        integrity_algorithms  = ikev2_policy.integrity_algorithms
        prf_algorithms        = ikev2_policy.prf_algorithms
        lifetime              = ikev2_policy.lifetime
        priority              = ikev2_policy.priority
    }] if length(try(domain.objects.ikev2_policies, [])) > 0
  }

  resource_ikev2_policy = !local.ikev2_policies_bulk ? {
    for item in flatten([
      for domain, ikev2_policies in local.resource_ikev2_policies : [
        for ikev2_policy in ikev2_policies : {
          key  = "${domain}:${ikev2_policy.name}"
          item = ikev2_policy
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_ikev2_policies" "ikev2_policies" {
  for_each = local.data_ikev2_policies

  items  = each.value.items
  domain = each.key
}

resource "fmc_ikev2_policies" "ikev2_policies" {
  for_each = local.ikev2_policies_bulk ? local.resource_ikev2_policies : {}

  domain = each.key
  items  = { for ikev2_policy in each.value : ikev2_policy.name => ikev2_policy }
}

resource "fmc_ikev2_policy" "ikev2_policy" {
  for_each = !local.ikev2_policies_bulk ? local.resource_ikev2_policy : {}

  domain                = each.value.item.domain
  name                  = each.value.item.name
  description           = each.value.item.description
  dh_groups             = each.value.item.dh_groups
  encryption_algorithms = each.value.item.encryption_algorithms
  integrity_algorithms  = each.value.item.integrity_algorithms
  prf_algorithms        = each.value.item.prf_algorithms
  lifetime              = each.value.item.lifetime
  priority              = each.value.item.priority
}

##########################################################
###    TRUSTED CERTIFICATE AUTHORITY
##########################################################
locals {
  data_trusted_certificate_authority = {
    for item in flatten([
      for domain in local.data_existing : [
        for trusted_certificate_authority in try(domain.objects.trusted_certificate_authorities, {}) : {
          name   = trusted_certificate_authority.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_trusted_certificate_authority = {
    for item in flatten([
      for domain in local.domains : [
        for trusted_certificate_authority in try(domain.objects.trusted_certificate_authorities, {}) : {
          domain      = domain.name
          name        = trusted_certificate_authority.name
          certificate = try(trusted_certificate_authority.certificate, file(trusted_certificate_authority.certificate_file))
        } if !contains(try(keys(local.data_trusted_certificate_authority), {}), "${domain.name}:${trusted_certificate_authority.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_trusted_certificate_authority" "trusted_certificate_authority" {
  for_each = local.data_trusted_certificate_authority

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_trusted_certificate_authority" "trusted_certificate_authority" {
  for_each = local.resource_trusted_certificate_authority

  domain      = each.value.domain
  name        = each.value.name
  certificate = each.value.certificate
}

##########################################################
###    INTERNAL CERTIFICATE AUTHORITY
##########################################################
locals {
  data_internal_certificate_authority = {
    for item in flatten([
      for domain in local.data_existing : [
        for internal_certificate_authority in try(domain.objects.internal_certificate_authorities, {}) : {
          name   = internal_certificate_authority.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_internal_certificate_authority = {
    for item in flatten([
      for domain in local.domains : [
        for internal_certificate_authority in try(domain.objects.internal_certificate_authorities, {}) : {
          domain      = domain.name
          name        = internal_certificate_authority.name
          certificate = try(internal_certificate_authority.certificate, file(internal_certificate_authority.certificate_file))
          private_key = try(internal_certificate_authority.private_key, file(internal_certificate_authority.private_key_file))
          password    = try(internal_certificate_authority.password, null)
        } if !contains(try(keys(local.data_internal_certificate_authority), {}), "${domain.name}:${internal_certificate_authority.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_internal_certificate_authority" "internal_certificate_authority" {
  for_each = local.data_internal_certificate_authority

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_internal_certificate_authority" "internal_certificate_authority" {
  for_each = local.resource_internal_certificate_authority

  domain      = each.value.domain
  name        = each.value.name
  certificate = each.value.certificate
  private_key = each.value.private_key
  password    = each.value.password
}

##########################################################
###    INTERNAL CERTIFICATES
##########################################################
locals {
  data_internal_certificate = {
    for item in flatten([
      for domain in local.data_existing : [
        for internal_certificate in try(domain.objects.internal_certificates, {}) : {
          name   = internal_certificate.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_internal_certificates = {
    for item in flatten([
      for domain in local.domains : [
        for internal_certificate in try(domain.objects.internal_certificates, {}) : {
          domain      = domain.name
          name        = internal_certificate.name
          certificate = try(internal_certificate.certificate, file(internal_certificate.certificate_file))
          private_key = try(internal_certificate.private_key, file(internal_certificate.private_key_file))
          password    = try(internal_certificate.password, null)
        } if !contains(try(keys(local.data_internal_certificate), {}), "${domain.name}:${internal_certificate.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_internal_certificate" "internal_certificate" {
  for_each = local.data_internal_certificate

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_internal_certificate" "internal_certificate" {
  for_each = local.resource_internal_certificates

  domain      = each.value.domain
  name        = each.value.name
  certificate = each.value.certificate
  private_key = each.value.private_key
  password    = each.value.password
}

##########################################################
###    EXTERNAL CERTIFICATES
##########################################################
locals {
  data_external_certificate = {
    for item in flatten([
      for domain in local.data_existing : [
        for external_certificate in try(domain.objects.external_certificates, {}) : {
          name   = external_certificate.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_external_certificates = {
    for item in flatten([
      for domain in local.domains : [
        for external_certificate in try(domain.objects.external_certificates, {}) : {
          domain      = domain.name
          name        = external_certificate.name
          certificate = try(external_certificate.certificate, file(external_certificate.certificate_file))
        } if !contains(try(keys(local.data_external_certificate), {}), "${domain.name}:${external_certificate.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_external_certificate" "external_certificate" {
  for_each = local.data_external_certificate

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_external_certificate" "external_certificate" {
  for_each = local.resource_external_certificates

  domain      = each.value.domain
  name        = each.value.name
  certificate = each.value.certificate
}

##########################################################
###    CERTIFICATE ENROLLMENTS (NON ACME)
##########################################################
locals {
  data_certificate_enrollment = {
    for item in flatten([
      for domain in local.data_existing : [
        for certificate_enrollment in try(domain.objects.certificate_enrollments, {}) : {
          name   = certificate_enrollment.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_certificate_enrollment = {
    for item in flatten([
      for domain in local.domains : [
        for certificate_enrollment in try(domain.objects.certificate_enrollments, {}) : {
          domain                        = domain.name
          name                          = certificate_enrollment.name
          description                   = try(certificate_enrollment.description, local.defaults.fmc.domains.objects.certificate_enrollments.description, null)
          enrollment_type               = certificate_enrollment.enrollment_type
          validation_usage_ipsec_client = try(certificate_enrollment.validation_usage_ipsec_client, null)
          validation_usage_ssl_client   = try(certificate_enrollment.validation_usage_ssl_client, null)
          validation_usage_ssl_server   = try(certificate_enrollment.validation_usage_ssl_server, null)
          skip_ca_flag_check            = try(certificate_enrollment.skip_ca_flag_check, null)
          # EST
          est_enrollment_url = try(certificate_enrollment.est.enrollment_url, null)
          est_username       = try(certificate_enrollment.est.username, null)
          est_password       = try(certificate_enrollment.est.password, null)
          est_fingerprint    = try(certificate_enrollment.est.fingerprint, null)
          est_source_interface_id = try(certificate_enrollment.est.source_interface, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${certificate_enrollment.est.source_interface}"].id
            if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${certificate_enrollment.est.source_interface}")
          })[0] : null
          est_source_interface_name                = try(certificate_enrollment.est.source_interface, null)
          est_ignore_server_certificate_validation = try(certificate_enrollment.est.ignore_server_certificate_validation, null)
          # SCEP
          scep_enrollment_url     = try(certificate_enrollment.scep.enrollment_url, null)
          scep_challenge_password = try(certificate_enrollment.scep.challenge_password, null)
          scep_retry_period       = try(certificate_enrollment.scep.retry_period, null)
          scep_retry_count        = try(certificate_enrollment.scep.retry_count, null)
          scep_fingerprint        = try(certificate_enrollment.scep.fingerprint, null)
          # Manual
          manual_ca_certificate = try(certificate_enrollment.manual.ca_certificate, file(certificate_enrollment.manual.ca_certificate_file), null)
          manual_ca_only        = try(certificate_enrollment.manual.ca_certificate, file(certificate_enrollment.manual.ca_certificate_file), null) != null ? true : null
          # PKCS12
          pkcs12_certificate            = try(certificate_enrollment.pkcs12.certificate, file(certificate_enrollment.pkcs12.certificate_file), null)
          pkcs12_certificate_passphrase = try(certificate_enrollment.pkcs12.passphrase, null)
          # Certificate Parameters
          certificate_include_fqdn                 = try(certificate_enrollment.certificate_parameters.include_fqdn, null)
          certificate_custom_fqdn                  = try(certificate_enrollment.certificate_parameters.custom_fqdn, null)
          certificate_alternate_fqdn               = try(join(",", certificate_enrollment.certificate_parameters.alternate_fqdns), null)
          certificate_include_device_ip            = try(certificate_enrollment.certificate_parameters.include_device_ip, null)
          certificate_common_name                  = try(certificate_enrollment.certificate_parameters.common_name, null)
          certificate_organizational_unit          = try(certificate_enrollment.certificate_parameters.organizational_unit, null)
          certificate_organization                 = try(certificate_enrollment.certificate_parameters.organization, null)
          certificate_locality                     = try(certificate_enrollment.certificate_parameters.locality, null)
          certificate_state                        = try(certificate_enrollment.certificate_parameters.state, null)
          certificate_country_code                 = try(certificate_enrollment.certificate_parameters.country_code, null)
          certificate_email                        = try(certificate_enrollment.certificate_parameters.email, null)
          certificate_include_device_serial_number = try(certificate_enrollment.certificate_parameters.include_device_serial_number, null)
          # Key
          key_name               = try(certificate_enrollment.key.name, null)
          key_size               = try(certificate_enrollment.key.size, null)
          key_type               = try(certificate_enrollment.key.type, null)
          ignore_ipsec_key_usage = try(certificate_enrollment.key.ignore_ipsec_key_usage, null)
          # Revocation
          revocation_evaluation_priority                                     = try(certificate_enrollment.revocation.evaluation_priority, null)
          consider_certificate_valid_if_revocation_information_not_reachable = try(certificate_enrollment.revocation.consider_certificate_valid_if_revocation_information_not_reachable, null)
          crl_use_distribution_point_from_the_certificate                    = try(certificate_enrollment.revocation.crl_use_distribution_point_from_the_certificate, null)
          crl_static_urls                                                    = try(certificate_enrollment.revocation.crl_static_urls, null)
          ocsp_url                                                           = try(certificate_enrollment.revocation.ocsp_url, null)
        } if !contains(try(keys(local.data_certificate_enrollment), {}), "${domain.name}:${certificate_enrollment.name}") && (certificate_enrollment.enrollment_type != "ACME")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_certificate_enrollment" "certificate_enrollment" {
  for_each = local.data_certificate_enrollment

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_certificate_enrollment" "certificate_enrollment" {
  for_each = local.resource_certificate_enrollment

  domain                                                             = each.value.domain
  name                                                               = each.value.name
  description                                                        = each.value.description
  enrollment_type                                                    = each.value.enrollment_type
  validation_usage_ipsec_client                                      = each.value.validation_usage_ipsec_client
  validation_usage_ssl_client                                        = each.value.validation_usage_ssl_client
  validation_usage_ssl_server                                        = each.value.validation_usage_ssl_server
  skip_ca_flag_check                                                 = each.value.skip_ca_flag_check
  est_enrollment_url                                                 = each.value.est_enrollment_url
  est_username                                                       = each.value.est_username
  est_password                                                       = each.value.est_password
  est_fingerprint                                                    = each.value.est_fingerprint
  est_source_interface_id                                            = each.value.est_source_interface_id
  est_source_interface_name                                          = each.value.est_source_interface_name
  est_ignore_server_certificate_validation                           = each.value.est_ignore_server_certificate_validation
  scep_enrollment_url                                                = each.value.scep_enrollment_url
  scep_challenge_password                                            = each.value.scep_challenge_password
  scep_retry_period                                                  = each.value.scep_retry_period
  scep_retry_count                                                   = each.value.scep_retry_count
  scep_fingerprint                                                   = each.value.scep_fingerprint
  manual_ca_certificate                                              = each.value.manual_ca_certificate
  manual_ca_only                                                     = each.value.manual_ca_only
  pkcs12_certificate                                                 = each.value.pkcs12_certificate
  pkcs12_certificate_passphrase                                      = each.value.pkcs12_certificate_passphrase
  certificate_include_fqdn                                           = each.value.certificate_include_fqdn
  certificate_custom_fqdn                                            = each.value.certificate_custom_fqdn
  certificate_alternate_fqdn                                         = each.value.certificate_alternate_fqdn
  certificate_include_device_ip                                      = each.value.certificate_include_device_ip
  certificate_common_name                                            = each.value.certificate_common_name
  certificate_organizational_unit                                    = each.value.certificate_organizational_unit
  certificate_organization                                           = each.value.certificate_organization
  certificate_locality                                               = each.value.certificate_locality
  certificate_state                                                  = each.value.certificate_state
  certificate_country_code                                           = each.value.certificate_country_code
  certificate_email                                                  = each.value.certificate_email
  certificate_include_device_serial_number                           = each.value.certificate_include_device_serial_number
  key_name                                                           = each.value.key_name
  key_size                                                           = each.value.key_size
  key_type                                                           = each.value.key_type
  ignore_ipsec_key_usage                                             = each.value.ignore_ipsec_key_usage
  revocation_evaluation_priority                                     = each.value.revocation_evaluation_priority
  consider_certificate_valid_if_revocation_information_not_reachable = each.value.consider_certificate_valid_if_revocation_information_not_reachable
  crl_use_distribution_point_from_the_certificate                    = each.value.crl_use_distribution_point_from_the_certificate
  crl_static_urls                                                    = each.value.crl_static_urls
  ocsp_url                                                           = each.value.ocsp_url
}

##########################################################
###    CERTIFICATE ENROLLMENTS (ACME)
##########################################################
locals {
  resource_certificate_enrollment_acme = {
    for item in flatten([
      for domain in local.domains : [
        for certificate_enrollment in try(domain.objects.certificate_enrollments, {}) : {
          domain                        = domain.name
          name                          = certificate_enrollment.name
          description                   = try(certificate_enrollment.description, local.defaults.fmc.domains.objects.certificate_enrollments.description, null)
          enrollment_type               = certificate_enrollment.enrollment_type
          validation_usage_ipsec_client = try(certificate_enrollment.validation_usage_ipsec_client, null)
          validation_usage_ssl_client   = try(certificate_enrollment.validation_usage_ssl_client, null)
          validation_usage_ssl_server   = try(certificate_enrollment.validation_usage_ssl_server, null)
          skip_ca_flag_check            = try(certificate_enrollment.skip_ca_flag_check, null)
          # ACME
          acme_enrollment_url          = try(certificate_enrollment.acme.enrollment_url, null)
          acme_authentication_protocol = try(certificate_enrollment.acme.authentication_protocol, local.defaults.fmc.domains.objects.certificate_enrollments.acme.authentication_protocol, null)
          acme_authentication_interface_id = try(certificate_enrollment.acme.authentication_interface, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${certificate_enrollment.acme.authentication_interface}"].id
            if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${certificate_enrollment.acme.authentication_interface}")
          })[0] : null
          acme_authentication_interface_name = try(certificate_enrollment.acme.authentication_interface, null)
          acme_source_interface_id = try(certificate_enrollment.acme.source_interface, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${certificate_enrollment.acme.source_interface}"].id
            if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${certificate_enrollment.acme.source_interface}")
          })[0] : null
          acme_source_interface_name = try(certificate_enrollment.acme.source_interface, null)
          acme_ca_only_certificate_id = try(certificate_enrollment.acme.ca_only_certificate, null) != null ? try(
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => fmc_certificate_enrollment.certificate_enrollment["${domain_path}:${certificate_enrollment.acme.ca_only_certificate}"].id
              if contains(keys(fmc_certificate_enrollment.certificate_enrollment), "${domain_path}:${certificate_enrollment.acme.ca_only_certificate}")
            })[0],
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => data.fmc_certificate_enrollment.certificate_enrollment["${domain_path}:${certificate_enrollment.acme.ca_only_certificate}"].id
              if contains(keys(data.fmc_certificate_enrollment.certificate_enrollment), "${domain_path}:${certificate_enrollment.acme.ca_only_certificate}")
            })[0],
          ) : null
          acme_auto_enrollment                  = try(certificate_enrollment.acme.auto_enrollment, null)
          acme_auto_enrollment_lifetime         = try(certificate_enrollment.acme.auto_enrollment_lifetime, null)
          acme_auto_enrollment_key_regeneration = try(certificate_enrollment.acme.auto_enrollment_key_regeneration, null)
          # Certificate Parameters
          certificate_include_fqdn                 = try(certificate_enrollment.certificate_parameters.include_fqdn, null)
          certificate_custom_fqdn                  = try(certificate_enrollment.certificate_parameters.custom_fqdn, null)
          certificate_alternate_fqdn               = try(join(",", certificate_enrollment.certificate_parameters.alternate_fqdns), null)
          certificate_include_device_ip            = try(certificate_enrollment.certificate_parameters.include_device_ip, null)
          certificate_common_name                  = try(certificate_enrollment.certificate_parameters.common_name, null)
          certificate_organizational_unit          = try(certificate_enrollment.certificate_parameters.organizational_unit, null)
          certificate_organization                 = try(certificate_enrollment.certificate_parameters.organization, null)
          certificate_locality                     = try(certificate_enrollment.certificate_parameters.locality, null)
          certificate_state                        = try(certificate_enrollment.certificate_parameters.state, null)
          certificate_country_code                 = try(certificate_enrollment.certificate_parameters.country_code, null)
          certificate_email                        = try(certificate_enrollment.certificate_parameters.email, null)
          certificate_include_device_serial_number = try(certificate_enrollment.certificate_parameters.include_device_serial_number, null)
          # Key
          key_name               = try(certificate_enrollment.key.name, null)
          key_size               = try(certificate_enrollment.key.size, null)
          key_type               = try(certificate_enrollment.key.type, null)
          ignore_ipsec_key_usage = try(certificate_enrollment.key.ignore_ipsec_key_usage, null)
          # Revocation
          revocation_evaluation_priority                                     = try(certificate_enrollment.revocation.evaluation_priority, null)
          consider_certificate_valid_if_revocation_information_not_reachable = try(certificate_enrollment.revocation.consider_certificate_valid_if_revocation_information_not_reachable, null)
          crl_use_distribution_point_from_the_certificate                    = try(certificate_enrollment.revocation.crl_use_distribution_point_from_the_certificate, null)
          crl_static_urls                                                    = try(certificate_enrollment.revocation.crl_static_urls, null)
          ocsp_url                                                           = try(certificate_enrollment.revocation.ocsp_url, null)
        } if !contains(try(keys(local.data_certificate_enrollment), {}), "${domain.name}:${certificate_enrollment.name}") && (certificate_enrollment.enrollment_type == "ACME")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

resource "fmc_certificate_enrollment" "certificate_enrollment_acme" {
  for_each = local.resource_certificate_enrollment_acme

  domain                                                             = each.value.domain
  name                                                               = each.value.name
  description                                                        = each.value.description
  enrollment_type                                                    = each.value.enrollment_type
  validation_usage_ipsec_client                                      = each.value.validation_usage_ipsec_client
  validation_usage_ssl_client                                        = each.value.validation_usage_ssl_client
  validation_usage_ssl_server                                        = each.value.validation_usage_ssl_server
  skip_ca_flag_check                                                 = each.value.skip_ca_flag_check
  acme_enrollment_url                                                = each.value.acme_enrollment_url
  acme_authentication_protocol                                       = each.value.acme_authentication_protocol
  acme_authentication_interface_id                                   = each.value.acme_authentication_interface_id
  acme_authentication_interface_name                                 = each.value.acme_authentication_interface_name
  acme_source_interface_id                                           = each.value.acme_source_interface_id
  acme_source_interface_name                                         = each.value.acme_source_interface_name
  acme_ca_only_certificate_id                                        = each.value.acme_ca_only_certificate_id
  acme_auto_enrollment                                               = each.value.acme_auto_enrollment
  acme_auto_enrollment_lifetime                                      = each.value.acme_auto_enrollment_lifetime
  acme_auto_enrollment_key_regeneration                              = each.value.acme_auto_enrollment_key_regeneration
  certificate_include_fqdn                                           = each.value.certificate_include_fqdn
  certificate_custom_fqdn                                            = each.value.certificate_custom_fqdn
  certificate_alternate_fqdn                                         = each.value.certificate_alternate_fqdn
  certificate_include_device_ip                                      = each.value.certificate_include_device_ip
  certificate_common_name                                            = each.value.certificate_common_name
  certificate_organizational_unit                                    = each.value.certificate_organizational_unit
  certificate_organization                                           = each.value.certificate_organization
  certificate_locality                                               = each.value.certificate_locality
  certificate_state                                                  = each.value.certificate_state
  certificate_country_code                                           = each.value.certificate_country_code
  certificate_email                                                  = each.value.certificate_email
  certificate_include_device_serial_number                           = each.value.certificate_include_device_serial_number
  key_name                                                           = each.value.key_name
  key_size                                                           = each.value.key_size
  key_type                                                           = each.value.key_type
  ignore_ipsec_key_usage                                             = each.value.ignore_ipsec_key_usage
  revocation_evaluation_priority                                     = each.value.revocation_evaluation_priority
  consider_certificate_valid_if_revocation_information_not_reachable = each.value.consider_certificate_valid_if_revocation_information_not_reachable
  crl_use_distribution_point_from_the_certificate                    = each.value.crl_use_distribution_point_from_the_certificate
  crl_static_urls                                                    = each.value.crl_static_urls
  ocsp_url                                                           = each.value.ocsp_url
}

##########################################################
###    CERTIFICATE MAPS
##########################################################
locals {
  data_certificate_maps = {
    for domain in local.data_existing : domain.name => {
      items = {
        for certificate_map in try(domain.objects.certificate_maps, []) : certificate_map.name => {}
      }
    } if length(try(domain.objects.certificate_maps, [])) > 0
  }

  certificate_maps_bulk = try(local.fmc.nac_configuration.certificate_maps_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_certificate_maps = {
    for domain in local.domains : domain.name => [
      for certificate_map in try(domain.objects.certificate_maps, []) : {
        domain      = domain.name
        name        = certificate_map.name
        rules = [
          for rule in try(certificate_map.rules, []) : {
            component = rule.component
            field     = rule.field
            operator  = rule.operator
            value     = rule.value
          }
        ]
      } if !contains(try(keys(local.data_certificate_maps[domain.name].items), []), certificate_map.name)
    ] if length(try(domain.objects.certificate_maps, [])) > 0
  }

  resource_certificate_map = !local.certificate_maps_bulk ? {
    for item in flatten([
      for domain, certificate_maps in local.resource_certificate_maps : [
        for certificate_map in certificate_maps : {
          key  = "${domain}:${certificate_map.name}"
          item = certificate_map
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_certificate_maps" "certificate_maps" {
  for_each = local.data_certificate_maps

  items  = each.value.items
  domain = each.key
}

resource "fmc_certificate_maps" "certificate_maps" {
  for_each = local.certificate_maps_bulk ? local.resource_certificate_maps : {}

  domain = each.key
  items  = { for certificate_map in each.value : certificate_map.name => certificate_map }
}

resource "fmc_certificate_map" "certificate_map" {
  for_each = !local.certificate_maps_bulk ? local.resource_certificate_map : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  rules      = each.value.item.rules
}

##########################################################
###    DNS SERVER GROUPS
##########################################################
locals {
  data_dns_server_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for dns_server_group in try(domain.objects.dns_server_groups, []) : dns_server_group.name => {}
      }
    } if length(try(domain.objects.dns_server_groups, [])) > 0
  }

  dns_server_groups_bulk = try(local.fmc.nac_configuration.dns_server_groups_bulk, local.fmc.nac_configuration.bulk, local.defaults.fmc.nac_configuration.bulk)

  resource_dns_server_groups = {
    for domain in local.domains : domain.name => [
      for dns_server_group in try(domain.objects.dns_server_groups, []) : {
        domain      = domain.name
        name        = dns_server_group.name
        default_domain = try(dns_server_group.default_domain, null)
        retries     = try(dns_server_group.retries, local.defaults.fmc.domains.objects.dns_server_groups.retries, null)
        timeout     = try(dns_server_group.timeout, local.defaults.fmc.domains.objects.dns_server_groups.timeout, null)
        dns_servers = [for dns_server in try(dns_server_group.dns_servers, []) : {ip = dns_server}]
      } if !contains(try(keys(local.data_dns_server_groups[domain.name].items), []), dns_server_group.name)
    ] if length(try(domain.objects.dns_server_groups, [])) > 0
  }

  resource_dns_server_group = !local.dns_server_groups_bulk ? {
    for item in flatten([
      for domain, dns_server_groups in local.resource_dns_server_groups : [
        for dns_server_group in dns_server_groups : {
          key  = "${domain}:${dns_server_group.name}"
          item = dns_server_group
        }
      ]
    ]) : item.key => item
  } : {}
}

data "fmc_dns_server_groups" "dns_server_groups" {
  for_each = local.data_dns_server_groups

  items  = each.value.items
  domain = each.key
}

resource "fmc_dns_server_groups" "dns_server_groups" {
  for_each = local.dns_server_groups_bulk ? local.resource_dns_server_groups : {}

  domain = each.key
  items  = { for dns_server_group in each.value : dns_server_group.name => dns_server_group }
}

resource "fmc_dns_server_group" "dns_server_group" {
  for_each = !local.dns_server_groups_bulk ? local.resource_dns_server_group : {}

  domain      = each.value.item.domain
  name        = each.value.item.name
  default_domain = each.value.item.default_domain
  retries     = each.value.item.retries
  timeout     = each.value.item.timeout
  dns_servers = each.value.item.dns_servers
}
