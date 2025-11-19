##########################################################
###    DEVICE VRF
##########################################################
locals {
  data_device_vrf = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : {
            domain      = domain.name
            name        = vrf.name
            device_name = device.name
            device_id   = data.fmc_device.device["${domain.name}:${device.name}"].id
          }
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }

  resource_device_vrf = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : {
            domain      = domain.name
            device_name = device.name
            name        = vrf.name
            device_id   = local.map_devices["${domain.name}:${device.name}"].id
            description = try(vrf.description, local.defaults.fmc.domains.devices.devices.vrfs.description, null)
            interfaces = concat(
              [for interface in try(vrf.physical_interfaces, []) : {
                id           = try(fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${interface.name}"].id, data.fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${interface.name}"].id)
                logical_name = try(interface.logical_name, data.fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${interface.name}"].logical_name)
                name         = interface.name
              }],
              [for interface in try(vrf.etherchannel_interfaces, []) : {
                id           = try(fmc_device_etherchannel_interface.device_etherchannel_interface["${domain.name}:${device.name}:${interface.name}"].id, data.fmc_device_etherchannel_interface.device_etherchannel_interface["${domain.name}:${device.name}:${interface.name}"].id)
                logical_name = try(interface.logical_name, data.fmc_device_etherchannel_interface.device_etherchannel_interface["${domain.name}:${device.name}:${interface.name}"].logical_name)
                name         = interface.name
              }],
              [for interface in try(vrf.sub_interfaces, []) : {
                id           = try(fmc_device_subinterface.device_subinterface["${domain.name}:${device.name}:${interface.name}"].id, data.fmc_device_subinterface.device_subinterface["${domain.name}:${device.name}:${interface.name}"].id)
                logical_name = try(interface.logical_name, data.fmc_device_subinterface.device_subinterface["${domain.name}:${device.name}:${interface.name}"].logical_name)
                name         = interface.name
              }],
            )
          } if !contains(try(keys(local.data_device_vrf), []), "${domain.name}:${device.name}:${vrf.name}") && vrf.name != "Global"
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }
}

data "fmc_device_vrf" "device_vrf" {
  for_each = local.data_device_vrf

  domain    = each.value.domain
  name      = each.value.name
  device_id = each.value.device_id
}

resource "fmc_device_vrf" "device_vrf" {
  for_each = local.resource_device_vrf

  domain      = each.value.domain
  device_id   = each.value.device_id
  name        = each.value.name
  description = each.value.description
  interfaces  = each.value.interfaces

  depends_on = [
    # fmc_device.module,
    # data.fmc_device.module,
    # fmc_device_physical_interface.module,
    # data.fmc_device_physical_interface.module,
    # fmc_device_etherchannel_interface.module,
    # data.fmc_device_etherchannel_interface.module,
    # fmc_device_subinterface.module,
    # data.fmc_device_subinterface.module,
    # fmc_device_cluster.module,
    # data.fmc_device_cluster.module,
    # fmc_device_ha_pair.module,
    # data.fmc_device_ha_pair.module,
  ]
}


##########################################################
###    DEVICE BFDs
##########################################################
locals {
  resource_device_bfd = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for bfd in try(vrf.bfds, []) : {
              device_name = device.name
              device_id   = local.map_devices["${domain.name}:${device.name}"].id
              domain      = domain.name
              vrf_name    = vrf.name

              hop_type = bfd.hop_type
              bfd_template_id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_bfd_templates["${domain_path}:${bfd.bfd_template}"].id
                if contains(keys(local.map_bfd_templates), "${domain_path}:${bfd.bfd_template}")
              })[0],
              interface_logical_name = bfd.hop_type == "SINGLE_HOP" ? bfd.interface_logical_name : null
              interface_id           = bfd.hop_type == "SINGLE_HOP" ? local.map_interfaces_by_logical_names["${domain.name}:${device.name}:${bfd.interface_logical_name}"].id : null
              slow_timer             = try(bfd.slow_timer, null)

              destination_host_object_id = bfd.hop_type == "MULTI_HOP" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${bfd.destination_host_object}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${bfd.destination_host_object}")
                })[0],
              ) : null
              source_host_object_id = bfd.hop_type == "MULTI_HOP" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${bfd.source_host_object}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${bfd.source_host_object}")
                })[0],
              ) : null
              internal_id = bfd.hop_type == "SINGLE_HOP" ? bfd.interface_logical_name : "${bfd.source_host_object}:${bfd.destination_host_object}"
            }
          ] if vrf.name == "Global"
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.vrf_name}:${item.internal_id}" => item
  }
}

