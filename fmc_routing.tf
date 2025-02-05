##########################################################
###    Content of the file:
##########################################################
#
###
#  Resources
####
# resource "fmc_device_vrf" "module" {
# resource "fmc_bfd_template" "module" {
# resource "fmc_device_bfd" "module" {
# resource "fmc_device_ipv4_static_route" "module" {
# resource "fmc_device_vrf_ipv4_static_route" "module" {
# resource "fmc_device_bgp_general_settings" "module" {
# resource "fmc_device_bgp" "module" {
#
###  
#  Local variables
###
# local.resource_vrf
# local.resource_bfd_template
# local.resource_bfd
# local.resource_ipv4_static_route
# local.resource_vrf_ipv4_static_route
# local.resource_bgp_general_setting
# local.resource_bgp_global
#
# local.map_bfd_templates
###

##########################################################
###    VRF
##########################################################
locals {

  resource_vrf = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            {
              device_name = device.name
              name        = vrf.name
              device_id   = local.map_devices[device.name].id
              domain_name = domain.name
              description = try(vrf.description, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].description, null)
              interfaces = concat([for interface in try(vrf.physical_interfaces, []) : {
                interface_id           = try(fmc_device_physical_interface.module["${device.name}:${interface.name}"].id, data.fmc_device_physical_interface.module["${device.name}:${interface.name}"].id, null)
                interface_logical_name = try(interface.logical_name, data.fmc_device_physical_interface.module["${device.name}:${interface.name}"].logical_name, null)
                interface_name         = interface.name
                }],
                [
                  for interface in try(vrf.etherchannel_interfaces, []) : {
                    interface_id           = try(fmc_device_etherchannel_interface.module["${device.name}:${interface.name}"].id, data.fmc_device_etherchannel_interface.module["${device.name}:${interface.name}"].id, null)
                    interface_logical_name = try(interface.logical_name, data.fmc_device_etherchannel_interface.module["${device.name}:${interface.name}"].logical_name, null)
                    interface_name         = interface.name
                }],
                [
                  for interface in try(vrf.sub_interfaces, []) : {
                    interface_id           = try(fmc_device_subinterface.module["${device.name}:${interface.name}"].id, data.fmc_device_subinterface.module["${device.name}:${interface.name}"].id, null)
                    interface_logical_name = try(interface.logical_name, data.fmc_device_subinterface.module["${device.name}:${interface.name}"].logical_name, null)
                    interface_name         = interface.name
                }],
              )
          }] if !contains(try(keys(local.data_vrf), []), "${device.name}:${vrf.name}") && vrf.name != "Global"
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_vrf), []), "${item.device_name}:${item.name}") #The device name is unique across the different domains.
  }

}

resource "fmc_device_vrf" "module" {
  for_each = local.resource_vrf

  # Mandatory  
  device_id = each.value.device_id
  name      = each.value.name

  # Optional
  description = each.value.description
  interfaces  = each.value.interfaces

  domain = each.value.domain_name

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
  ]

}

##########################################################
###    BFD TEMPLATES
##########################################################
locals {

  resource_bfd_template = {
    for item in flatten([
      for domain in local.domains : [
        for bfd_template in try(domain.objects.bfd_templates, []) : [
          {
            name     = bfd_template.name
            hop_type = bfd_template.hop_type
            echo     = bfd_template.echo ? "ENABLED" : "DISABLED"

            interval_time           = try(bfd_template.interval_time, null)
            min_transmit            = try(bfd_template.min_transmit, null)
            tx_rx_multiplier        = try(bfd_template.tx_rx_multiplier, null)
            min_receive             = try(bfd_template.min_receive, null)
            authentication_password = try(bfd_template.authentication_password, null)
            authentication_key_id   = try(bfd_template.authentication_key_id, null)
            authentication_type     = try(bfd_template.authentication_type, null)
            domain_name             = domain.name
        }]
      ]
    ]) : item.name => item if contains(keys(item), "name") && !contains(try(keys(local.data_bfd_template), []), item.name)
  }

}
resource "fmc_bfd_template" "module" {
  for_each = local.resource_bfd_template

  name   = each.value.name
  domain = each.value.domain_name

  hop_type                = each.value.hop_type
  echo                    = each.value.echo
  interval_time           = each.value.interval_time
  min_transmit            = each.value.min_transmit
  tx_rx_multiplier        = each.value.tx_rx_multiplier
  min_receive             = each.value.min_receive
  authentication_password = each.value.authentication_password
  authentication_key_id   = each.value.authentication_key_id
  authentication_type     = each.value.authentication_type
}