resource "fmc_device_bfd" "device_bfd" {
  for_each = local.resource_device_bfd

  domain                     = each.value.domain
  device_id                  = each.value.device_id
  interface_logical_name     = each.value.interface_logical_name
  interface_id               = each.value.interface_id
  hop_type                   = each.value.hop_type
  slow_timer                 = each.value.slow_timer
  bfd_template_id            = each.value.bfd_template_id
  source_host_object_id      = each.value.source_host_object_id
  destination_host_object_id = each.value.destination_host_object_id

  depends_on = [
    # data.fmc_device.module,
    # fmc_device.module,
    # fmc_device_physical_interface.module,
    # data.fmc_device_physical_interface.module,
    # fmc_device_etherchannel_interface.module,
    # data.fmc_device_etherchannel_interface.module,
    # fmc_device_subinterface.module,
    # data.fmc_device_subinterface.module,
    # data.fmc_device_bgp_general_settings.module,
    # fmc_device_bgp_general_settings.module,
    # fmc_device_bgp.module
  ]
}

##########################################################
###    DEVICE IPv4 STATIC ROUTES
##########################################################
locals {
  resource_device_ipv4_static_route = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for ipv4_static_route in try(vrf.ipv4_static_routes, []) : {
              device_name            = device.name
              device_id              = local.map_devices["${domain.name}:${device.name}"].id
              vrf_name               = vrf.name
              vrf_id                 = vrf.name == "Global" ? null : local.map_vrfs["${domain.name}:${device.name}:${vrf.name}"].id
              domain                 = domain.name
              name                   = ipv4_static_route.name
              interface_logical_name = ipv4_static_route.interface_logical_name
              interface_id           = local.map_interfaces_by_logical_names["${domain.name}:${device.name}:${ipv4_static_route.interface_logical_name}"].id
              destination_networks = [for destination_network in ipv4_static_route.selected_networks : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network}")
                  })[0],
                )
              }]
              metric               = try(ipv4_static_route.metric, local.defaults.fmc.domains.devices.devices.vrfs.ipv4_static_routes.metric, null)
              is_tunneled          = try(ipv4_static_route.is_tunneled, local.defaults.fmc.domains.devices.devices.vrfs.ipv4_static_routes.is_tunneled, null)
              gateway_host_literal = try(ipv4_static_route.gateway.literal, null)
              gateway_host_object_id = try(ipv4_static_route.gateway.object, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${ipv4_static_route.gateway.object}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${ipv4_static_route.gateway.object}")
                })[0],
              ) : null
            }
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.vrf_name}:${item.name}" => item
  }
}

resource "fmc_device_ipv4_static_route" "device_ipv4_static_route" {
  for_each = local.resource_device_ipv4_static_route

  domain                 = each.value.domain
  device_id              = each.value.device_id
  vrf_id                 = each.value.vrf_id
  interface_logical_name = each.value.interface_logical_name
  interface_id           = each.value.interface_id
  destination_networks   = each.value.destination_networks
  metric                 = each.value.metric
  gateway_host_literal   = each.value.gateway_host_literal
  gateway_host_object_id = each.value.gateway_host_object_id
  is_tunneled            = each.value.is_tunneled

  depends_on = [
    # data.fmc_hosts.module,
    # fmc_hosts.module,
    # fmc_host.module,
    # data.fmc_networks.module,
    # fmc_networks.module,
    # fmc_network_groups.module,
    # data.fmc_device.module,
    # fmc_device.module,
    # fmc_device_ha_pair.module,
    # data.fmc_device_ha_pair.module,
    # fmc_device_cluster.module,
    # data.fmc_device_cluster.module,
    # fmc_device_physical_interface.module,
    # data.fmc_device_physical_interface.module,
    # fmc_device_etherchannel_interface.module,
    # data.fmc_device_etherchannel_interface.module,
    # fmc_device_subinterface.module,
    # data.fmc_device_subinterface.module,
  ]
}