##########################################################
###    BFDs
##########################################################
locals {

  resource_bfd = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for bfd in try(device.bfds, []) : [
            {
              device_name = device.name
              device_id   = local.map_devices[device.name].id
              domain_name = domain.name

              interface_logical_name = bfd.interface_logical_name
              interface_id           = try(local.map_interface_logical_names["${device.name}:${bfd.interface_logical_name}"].id, null)
              hop_type               = bfd.hop_type
              slow_timer             = try(bfd.slow_timer, null)
              bfd_template_id        = local.map_bfd_templates[bfd.bfd_template].id
            }
          ] if !contains(try(keys(local.data_bfd), []), "${device.name}:${bfd.interface_logical_name}")
        ]
      ]
    ]) : "${item.device_name}:${item.interface_logical_name}" => item if contains(keys(item), "interface_logical_name") #&& !contains(try(keys(local.data_bfd), []), "${item.device_name}:${item.interface_logical_name}") #The device name is unique across the different domains.
  }

}

resource "fmc_device_bfd" "module" {
  for_each = local.resource_bfd

  # Mandatory
  device_id              = each.value.device_id
  interface_logical_name = each.value.interface_logical_name
  interface_id           = each.value.interface_id
  hop_type               = each.value.hop_type
  slow_timer             = each.value.slow_timer
  bfd_template_id        = each.value.bfd_template_id

  depends_on = [
    data.fmc_device.module,
    fmc_device.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
    data.fmc_device_bgp_general_settings.module,
    fmc_device_bgp_general_settings.module,
    fmc_device_bgp.module
  ]

}

##########################################################
###    IPv4 STATIC ROUTES
##########################################################
locals {

  resource_ipv4_static_route = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for ipv4_static_route in try(vrf.ipv4_static_routes, []) :
            {
              device_name            = device.name
              device_id              = local.map_devices[device.name].id
              domain_name            = domain.name
              name                   = ipv4_static_route.name
              interface_logical_name = ipv4_static_route.interface_logical_name
              interface_id           = local.map_interface_logical_names["${device.name}:${ipv4_static_route.interface_logical_name}"].id
              destination_networks = [for destination_network in ipv4_static_route.selected_networks : {
                id = try(local.map_network_objects[destination_network].id, local.map_network_group_objects[destination_network].id)
              }]
              metric_value           = ipv4_static_route.metric
              gateway_host_literal   = try(ipv4_static_route.gateway.literal, null)
              gateway_host_object_id = try(local.map_network_objects[ipv4_static_route.gateway.object].id, local.map_network_group_objects[ipv4_static_route.gateway.object].id, null)
            }
          ] if vrf.name == "Global"
        ]
      ]
    ]) : "${item.device_name}:Global:${item.name}" => item if contains(keys(item), "name")
  }

  resource_vrf_ipv4_static_route = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for ipv4_static_route in try(vrf.ipv4_static_routes, []) :
            {
              device_name            = device.name
              device_id              = local.map_devices[device.name].id
              vrf_id                 = local.map_vrfs["${device.name}:${vrf.name}"].id
              vrf_name               = vrf.name
              domain_name            = domain.name
              name                   = ipv4_static_route.name
              interface_logical_name = ipv4_static_route.interface_logical_name
              interface_id           = local.map_interface_logical_names["${device.name}:${ipv4_static_route.interface_logical_name}"].id
              destination_networks = [for destination_network in ipv4_static_route.selected_networks : {
                id = try(local.map_network_objects[destination_network].id, local.map_network_group_objects[destination_network].id)
              }]
              metric_value           = ipv4_static_route.metric
              gateway_host_literal   = try(ipv4_static_route.gateway.literal, null)
              gateway_host_object_id = try(local.map_network_objects[ipv4_static_route.gateway.object].id, local.map_network_group_objects[ipv4_static_route.gateway.object].id, null)
            }
          ] if vrf.name != "Global"
        ]
      ]
    ]) : "${item.device_name}:${item.vrf_name}:${item.name}" => item if contains(keys(item), "name")
  }

}