##########################################################
###    DEVICE IPv6 STATIC ROUTES
##########################################################
locals {
  resource_device_ipv6_static_route = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for ipv6_static_route in try(vrf.ipv6_static_routes, []) : {
              device_name            = device.name
              device_id              = local.map_devices["${domain.name}:${device.name}"].id
              vrf_name               = vrf.name
              vrf_id                 = vrf.name == "Global" ? null : local.map_vrfs["${domain.name}:${device.name}:${vrf.name}"].id
              domain                 = domain.name
              name                   = ipv6_static_route.name
              interface_logical_name = ipv6_static_route.interface_logical_name
              interface_id           = local.map_interfaces_by_logical_names["${domain.name}:${device.name}:${ipv6_static_route.interface_logical_name}"].id
              destination_networks = [for destination_network in ipv6_static_route.selected_networks : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${destination_network}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${destination_network}")
                  })[0],
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_group_objects["${domain_path}:${destination_network}"].id
                    if contains(keys(local.map_network_group_objects), "${domain_path}:${destination_network}")
                  })[0],
                )
              }]
              metric               = try(ipv6_static_route.metric, local.defaults.fmc.domains.devices.devices.vrfs.ipv6_static_routes.metric, null)
              is_tunneled          = try(ipv6_static_route.is_tunneled, local.defaults.fmc.domains.devices.devices.vrfs.ipv6_static_routes.is_tunneled, null)
              gateway_host_literal = try(ipv6_static_route.gateway.literal, null)
              gateway_host_object_id = try(ipv6_static_route.gateway.object, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${ipv6_static_route.gateway.object}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${ipv6_static_route.gateway.object}")
                })[0],
              ) : null
            }
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.vrf_name}:${item.name}" => item
  }

}

resource "fmc_device_ipv6_static_route" "device_ipv6_static_route" {
  for_each = local.resource_device_ipv6_static_route

  domain                 = each.value.domain
  device_id              = each.value.device_id
  vrf_id                 = each.value.vrf_id
  interface_logical_name = each.value.interface_logical_name
  interface_id           = each.value.interface_id
  destination_networks   = each.value.destination_networks
  metric                 = each.value.metric
  gateway_host_literal   = each.value.gateway_host_literal
  gateway_host_object_id = each.value.gateway_host_object_id
  is_tunneled            = each.value.is_tunneled

  depends_on = [
    # data.fmc_hosts.module,
    # fmc_hosts.module,
    # fmc_host.module,
    # data.fmc_networks.module,
    # fmc_networks.module,
    # fmc_network_groups.module,
    # data.fmc_device.module,
    # fmc_device.module,
    # fmc_device_ha_pair.module,
    # data.fmc_device_ha_pair.module,
    # fmc_device_cluster.module,
    # data.fmc_device_cluster.module,
    # fmc_device_physical_interface.module,
    # data.fmc_device_physical_interface.module,
    # fmc_device_etherchannel_interface.module,
    # data.fmc_device_etherchannel_interface.module,
    # fmc_device_subinterface.module,
    # data.fmc_device_subinterface.module,
  ]
}