resource "fmc_device_ipv4_static_route" "module" {
  for_each = local.resource_ipv4_static_route

  # Mandatory
  device_id              = each.value.device_id
  interface_logical_name = each.value.interface_logical_name
  interface_id           = each.value.interface_id
  destination_networks   = each.value.destination_networks
  metric_value           = each.value.metric_value
  gateway_host_literal   = each.value.gateway_host_literal
  gateway_host_object_id = each.value.gateway_host_object_id

  # Optional
  domain = each.value.domain_name

  depends_on = [
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    fmc_network_groups.module,
    data.fmc_device.module,
    fmc_device.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
  ]
}

resource "fmc_device_vrf_ipv4_static_route" "module" {
  for_each = local.resource_vrf_ipv4_static_route

  # Mandatory
  vrf_id                 = each.value.vrf_id
  device_id              = each.value.device_id
  interface_logical_name = each.value.interface_logical_name
  interface_id           = each.value.interface_id
  destination_networks   = each.value.destination_networks
  metric_value           = each.value.metric_value
  gateway_host_literal   = each.value.gateway_host_literal
  gateway_host_object_id = each.value.gateway_host_object_id

  # Optional
  domain = each.value.domain_name

  depends_on = [
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    fmc_network_groups.module,
    data.fmc_device.module,
    fmc_device.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
    fmc_device_vrf.module,
    data.fmc_device_vrf.module
  ]
}

##########################################################
###    BGP - General Settings
##########################################################
locals {

  resource_bgp_general_setting = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : {
          # Mandatory
          device_name = device.name
          device_id   = local.map_devices[device.name].id
          as_number   = device.bgp_general_settings.as_number
          # Optional
          aggregate_timer                      = try(device.bgp_general_settings.aggregate_timer, null)
          as_number_in_path_attribute          = try(device.bgp_general_settings.as_number_in_path_attribute, null)
          compare_med_from_different_neighbors = try(device.bgp_general_settings.compare_med_from_different_neighbors, null)
          compare_router_id_in_path            = try(device.bgp_general_settings.compare_router_id_in_path, null)
          default_local_preference             = try(device.bgp_general_settings.default_local_preference, null)
          domain_name                          = domain.name
          enforce_first_peer_as                = try(device.bgp_general_settings.enforce_first_peer_as, null)
          graceful_restart                     = try(device.bgp_general_settings.graceful_restart, null)
          graceful_restart_restart_time        = try(device.bgp_general_settings.graceful_restart_restart_time, null)
          graceful_restart_stale_path_time     = try(device.bgp_general_settings.graceful_restart_stale_path_time, null)
          hold_time                            = try(device.bgp_general_settings.hold_time, null)
          keepalive_interval                   = try(device.bgp_general_settings.keepalive_interval, null)
          log_neighbor_changes                 = try(device.bgp_general_settings.log_neighbor_changes, null)
          min_hold_time                        = try(device.bgp_general_settings.min_hold_time, null)
          missing_med_as_best                  = try(device.bgp_general_settings.missing_med_as_best, null)
          next_hop_address_tracking            = try(device.bgp_general_settings.next_hop_address_tracking, null)
          next_hop_delay_interval              = try(device.bgp_general_settings.next_hop_delay_interval, null)
          pick_best_med                        = try(device.bgp_general_settings.pick_best_med, null)
          reset_session_upon_failover          = try(device.bgp_general_settings.reset_session_upon_failover, null)
          router_id                            = try(device.bgp_general_settings.router_id, null)
          scanning_interval                    = try(device.bgp_general_settings.scanning_interval, null)
          tcp_path_mtu_discovery               = try(device.bgp_general_settings.tcp_path_mtu_discovery, null)
          use_dot_notation                     = try(device.bgp_general_settings.use_dot_notation, null)

        } if contains(keys(device), "bgp_general_settings") && !contains(try(keys(local.data_bgp_general_setting), []), "${device.name}:BGP")
      ]
    ]) : "${item.device_name}:BGP" => item if contains(keys(item), "device_name") #&& !contains(try(keys(local.data_bgp_general_setting), []), "${item.device_name}:BGP")
  }

}

resource "fmc_device_bgp_general_settings" "module" {
  for_each = local.resource_bgp_general_setting
  # Mandatory
  device_id = each.value.device_id
  as_number = each.value.as_number
  # Optional
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

  domain = each.value.domain_name

  depends_on = [
    data.fmc_device.module,
    fmc_device.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
  ]
}

##########################################################
###    BGP - Global
##########################################################
locals {

  resource_bgp_global = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) :
          {
            # Madatory
            device_name = device.name
            device_id   = local.map_devices[device.name].id
            # Optional
            ipv4_aggregate_addresses = [for ipv4_aggregate_address in try(vrf.bgp.ipv4_aggregate_addresses, {}) : {
              advertise_map_id = try(local.map_route_maps[ipv4_aggregate_address.advertise_map].id, null)
              attribute_map_id = try(local.map_route_maps[ipv4_aggregate_address.attribute_map].id, null)
              filter           = try(ipv4_aggregate_address.filter, null)
              generate_as      = try(ipv4_aggregate_address.generate_as, null)
              network_id       = try(local.map_network_objects[ipv4_aggregate_address.network].id, local.map_network_group_objects[ipv4_aggregate_address.network].id, null)
              suppress_map_id  = try(local.map_route_maps[ipv4_aggregate_address.suppress_map].id, null)
            }]
            ipv4_auto_aummary                 = try(vrf.bgp.ipv4_auto_aummary, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_auto_aummary, null)
            ipv4_bgp_redistribute_internal    = try(vrf.bgp.ipv4_bgp_redistribute_internal, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_bgp_redistribute_internal, null)
            ipv4_bgp_supress_inactive         = try(vrf.bgp.ipv4_bgp_supress_inactive, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_bgp_supress_inactive, null)
            ipv4_default_information_orginate = try(vrf.bgp.ipv4_default_information_orginate, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_default_information_orginate, null)
            ipv4_external_distance            = try(vrf.bgp.ipv4_external_distance, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_external_distance, null)
            ipv4_filterings = [for ipv4_filter in try(vrf.bgp.ipv4_filterings, {}) : {
              access_list_id    = null
              network_direction = try(ipv4_filter.network_direction, null)
              prorocol_process  = try(ipv4_filter.prorocol_process, null)
              protocol          = try(ipv4_filter.protocol, null)
            }]
            ipv4_forward_packets_over_multipath_ebgp = try(vrf.bgp.ipv4_forward_packets_over_multipath_ebgp, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_forward_packets_over_multipath_ebgp, null)
            ipv4_forward_packets_over_multipath_ibgp = try(vrf.bgp.ipv4_forward_packets_over_multipath_ibgp, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_forward_packets_over_multipath_ibgp, null)
            ipv4_internal_distance                   = try(vrf.bgp.ipv4_internal_distance, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_internal_distance, null)
            ipv4_learned_route_map_id                = try(local.map_route_maps[vrf.bgp.ipv4_learned_route_map].id, null)
            ipv4_local_distance                      = try(vrf.bgp.ipv4_local_distance, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_local_distance, null)
            ipv4_neighbors = [for ipv4_neighbor in try(vrf.bgp.ipv4_neighbors, {}) : {
              enable_address_family                    = try(ipv4_neighbor.enable_address_family, null)
              neighbor_address                         = try(ipv4_neighbor.neighbor_address, null)
              neighbor_authentication_password         = try(ipv4_neighbor.neighbor_authentication_password, null)
              neighbor_bfd                             = try(ipv4_neighbor.neighbor_bfd, null)
              neighbor_customized_accept_both_as       = try(ipv4_neighbor.neighbor_customized_accept_both_as, null)
              neighbor_customized_local_as_number      = try(ipv4_neighbor.neighbor_customized_local_as_number, null)
              neighbor_customized_no_prepend           = try(ipv4_neighbor.neighbor_customized_no_prepend, null)
              neighbor_customized_replace_as           = try(ipv4_neighbor.neighbor_customized_replace_as, null)
              neighbor_description                     = try(ipv4_neighbor.neighbor_description, null)
              neighbor_disable_connection_verification = try(ipv4_neighbor.neighbor_disable_connection_verification, null)
              neighbor_filter_access_lists = [for neighbor_filter_access_list in try(vrf.bgp.neighbor_filter_access_lists, {}) : {
                access_list_id   = null
                update_direction = try(neighbor_filter_access_list.update_direction, null)
              }]
              neighbor_filter_as_path_lists = [for neighbor_filter_as_path_list in try(vrf.bgp.neighbor_filter_as_path_lists, {}) : {
                as_path_id       = null
                update_direction = try(neighbor_filter_as_path_list.update_direction, null)
              }]
              neighbor_filter_max_prefix = try(ipv4_neighbor.neighbor_filter_max_prefix, null)
              neighbor_filter_prefix_lists = [for neighbor_filter_prefix_list in try(vrf.bgp.neighbor_filter_prefix_lists, {}) : {
                prefix_list_id   = null
                update_direction = try(neighbor_filter_prefix_list.update_direction, null)
              }]
              neighbor_filter_restart_interval = try(ipv4_neighbor.neighbor_filter_restart_interval, null)
              neighbor_filter_route_map_lists = [for neighbor_filter_route_map_list in try(vrf.bgp.neighbor_filter_route_map_lists, {}) : {
                route_map_id     = try(local.map_route_maps[neighbor_filter_route_map_list.route_map].id, null)
                update_direction = try(neighbor_filter_route_map_list.update_direction, null)
              }]
              neighbor_filter_threshold_value                 = try(ipv4_neighbor.neighbor_filter_threshold_value, null)
              neighbor_filter_warning_only                    = try(ipv4_neighbor.neighbor_filter_warning_only, null)
              neighbor_generate_default_route_map_id          = try(local.map_route_maps[ipv4_neighbor.neighbor_generate_default_route_map].id, null)
              neighbor_hold_time                              = try(ipv4_neighbor.neighbor_hold_time, null)
              neighbor_keepalive_interval                     = try(ipv4_neighbor.neighbor_keepalive_interval, null)
              neighbor_max_hop_count                          = try(ipv4_neighbor.neighbor_max_hop_count, null)
              neighbor_min_hold_time                          = try(ipv4_neighbor.neighbor_min_hold_time, null)
              neighbor_nexthop_self                           = try(ipv4_neighbor.neighbor_nexthop_self, null)
              neighbor_remote_as                              = try(ipv4_neighbor.neighbor_remote_as, null)
              neighbor_routes_advertise_exist_nonexist_map_id = try(local.map_route_maps[ipv4_neighbor.neighbor_routes_advertise_exist_nonexist_map].id, null)
              neighbor_routes_advertise_map_id                = try(local.map_route_maps[ipv4_neighbor.neighbor_routes_advertise_map].id, null)
              neighbor_routes_advertise_map_use_exist         = try(ipv4_neighbor.neighbor_routes_advertise_map_use_exist, null)
              neighbor_routes_advertisement_interval          = try(ipv4_neighbor.neighbor_routes_advertisement_interval, null)
              neighbor_routes_remove_private_as               = try(ipv4_neighbor.neighbor_routes_remove_private_as, null)
              neighbor_send_community_attribute               = try(ipv4_neighbor.neighbor_send_community_attribute, null)
              neighbor_shutdown                               = try(ipv4_neighbor.neighbor_shutdown, null)
              neighbor_tcp_mtu_path_discovery                 = try(ipv4_neighbor.neighbor_tcp_mtu_path_discovery, null)
              neighbor_tcp_transport_mode                     = try(ipv4_neighbor.neighbor_tcp_transport_mode, null)
              neighbor_version                                = try(ipv4_neighbor.neighbor_version, null)
              neighbor_weight                                 = try(ipv4_neighbor.neighbor_weight, null)
              update_source_interface_id                      = try(local.map_interface_logical_names["${device.name}:${ipv4_neighbor.update_source_interface}"].id, null)
            }]

            ipv4_networks = [for ipv4_network in try(vrf.bgp.ipv4_networks, {}) : {
              network_id   = try(local.map_network_objects[ipv4_network.network].id, local.map_network_group_objects[ipv4_network.network].id, null)
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
            }]
            ipv4_route_injections = [for ipv4_route_injection in try(vrf.bgp.ipv4_route_injections, {}) : {
              exist_route_map_id  = try(local.map_route_maps[ipv4_route_injection.exist_route_map].id, null)
              inject_route_map_id = try(local.map_route_maps[ipv4_route_injection.inject_route_map].id, null)
            }]
            ipv4_synchronization = try(vrf.bgp.ipv4_synchronization, local.defaults.fmc.domains[domain.name].devices.devices.vrfs[vrf.name].bgp.ipv4_synchronization, null)

            domain_name = domain.name

          } if contains(keys(vrf), "bgp") && vrf.name == "Global"
        ]
      ]
    ]) : "${item.device_name}:Global" => item if contains(keys(item), "device_name")
  }
}