##########################################################
###    DEVICE BGP GENERAL SETTINGS
##########################################################
locals {
  data_device_bgp_general_settings = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : {
          as_number   = device.bgp_general_settings.as_number
          device_name = device.name
          device_id   = local.map_devices["${domain.name}:${device.name}"].id
          domain      = domain.name
        } if contains(keys(device), "bgp_general_settings")
      ]
    ]) : "${item.domain}:${item.device_name}" => item
  }

  resource_device_bgp_general_settings = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : {
          domain      = domain.name
          device_name = device.name
          device_id   = local.map_devices["${domain.name}:${device.name}"].id
          as_number   = device.bgp_general_settings.as_number

          aggregate_timer                      = try(device.bgp_general_settings.aggregate_timer, local.defaults.fmc.domains.devices.devices.bgp_general_settings.aggregate_timer, null)
          as_number_in_path_attribute          = try(device.bgp_general_settings.as_number_in_path_attribute, local.defaults.fmc.domains.devices.devices.bgp_general_settings.as_number_in_path_attribute, null)
          compare_med_from_different_neighbors = try(device.bgp_general_settings.compare_med_from_different_neighbors, local.defaults.fmc.domains.devices.devices.bgp_general_settings.compare_med_from_different_neighbors, null)
          compare_router_id_in_path            = try(device.bgp_general_settings.compare_router_id_in_path, local.defaults.fmc.domains.devices.devices.bgp_general_settings.compare_router_id_in_path, null)
          default_local_preference             = try(device.bgp_general_settings.default_local_preference, local.defaults.fmc.domains.devices.devices.bgp_general_settings.default_local_preference, null)
          enforce_first_peer_as                = try(device.bgp_general_settings.enforce_first_peer_as, local.defaults.fmc.domains.devices.devices.bgp_general_settings.enforce_first_peer_as, null)
          graceful_restart                     = try(device.bgp_general_settings.graceful_restart, local.defaults.fmc.domains.devices.devices.bgp_general_settings.graceful_restart, null)
          graceful_restart_restart_time        = try(device.bgp_general_settings.graceful_restart_restart_time, local.defaults.fmc.domains.devices.devices.bgp_general_settings.graceful_restart_restart_time, null)
          graceful_restart_stale_path_time     = try(device.bgp_general_settings.graceful_restart_stale_path_time, local.defaults.fmc.domains.devices.devices.bgp_general_settings.graceful_restart_stale_path_time, null)
          hold_time                            = try(device.bgp_general_settings.hold_time, local.defaults.fmc.domains.devices.devices.bgp_general_settings.hold_time, null)
          keepalive_interval                   = try(device.bgp_general_settings.keepalive_interval, local.defaults.fmc.domains.devices.devices.bgp_general_settings.keepalive_interval, null)
          log_neighbor_changes                 = try(device.bgp_general_settings.log_neighbor_changes, local.defaults.fmc.domains.devices.devices.bgp_general_settings.log_neighbor_changes, null)
          min_hold_time                        = try(device.bgp_general_settings.min_hold_time, local.defaults.fmc.domains.devices.devices.bgp_general_settings.min_hold_time, null)
          missing_med_as_best                  = try(device.bgp_general_settings.missing_med_as_best, local.defaults.fmc.domains.devices.devices.bgp_general_settings.missing_med_as_best, null)
          next_hop_address_tracking            = try(device.bgp_general_settings.next_hop_address_tracking, local.defaults.fmc.domains.devices.devices.bgp_general_settings.next_hop_address_tracking, null)
          next_hop_delay_interval              = try(device.bgp_general_settings.next_hop_delay_interval, local.defaults.fmc.domains.devices.devices.bgp_general_settings.next_hop_delay_interval, null)
          pick_best_med                        = try(device.bgp_general_settings.pick_best_med, local.defaults.fmc.domains.devices.devices.bgp_general_settings.pick_best_med, null)
          reset_session_upon_failover          = try(device.bgp_general_settings.reset_session_upon_failover, local.defaults.fmc.domains.devices.devices.bgp_general_settings.reset_session_upon_failover, null)
          router_id                            = try(device.bgp_general_settings.router_id, local.defaults.fmc.domains.devices.devices.bgp_general_settings.router_id, null)
          scanning_interval                    = try(device.bgp_general_settings.scanning_interval, local.defaults.fmc.domains.devices.devices.bgp_general_settings.scanning_interval, null)
          tcp_path_mtu_discovery               = try(device.bgp_general_settings.tcp_path_mtu_discovery, local.defaults.fmc.domains.devices.devices.bgp_general_settings.tcp_path_mtu_discovery, null)
          use_dot_notation                     = try(device.bgp_general_settings.use_dot_notation, local.defaults.fmc.domains.devices.devices.bgp_general_settings.use_dot_notation, null)
        } if contains(keys(device), "bgp_general_settings")
      ]
    ]) : "${item.domain}:${item.device_name}" => item
  }
}

data "fmc_device_bgp_general_settings" "device_bgp_general_settings" {
  for_each = local.data_device_bgp_general_settings

  domain    = each.value.domain
  as_number = each.value.as_number
  device_id = each.value.device_id
}

resource "fmc_device_bgp_general_settings" "device_bgp_general_settings" {
  for_each = local.resource_device_bgp_general_settings

  domain                               = each.value.domain
  device_id                            = each.value.device_id
  as_number                            = each.value.as_number
  aggregate_timer                      = each.value.aggregate_timer
  as_number_in_path_attribute          = each.value.as_number_in_path_attribute
  compare_med_from_different_neighbors = each.value.compare_med_from_different_neighbors
  compare_router_id_in_path            = each.value.compare_router_id_in_path
  default_local_preference             = each.value.default_local_preference
  enforce_first_peer_as                = each.value.enforce_first_peer_as
  graceful_restart                     = each.value.graceful_restart
  graceful_restart_restart_time        = each.value.graceful_restart_restart_time
  graceful_restart_stale_path_time     = each.value.graceful_restart_stale_path_time
  hold_time                            = each.value.hold_time
  keepalive_interval                   = each.value.keepalive_interval
  log_neighbor_changes                 = each.value.log_neighbor_changes
  min_hold_time                        = each.value.min_hold_time
  missing_med_as_best                  = each.value.missing_med_as_best
  next_hop_address_tracking            = each.value.next_hop_address_tracking
  next_hop_delay_interval              = each.value.next_hop_delay_interval
  pick_best_med                        = each.value.pick_best_med
  reset_session_upon_failover          = each.value.reset_session_upon_failover
  router_id                            = each.value.router_id
  scanning_interval                    = each.value.scanning_interval
  tcp_path_mtu_discovery               = each.value.tcp_path_mtu_discovery
  use_dot_notation                     = each.value.use_dot_notation

  depends_on = [
    # data.fmc_device.module,
    # fmc_device.module,
    # fmc_device_ha_pair.module,
    # data.fmc_device_ha_pair.module,
    # fmc_device_cluster.module,
    # data.fmc_device_cluster.module,
  ]
}