resource "fmc_device_bgp" "module" {
  for_each = local.resource_bgp_global
  # Mandatory
  device_id = each.value.device_id

  # Optional
  ipv4_aggregate_addresses                 = each.value.ipv4_aggregate_addresses
  ipv4_auto_aummary                        = each.value.ipv4_auto_aummary
  ipv4_bgp_redistribute_internal           = each.value.ipv4_bgp_redistribute_internal
  ipv4_bgp_supress_inactive                = each.value.ipv4_bgp_supress_inactive
  ipv4_default_information_orginate        = each.value.ipv4_default_information_orginate
  ipv4_external_distance                   = each.value.ipv4_external_distance
  ipv4_filterings                          = each.value.ipv4_filterings
  ipv4_forward_packets_over_multipath_ebgp = each.value.ipv4_forward_packets_over_multipath_ebgp
  ipv4_forward_packets_over_multipath_ibgp = each.value.ipv4_forward_packets_over_multipath_ibgp
  ipv4_internal_distance                   = each.value.ipv4_internal_distance
  ipv4_learned_route_map_id                = each.value.ipv4_learned_route_map_id
  ipv4_local_distance                      = each.value.ipv4_local_distance
  ipv4_neighbors                           = each.value.ipv4_neighbors
  ipv4_networks                            = each.value.ipv4_networks
  ipv4_redistributions                     = each.value.ipv4_redistributions
  ipv4_route_injections                    = each.value.ipv4_route_injections
  ipv4_synchronization                     = each.value.ipv4_synchronization

  domain = each.value.domain_name

  depends_on = [
    data.fmc_device.module,
    fmc_device.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    data.fmc_device_bgp_general_settings.module,
    fmc_device_bgp_general_settings.module,
    data.fmc_hosts.module,
    fmc_hosts.module,
    data.fmc_networks.module,
    fmc_networks.module,
    data.fmc_ranges.module,
    fmc_ranges.module,
    fmc_network_groups.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module
  ]
}



######
### map_bfd_templates
######
locals {
  map_bfd_templates = merge({
    for item in flatten([
      for bfd_template_key, bfd_template_value in local.resource_bfd_template : {
        name        = bfd_template_key
        id          = fmc_bfd_template.module[bfd_template_key].id
        type        = fmc_bfd_template.module[bfd_template_key].type
        domain_name = bfd_template_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for bfd_template_key, bfd_template_value in local.data_bfd_template : {
          name        = bfd_template_key
          id          = data.fmc_device.module[bfd_template_key].id
          type        = data.fmc_device.module[bfd_template_key].type
          domain_name = bfd_template_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}