##########################################################
###    DEVICE BGP
##########################################################
locals {
  resource_device_bgp = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : {
            domain      = domain.name
            device_name = device.name
            device_id   = local.map_devices["${domain.name}:${device.name}"].id
            vrf_name    = vrf.name
            vrf_id      = vrf.name == "Global" ? null : local.map_vrfs["${domain.name}:${device.name}:${vrf.name}"].id

            ipv4_aggregate_addresses = [for ipv4_aggregate_address in try(vrf.bgp.ipv4_aggregate_addresses, {}) : {
              advertise_map_id = try(local.map_route_maps[ipv4_aggregate_address.advertise_map].id, null)
              attribute_map_id = try(local.map_route_maps[ipv4_aggregate_address.attribute_map].id, null)
              filter           = try(ipv4_aggregate_address.filter, null)
              generate_as      = try(ipv4_aggregate_address.generate_as, null)
              network_id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${ipv4_aggregate_address.network}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${ipv4_aggregate_address.network}")
              })[0],
              suppress_map_id = try(local.map_route_maps[ipv4_aggregate_address.suppress_map].id, null)
            }]
            ipv4_auto_summary                 = try(vrf.bgp.ipv4_auto_summary, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_auto_summary, null)
            ipv4_redistribute_ibgp_into_igp   = try(vrf.bgp.ipv4_redistribute_ibgp_into_igp, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_redistribute_ibgp_into_igp, null)
            ipv4_suppress_inactive_routes     = try(vrf.bgp.ipv4_suppress_inactive_routes, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_suppress_inactive_routes, null)
            ipv4_default_information_orginate = try(vrf.bgp.ipv4_default_information_orginate, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_default_information_orginate, null)
            ipv4_external_distance            = try(vrf.bgp.ipv4_external_distance, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_external_distance, null)
            ipv4_filterings = [for ipv4_filter in try(vrf.bgp.ipv4_filterings, {}) : {
              access_list_id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_standard_access_lists["${domain_path}:${ipv4_filter.access_list}"].id
                if contains(keys(local.map_standard_access_lists), "${domain_path}:${ipv4_filter.access_list}")
              })[0],
              direction  = ipv4_filter.direction
              process_id = try(ipv4_filter.process_id, null)
              protocol   = try(ipv4_filter.protocol, null)
            }]
            ipv4_number_of_ebgp_paths = try(vrf.bgp.ipv4_number_of_ebgp_paths, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_number_of_ebgp_paths, null)
            ipv4_number_of_ibgp_paths = try(vrf.bgp.ipv4_number_of_ibgp_paths, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_number_of_ibgp_paths, null)
            ipv4_internal_distance    = try(vrf.bgp.ipv4_internal_distance, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_internal_distance, null)
            ipv4_learned_route_map_id = try(local.map_route_maps[vrf.bgp.ipv4_learned_route_map].id, null)
            ipv4_local_distance       = try(vrf.bgp.ipv4_local_distance, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_local_distance, null)
            ipv4_neighbors = [for ipv4_neighbor in try(vrf.bgp.ipv4_neighbors, {}) : {
              enable_address                  = try(ipv4_neighbor.enable_address, null)
              address                         = try(ipv4_neighbor.address, null)
              authentication_password         = try(ipv4_neighbor.authentication_password, null)
              bfd_fallover                    = try(ipv4_neighbor.bfd_fallover, null)
              customized_accept_both_as       = try(ipv4_neighbor.customized_accept_both_as, null)
              customized_local_as_number      = try(ipv4_neighbor.customized_local_as_number, null)
              customized_no_prepend           = try(ipv4_neighbor.customized_no_prepend, null)
              customized_replace_as           = try(ipv4_neighbor.customized_replace_as, null)
              description                     = try(ipv4_neighbor.description, null)
              disable_connection_verification = try(ipv4_neighbor.disable_connection_verification, null)
              filter_access_lists = [for filter_access_list in try(ipv4_neighbor.filter_access_lists, {}) : {
                access_list_id = values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_standard_access_lists["${domain_path}:${filter_access_list.access_list}"].id
                  if contains(keys(local.map_standard_access_lists), "${domain_path}:${filter_access_list.access_list}")
                })[0],
                update_direction = filter_access_list.update_direction
              }]
              filter_as_paths = [for filter_as_path in try(ipv4_neighbor.filter_as_paths, {}) : {
                as_path_id       = null
                as_path_name     = null
                update_direction = try(filter_as_path.update_direction, null)
              }]
              filter_maximum_prefixes = try(ipv4_neighbor.filter_maximum_prefixes, null)
              filter_prefix_lists = [for filter_prefix_list in try(ipv4_neighbor.filter_prefix_lists, {}) : {
                prefix_list_id   = null
                update_direction = try(filter_prefix_list.update_direction, null)
              }]
              filter_restart_interval = try(ipv4_neighbor.filter_restart_interval, null)
              filter_route_maps = [for filter_route_map in try(ipv4_neighbor.filter_route_maps, {}) : {
                route_map_id     = try(local.map_route_maps[filter_route_map.route_map].id, null)
                update_direction = try(filter_route_map.update_direction, null)
              }]
              filter_threshold_value               = try(ipv4_neighbor.filter_threshold_value, null)
              filter_warning_only                  = try(ipv4_neighbor.filter_warning_only, null)
              routes_generate_default_route_map_id = try(local.map_route_maps[ipv4_neighbor.routes_generate_default_route_map].id, null)
              hold_time                            = try(ipv4_neighbor.hold_time, null)
              keepalive_interval                   = try(ipv4_neighbor.keepalive_interval, null)
              max_hop_count                        = try(ipv4_neighbor.max_hop_count, null)
              minimum_hold_time                    = try(ipv4_neighbor.minimum_hold_time, null)
              next_hop_self                        = try(ipv4_neighbor.next_hop_self, null)
              remote_as                            = try(ipv4_neighbor.remote_as, null)
              routes_advertise_maps = [for routes_advertise_map in try(ipv4_neighbor.routes_advertise_maps, {}) : {
                advertise_map_id      = try(local.map_route_maps[routes_advertise_map.advertise_map].id, null),
                exist_nonexist_map_id = try(local.map_route_maps[routes_advertise_map.exist_nonexist_map].id, null),
                use_exist             = try(routes_advertise_map.use_exist, null)
              }]
              routes_advertisement_interval = try(ipv4_neighbor.routes_advertisement_interval, null)
              routes_remove_private_as      = try(ipv4_neighbor.routes_remove_private_as, null)
              send_community_attribute      = try(ipv4_neighbor.send_community_attribute, null)
              shutdown_administratively     = try(ipv4_neighbor.shutdown_administratively, null)
              tcp_path_mtu_discovery        = try(ipv4_neighbor.tcp_path_mtu_discovery, null)
              tcp_transport_mode            = try(ipv4_neighbor.tcp_transport_mode, null)
              version                       = try(ipv4_neighbor.version, null)
              weight                        = try(ipv4_neighbor.weight, null)
              update_source_interface_id    = try(local.map_interfaces_by_logical_names["${domain.name}:${device.name}:${ipv4_neighbor.update_source_interface}"].id, null)
            }]
            ipv4_networks = [for ipv4_network in try(vrf.bgp.ipv4_networks, {}) : {
              network_id = try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_objects["${domain_path}:${ipv4_network.network}"].id
                  if contains(keys(local.map_network_objects), "${domain_path}:${ipv4_network.network}")
                })[0],
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_network_group_objects["${domain_path}:${ipv4_network.network}"].id
                  if contains(keys(local.map_network_group_objects), "${domain_path}:${ipv4_network.network}")
                })[0],
              )
              route_map_id = try(local.map_route_maps[ipv4_network.route_map].id, null)
            }]
            ipv4_redistributions = [for ipv4_redistribution in try(vrf.bgp.ipv4_redistributions, {}) : {
              match_external1      = try(ipv4_redistribution.match_external1, null)
              match_external2      = try(ipv4_redistribution.match_external2, null)
              match_internal       = try(ipv4_redistribution.match_internal, null)
              match_nssa_external1 = try(ipv4_redistribution.match_nssa_external1, null)
              match_nssa_external2 = try(ipv4_redistribution.match_nssa_external2, null)
              metric               = try(ipv4_redistribution.metric, null)
              process_id           = try(ipv4_redistribution.process_id, null)
              route_map_id         = try(local.map_route_maps[ipv4_redistribution.route_map].id, null)
              source_protocol      = try(ipv4_redistribution.source_protocol, null)
            }]
            ipv4_route_injections = [for ipv4_route_injection in try(vrf.bgp.ipv4_route_injections, {}) : {
              exist_route_map_id  = try(local.map_route_maps[ipv4_route_injection.exist_route_map].id, null)
              inject_route_map_id = try(local.map_route_maps[ipv4_route_injection.inject_route_map].id, null)
              inherit_attributes  = try(ipv4_route_injection.inherit_attributes, null)
            }]
            ipv4_synchronization = try(vrf.bgp.ipv4_synchronization, local.defaults.fmc.domains.devices.devices.vrfs.bgp.ipv4_synchronization, null)
          } if contains(keys(vrf), "bgp") && vrf.name == "Global"
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.vrf_name}" => item
  }
}

resource "fmc_device_bgp" "device_bgp" {
  for_each = local.resource_device_bgp

  domain                            = each.value.domain
  device_id                         = each.value.device_id
  ipv4_aggregate_addresses          = each.value.ipv4_aggregate_addresses
  ipv4_auto_summary                 = each.value.ipv4_auto_summary
  ipv4_redistribute_ibgp_into_igp   = each.value.ipv4_redistribute_ibgp_into_igp
  ipv4_suppress_inactive_routes     = each.value.ipv4_suppress_inactive_routes
  ipv4_default_information_orginate = each.value.ipv4_default_information_orginate
  ipv4_external_distance            = each.value.ipv4_external_distance
  ipv4_filterings                   = each.value.ipv4_filterings
  ipv4_number_of_ebgp_paths         = each.value.ipv4_number_of_ebgp_paths
  ipv4_number_of_ibgp_paths         = each.value.ipv4_number_of_ibgp_paths
  ipv4_internal_distance            = each.value.ipv4_internal_distance
  ipv4_learned_route_map_id         = each.value.ipv4_learned_route_map_id
  ipv4_local_distance               = each.value.ipv4_local_distance
  ipv4_neighbors                    = each.value.ipv4_neighbors
  ipv4_networks                     = each.value.ipv4_networks
  ipv4_redistributions              = each.value.ipv4_redistributions
  ipv4_route_injections             = each.value.ipv4_route_injections
  ipv4_synchronization              = each.value.ipv4_synchronization

  depends_on = [
    # data.fmc_device.module,
    # fmc_device.module,
    # fmc_device_ha_pair.module,
    # data.fmc_device_ha_pair.module,
    # fmc_device_cluster.module,
    # data.fmc_device_cluster.module,
    # data.fmc_device_bgp_general_settings.module,
    # fmc_device_bgp_general_settings.module,
    # data.fmc_hosts.module,
    # fmc_hosts.module,
    # fmc_host.module,
    # data.fmc_networks.module,
    # fmc_networks.module,
    # data.fmc_ranges.module,
    # fmc_ranges.module,
    # fmc_network_groups.module,
    # fmc_device_physical_interface.module,
    # data.fmc_device_physical_interface.module,
    # fmc_device_etherchannel_interface.module,
    # data.fmc_device_etherchannel_interface.module,
    # fmc_device_subinterface.module,
    # data.fmc_device_subinterface.module
  ]
}
