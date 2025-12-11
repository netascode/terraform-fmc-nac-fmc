##########################################################
###    DEVICE
##########################################################
locals {
  data_device = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, {}) : {
          name   = device.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_device = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : {
          domain           = domain.name
          name             = device.name
          host             = device.host
          licenses         = device.licenses
          registration_key = device.registration_key

          access_control_policy_id = try(device.access_control_policy, "") != "" ? try(
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_access_control_policies["${domain_path}:${device.access_control_policy}"].id
              if contains(keys(local.map_access_control_policies), "${domain_path}:${device.access_control_policy}")
          })[0]) : null
          # device_group_id  = try(local.map_device_groups[device.device_group].id, null)
          health_policy_id = try(device.health_policy, "") != "" ? try(
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_health_policies["${domain_path}:${device.health_policy}"].id
              if contains(keys(local.map_health_policies), "${domain_path}:${device.health_policy}")
          })[0]) : null
          nat_policy_id = try(device.nat_policy, "") != "" ? try(
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ftd_nat_policies["${domain_path}:${device.nat_policy}"].id
              if contains(keys(local.map_ftd_nat_policies), "${domain_path}:${device.nat_policy}")
          })[0]) : null

          nat_id                   = try(device.nat_id, null)
          object_group_search      = try(device.object_group_search, local.defaults.fmc.domains.devices.devices.object_group_search, null)
          performance_tier         = try(device.performance_tier, local.defaults.fmc.domains.devices.devices.performance_tier, null)
          prohibit_packet_transfer = try(device.prohibit_packet_transfer, local.defaults.fmc.domains.devices.devices.prohibit_packet_transfer, null)
          snort_engine             = try(device.snort_engine, local.defaults.fmc.domains.devices.devices.snort_engine, null)
        } if(!contains(try(keys(local.data_device), []), "${domain.name}:${device.name}") && !contains(try(keys(local.resource_chassis_logical_device), []), "${domain.name}:${device.name}"))
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_device" "device" {
  for_each = local.data_device

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_device" "device" {
  for_each = local.resource_device

  domain                   = each.value.domain
  name                     = each.value.name
  host                     = each.value.host
  registration_key         = each.value.registration_key
  access_control_policy_id = each.value.access_control_policy_id
  licenses                 = each.value.licenses
  # device_group_id  = each.value.device_group_id
  health_policy_id         = each.value.health_policy_id
  nat_policy_id            = each.value.nat_policy_id
  nat_id                   = each.value.nat_id
  object_group_search      = each.value.object_group_search
  performance_tier         = each.value.performance_tier
  prohibit_packet_transfer = each.value.prohibit_packet_transfer
  snort_engine             = each.value.snort_engine
}

##########################################################
###    DEVICE HA PAIR
##########################################################
locals {
  data_device_ha_pair = {
    for item in flatten([
      for domain in local.data_existing : [
        for ha_pair in try(domain.devices.ha_pairs, {}) : {
          name   = ha_pair.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_device_ha_pair = {
    for item in flatten([
      for domain in local.domains : [
        for ha_pair in try(domain.devices.ha_pairs, []) : {
          domain = domain.name
          name   = ha_pair.name

          primary_device_id      = local.map_devices["${domain.name}:${ha_pair.primary_device}"].id
          secondary_device_id    = local.map_devices["${domain.name}:${ha_pair.secondary_device}"].id
          ha_link_interface_id   = local.map_interfaces_by_names["${domain.name}:${ha_pair.primary_device}:${ha_pair.ha_link_interface_name}"].id
          ha_link_interface_name = ha_pair.ha_link_interface_name
          ha_link_interface_type = local.map_interfaces_by_names["${domain.name}:${ha_pair.primary_device}:${ha_pair.ha_link_interface_name}"].type
          ha_link_logical_name   = ha_pair.ha_link_logical_name
          ha_link_primary_ip     = ha_pair.ha_link_primary_ip
          ha_link_secondary_ip   = ha_pair.ha_link_secondary_ip
          ha_link_netmask        = ha_pair.ha_link_netmask
          ha_link_use_ipv6       = try(ha_pair.ha_link_use_ipv6, local.defaults.fmc.domains.devices.ha_pairs.ha_link_use_ipv6, null)

          state_link_use_same_as_ha = ha_pair.state_link_use_same_as_ha
          state_link_interface_id   = try(local.map_interfaces_by_names["${domain.name}:${ha_pair.primary_device}:${ha_pair.state_link_interface_name}"].id, null)
          state_link_interface_name = try(ha_pair.state_link_interface_name, null)
          state_link_interface_type = try(local.map_interfaces_by_names["${domain.name}:${ha_pair.primary_device}:${ha_pair.state_link_interface_name}"].type, null)
          state_link_logical_name   = try(ha_pair.state_link_logical_name, null)
          state_link_primary_ip     = try(ha_pair.state_link_primary_ip, null)
          state_link_secondary_ip   = try(ha_pair.state_link_secondary_ip, null)
          state_link_netmask        = try(ha_pair.state_link_netmask, null)
          state_link_use_ipv6       = ha_pair.state_link_use_same_as_ha == false ? try(ha_pair.state_link_use_ipv6, local.defaults.fmc.domains.devices.ha_pairs.state_link_use_ipv6, null) : null

          action                           = try(ha_pair.action, null)
          encryption_enabled               = try(ha_pair.encryption_enabled, local.defaults.fmc.domains.devices.ha_pairs.encryption_enabled, null)
          encryption_key                   = try(ha_pair.encryption_key, null)
          encryption_key_generation_scheme = try(ha_pair.encryption_key_generation_scheme, null)
          failed_interfaces_limit          = try(ha_pair.failed_interfaces_percent, null) == null ? try(ha_pair.failed_interfaces_limit, local.defaults.fmc.domains.devices.ha_pairs.failed_interfaces_limit, null) : null
          failed_interfaces_percent        = try(ha_pair.failed_interfaces_percent, null)
          interface_hold_time              = try(ha_pair.interface_hold_time, null)
          interface_poll_time              = try(ha_pair.interface_poll_time, null)
          interface_poll_time_unit         = try(ha_pair.interface_poll_time_unit, null)
          peer_hold_time                   = try(ha_pair.peer_hold_time, null)
          peer_hold_time_unit              = try(ha_pair.peer_hold_time_unit, null)
          peer_poll_time                   = try(ha_pair.peer_poll_time, null)
          peer_poll_time_unit              = try(ha_pair.peer_poll_time_unit, null)
        } if !contains(try(keys(local.data_device_ha_pair), []), "${domain.name}:${ha_pair.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_device_ha_pair" "device_ha_pair" {
  for_each = local.data_device_ha_pair

  domain = each.value.domain
  name   = each.value.name
}

resource "fmc_device_ha_pair" "device_ha_pair" {
  for_each = local.resource_device_ha_pair

  domain = each.value.domain
  name   = each.value.name

  primary_device_id         = each.value.primary_device_id
  secondary_device_id       = each.value.secondary_device_id
  ha_link_interface_id      = each.value.ha_link_interface_id
  ha_link_interface_name    = each.value.ha_link_interface_name
  ha_link_interface_type    = each.value.ha_link_interface_type
  ha_link_logical_name      = each.value.ha_link_logical_name
  ha_link_primary_ip        = each.value.ha_link_primary_ip
  ha_link_secondary_ip      = each.value.ha_link_secondary_ip
  ha_link_netmask           = each.value.ha_link_netmask
  state_link_use_same_as_ha = each.value.state_link_use_same_as_ha

  action                           = each.value.action
  encryption_enabled               = each.value.encryption_enabled
  encryption_key                   = each.value.encryption_key
  encryption_key_generation_scheme = each.value.encryption_key_generation_scheme
  failed_interfaces_limit          = each.value.failed_interfaces_limit
  failed_interfaces_percent        = each.value.failed_interfaces_percent
  ha_link_use_ipv6                 = each.value.ha_link_use_ipv6
  interface_hold_time              = each.value.interface_hold_time
  interface_poll_time              = each.value.interface_poll_time
  interface_poll_time_unit         = each.value.interface_poll_time_unit
  peer_hold_time                   = each.value.peer_hold_time
  peer_hold_time_unit              = each.value.peer_hold_time_unit
  peer_poll_time                   = each.value.peer_poll_time
  peer_poll_time_unit              = each.value.peer_poll_time_unit
  state_link_interface_id          = each.value.state_link_interface_id
  state_link_interface_name        = each.value.state_link_interface_name
  state_link_interface_type        = each.value.state_link_interface_type
  state_link_logical_name          = each.value.state_link_logical_name
  state_link_primary_ip            = each.value.state_link_primary_ip
  state_link_secondary_ip          = each.value.state_link_secondary_ip
  state_link_netmask               = each.value.state_link_netmask
  state_link_use_ipv6              = each.value.state_link_use_ipv6
}

##########################################################
###    DEVICE HA PAIR MONITORING
##########################################################
locals {
  resource_device_ha_pair_monitoring = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : concat(
            [
              for physical_interface in try(vrf.physical_interfaces, []) : {
                domain               = domain.name
                device_name          = device.name
                ha_pair_id           = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                logical_name         = local.map_interfaces_by_names["${domain.name}:${device.name}:${physical_interface.name}"].logical_name # To build TF dependency on the interface
                monitor_interface    = physical_interface.monitor_interface
                ipv4_standby_address = try(physical_interface.ipv4_standby_address, null)
                ipv6_addresses = [for ipv6_address in try(physical_interface.ipv6_addresses, {}) : {
                  active_address  = ipv6_address.active_address
                  standby_address = ipv6_address.standby_address
                }]
              } if(try(physical_interface.monitor_interface, null) != null && (try(physical_interface.ipv4_standby_address, null) != null || length(try(physical_interface.ipv6_addresses, {})) > 0))
            ],
            [
              for subinterface in try(vrf.sub_interfaces, []) : {
                domain               = domain.name
                device_name          = device.name
                ha_pair_id           = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                logical_name         = local.map_interfaces_by_names["${domain.name}:${device.name}:${subinterface.name}"].logical_name # To build TF dependency on the interface
                monitor_interface    = subinterface.monitor_interface
                ipv4_standby_address = try(subinterface.ipv4_standby_address, null)
                ipv6_addresses = [for ipv6_address in try(subinterface.ipv6_addresses, {}) : {
                  active_address  = ipv6_address.active_address
                  standby_address = ipv6_address.standby_address
                }]
              } if(try(subinterface.monitor_interface, null) != null && (try(subinterface.ipv4_standby_address, null) != null || length(try(subinterface.ipv6_addresses, {})) > 0))
            ],
            [
              for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : {
                domain               = domain.name
                device_name          = device.name
                ha_pair_id           = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                logical_name         = local.map_interfaces_by_names["${domain.name}:${device.name}:${etherchannel_interface.name}"].logical_name # To build TF dependency on the interface
                monitor_interface    = etherchannel_interface.monitor_interface
                ipv4_standby_address = try(etherchannel_interface.ipv4_standby_address, null)
                ipv6_addresses = [for ipv6_address in try(etherchannel_interface.ipv6_addresses, {}) : {
                  active_address  = ipv6_address.active_address
                  standby_address = ipv6_address.standby_address
                }]
              } if(try(etherchannel_interface.monitor_interface, null) != null && (try(etherchannel_interface.ipv4_standby_address, null) != null || length(try(etherchannel_interface.ipv6_addresses, {})) > 0))
            ]
          )
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item
  }
}

resource "fmc_device_ha_pair_monitoring" "device_ha_pair_monitoring" {
  for_each = local.resource_device_ha_pair_monitoring

  domain               = each.value.domain
  logical_name         = each.value.logical_name
  ha_pair_id           = each.value.ha_pair_id
  monitor_interface    = each.value.monitor_interface
  ipv4_standby_address = each.value.ipv4_standby_address
  # Caveats - IPv6 standby address cannot be removed via API/Terraform/Module
  #ipv6_addresses        = each.value.ipv6_addresses
}

##########################################################
###    DEVICE HA PAIR FAILOVER INTERFACE MAC ADDRESS
##########################################################
locals {
  resource_device_ha_pair_failover_interface_mac_address = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : concat(
            [
              for physical_interface in try(vrf.physical_interfaces, []) : {
                domain              = domain.name
                device_name         = device.name
                ha_pair_id          = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                name                = physical_interface.name
                interface_name      = physical_interface.name
                interface_id        = local.map_interfaces_by_names["${domain.name}:${device.name}:${physical_interface.name}"].id
                interface_type      = local.map_interfaces_by_names["${domain.name}:${device.name}:${physical_interface.name}"].type
                active_mac_address  = physical_interface.ha_active_mac_address
                standby_mac_address = physical_interface.ha_standby_mac_address
              } if(try(physical_interface.ha_active_mac_address, null) != null && try(physical_interface.ha_standby_mac_address, null) != null)
            ],
            [
              for subinterface in try(vrf.sub_interfaces, []) : {
                domain              = domain.name
                device_name         = device.name
                ha_pair_id          = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                name                = subinterface.name
                interface_name      = split(".", subinterface.name)[length(split(".", subinterface.name)) - 2]
                interface_id        = local.map_interfaces_by_names["${domain.name}:${device.name}:${subinterface.name}"].id
                interface_type      = local.map_interfaces_by_names["${domain.name}:${device.name}:${subinterface.name}"].type
                active_mac_address  = subinterface.ha_active_mac_address
                standby_mac_address = subinterface.ha_standby_mac_address
              } if(try(subinterface.ha_active_mac_address, null) != null && try(subinterface.ha_standby_mac_address, null) != null)
            ],
            [
              for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : {
                domain              = domain.name
                device_name         = device.name
                ha_pair_id          = local.map_device_to_container[local.map_devices["${domain.name}:${device.name}"].id].id
                name                = etherchannel_interface.name
                interface_name      = etherchannel_interface.name
                interface_id        = local.map_interfaces_by_names["${domain.name}:${device.name}:${etherchannel_interface.name}"].id
                interface_type      = local.map_interfaces_by_names["${domain.name}:${device.name}:${etherchannel_interface.name}"].type
                active_mac_address  = etherchannel_interface.ha_active_mac_address
                standby_mac_address = etherchannel_interface.ha_standby_mac_address
              } if(try(etherchannel_interface.ha_active_mac_address, null) != null && try(etherchannel_interface.ha_standby_mac_address, null) != null)
            ]
          )
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }
}

resource "fmc_device_ha_pair_failover_interface_mac_address" "device_ha_pair_failover_interface_mac_address" {
  for_each = local.resource_device_ha_pair_failover_interface_mac_address

  domain              = each.value.domain
  ha_pair_id          = each.value.ha_pair_id
  interface_name      = each.value.interface_name
  interface_id        = each.value.interface_id
  interface_type      = each.value.interface_type
  active_mac_address  = each.value.active_mac_address
  standby_mac_address = each.value.standby_mac_address
}

##########################################################
###    DEVICE CLUSTER
##########################################################
locals {
  data_device_cluster = {
    for item in flatten([
      for domain in local.data_existing : [
        for cluster in try(domain.devices.clusters, {}) : {
          name   = cluster.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_device_cluster = {
    for item in flatten([
      for domain in local.domains : [
        for cluster in try(domain.devices.clusters, []) : {
          domain = domain.name
          name   = cluster.name

          cluster_key                   = cluster.cluster_key
          control_node_device_id        = local.map_devices["${domain.name}:${cluster.control_node_device}"].id
          control_node_priority         = cluster.control_node_priority
          control_node_interface_id     = local.map_interfaces_by_names["${domain.name}:${cluster.control_node_device}:${cluster.control_node_interface_name}"].id
          control_node_interface_name   = cluster.control_node_interface_name
          control_node_interface_type   = local.map_interfaces_by_names["${domain.name}:${cluster.control_node_device}:${cluster.control_node_interface_name}"].type
          control_node_ccl_ipv4_address = cluster.control_node_ccl_ipv4_address
          control_node_ccl_prefix       = cluster.control_node_ccl_prefix
          control_node_vni_prefix       = try(cluster.control_node_vni_prefix, null)
          data_nodes = [for data_node in try(cluster.data_nodes, []) : {
            ccl_ipv4_address = data_node.ccl_ipv4_address
            device_id        = local.map_devices["${domain.name}:${data_node.device}"].id
            priority         = data_node.priority
          }]
        } if !contains(try(keys(local.data_device_cluster), []), "${domain.name}:${cluster.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_device_cluster" "device_cluster" {
  for_each = local.data_device_cluster

  domain = each.value.domain
  name   = each.value.name
}

resource "fmc_device_cluster" "device_cluster" {
  for_each = local.resource_device_cluster

  domain                        = each.value.domain
  name                          = each.value.name
  cluster_key                   = each.value.cluster_key
  control_node_device_id        = each.value.control_node_device_id
  control_node_priority         = each.value.control_node_priority
  control_node_interface_id     = each.value.control_node_interface_id
  control_node_interface_name   = each.value.control_node_interface_name
  control_node_interface_type   = each.value.control_node_interface_type
  control_node_ccl_ipv4_address = each.value.control_node_ccl_ipv4_address
  control_node_ccl_prefix       = each.value.control_node_ccl_prefix
  control_node_vni_prefix       = each.value.control_node_vni_prefix
  data_nodes                    = each.value.data_nodes
}

##########################################################
###    DEVICE PHYSICAL INTERFACE
##########################################################
locals {
  data_device_physical_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for physical_interface in try(vrf.physical_interfaces, []) : {
              domain      = domain.name
              name        = physical_interface.name
              device_name = device.name
              device_id   = data.fmc_device.device["${domain.name}:${device.name}"].id
            }
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }

  resource_device_physical_interface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for physical_interface in try(vrf.physical_interfaces, []) : {
              domain      = domain.name
              vrf_name    = vrf.name
              device_name = device.name
              name        = physical_interface.name
              device_id   = local.map_devices["${domain.name}:${device.name}"].id
              mode        = try(physical_interface.mode, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.mode)

              active_mac_address             = try(physical_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.active_mac_address, null)
              allow_full_fragment_reassembly = try(physical_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.allow_full_fragment_reassembly, null)
              arp_table_entries = [for arp_table_entry in try(physical_interface.arp_table_entries, []) : {
                enabled     = try(arp_table_entry.enabled, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.arp_table_entries.enabled, null)
                ip_address  = arp_table_entry.ip_address
                mac_address = arp_table_entry.mac_address
              }]
              auto_negotiation             = try(physical_interface.auto_negotiation, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.auto_negotiation, null)
              description                  = try(physical_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.description, null)
              duplex                       = try(physical_interface.duplex, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.duplex, null)
              anti_spoofing                = try(physical_interface.anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.anti_spoofing, null)
              sgt_propagate                = try(physical_interface.sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.sgt_propagate, null)
              enabled                      = try(physical_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.enabled, null)
              fec_mode                     = try(physical_interface.fec_mode, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.fec_mode, null)
              flow_control_send            = try(physical_interface.flow_control_send, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.flow_control_send, false) ? "ON" : null
              ip_based_monitoring          = try(physical_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring, null)
              ip_based_monitoring_next_hop = try(physical_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring_next_hop, null)
              ip_based_monitoring_type     = try(physical_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring_type, null)
              ipv4_address_pool_id = try(physical_interface.ipv4_address_pool, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_ipv4_address_pools["${domain_path}:${physical_interface.ipv4_address_pool}"].id
                  if contains(keys(local.map_ipv4_address_pools), "${domain_path}:${physical_interface.ipv4_address_pool}")
              })[0]) : null
              ipv4_dhcp_obtain_default_route        = try(physical_interface.ipv4_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_dhcp_obtain_default_route, null)
              ipv4_dhcp_default_route_metric        = try(physical_interface.ipv4_dhcp_default_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_dhcp_default_route_metric, null)
              ipv4_pppoe_authentication             = try(physical_interface.ipv4_pppoe_authentication, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_authentication, null)
              ipv4_pppoe_password                   = try(physical_interface.ipv4_pppoe_password, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_password, null)
              ipv4_pppoe_route_metric               = try(physical_interface.ipv4_pppoe_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_route_metric, null)
              ipv4_pppoe_route_settings             = try(physical_interface.ipv4_pppoe_route_settings, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_route_settings, null)
              ipv4_pppoe_store_credentials_in_flash = try(physical_interface.ipv4_pppoe_store_credentials_in_flash, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_store_credentials_in_flash, null)
              ipv4_pppoe_user                       = try(physical_interface.ipv4_pppoe_user, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_user, null)
              ipv4_pppoe_vpdn_group_name            = try(physical_interface.ipv4_pppoe_vpdn_group_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_vpdn_group_name, null)
              ipv4_static_address                   = try(physical_interface.ipv4_static_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_static_address, null)
              ipv4_static_netmask                   = try(physical_interface.ipv4_static_netmask, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_static_netmask, null)
              ipv6_address_pool_id = try(physical_interface.ipv6_address_pool, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_ipv6_address_pools["${domain_path}:${physical_interface.ipv6_address_pool}"].id
                  if contains(keys(local.map_ipv6_address_pools), "${domain_path}:${physical_interface.ipv6_address_pool}")
              })[0]) : null
              ipv6_addresses = [for ipv6_address in try(physical_interface.ipv6_addresses, []) : {
                address     = ipv6_address.address
                enforce_eui = try(ipv6_address.enforce_eui, null)
                prefix      = ipv6_address.prefix
              }]
              ipv6_dad_attempts                 = try(physical_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dad_attempts, null)
              ipv6_dhcp_obtain_default_route    = try(physical_interface.ipv6_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_obtain_default_route, null)
              ipv6_dhcp                         = try(physical_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp, null)
              ipv6_dhcp_client_pd_hint_prefixes = try(physical_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
              ipv6_dhcp_client_pd_prefix_name   = try(physical_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
              # ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[physical_interface.ipv6_dhcp_pool].id, null)
              ipv6                        = try(physical_interface.ipv6, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6, null)
              ipv6_auto_config            = try(physical_interface.ipv6_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_auto_config, null)
              ipv6_dad                    = try(physical_interface.ipv6_dad, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dad, null)
              ipv6_dhcp_address_config    = try(physical_interface.ipv6_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_address_config, null)
              ipv6_dhcp_nonaddress_config = try(physical_interface.ipv6_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_nonaddress_config, null)
              ipv6_ra                     = try(physical_interface.ipv6_ra, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ra, null)
              ipv6_enforce_eui            = try(physical_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enforce_eui, null)
              ipv6_link_local_address     = try(physical_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_link_local_address, null)
              ipv6_ns_interval            = try(physical_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ns_interval, null)
              ipv6_prefixes = [for ipv6_prefix in try(physical_interface.ipv6_prefixes, []) : {
                address = try(ipv6_prefix.address, null)
                default = try(ipv6_prefix.default, null)
              }]
              ipv6_ra_interval    = try(physical_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ra_interval, null)
              ipv6_ra_life_time   = try(physical_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ra_life_time, null)
              ipv6_reachable_time = try(physical_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_reachable_time, null)
              lldp_receive        = try(physical_interface.lldp_receive, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.lldp_receive, null)
              lldp_transmit       = try(physical_interface.lldp_transmit, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.lldp_transmit, null)
              logical_name        = try(physical_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.logical_name, null)
              management_access   = try(physical_interface.management_access, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.management_access, null)
              management_access_network_objects = [for management_access_network_object in try(physical_interface.management_access_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${management_access_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${management_access_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${management_access_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${management_access_network_object}")
                  })[0],
                )
              }]
              management_only                           = try(physical_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.management_only, null)
              mtu                                       = try(physical_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.mtu, null)
              nve_only                                  = try(physical_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.nve_only, null)
              override_default_fragment_setting_chain   = try(physical_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_chain, null)
              override_default_fragment_setting_size    = try(physical_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_size, null)
              override_default_fragment_setting_timeout = try(physical_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_timeout, null)
              priority                                  = try(physical_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.priority, null)
              security_zone_id = try(physical_interface.security_zone, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_security_zones["${domain_path}:${physical_interface.security_zone}"].id
                  if contains(keys(local.map_security_zones), "${domain_path}:${physical_interface.security_zone}")
              })[0]) : null
              speed               = try(physical_interface.speed, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.speed, null)
              standby_mac_address = try(physical_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.standby_mac_address, null)
            } if !contains(try(keys(local.data_device_physical_interface), []), "${domain.name}:${device.name}:${physical_interface.name}")
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }
}

data "fmc_device_physical_interface" "device_physical_interface" {
  for_each = local.data_device_physical_interface

  domain    = each.value.domain
  name      = each.value.name
  device_id = each.value.device_id
}

resource "fmc_device_physical_interface" "device_physical_interface" {
  for_each = local.resource_device_physical_interface

  domain                                = each.value.domain
  name                                  = each.value.name
  device_id                             = each.value.device_id
  mode                                  = each.value.mode
  active_mac_address                    = each.value.active_mac_address
  allow_full_fragment_reassembly        = each.value.allow_full_fragment_reassembly
  arp_table_entries                     = each.value.arp_table_entries
  auto_negotiation                      = each.value.auto_negotiation
  description                           = each.value.description
  duplex                                = each.value.duplex
  anti_spoofing                         = each.value.anti_spoofing
  sgt_propagate                         = each.value.sgt_propagate
  enabled                               = each.value.enabled
  fec_mode                              = each.value.fec_mode
  flow_control_send                     = each.value.flow_control_send
  ip_based_monitoring                   = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop          = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type              = each.value.ip_based_monitoring_type
  ipv4_address_pool_id                  = each.value.ipv4_address_pool_id
  ipv4_dhcp_obtain_default_route        = each.value.ipv4_dhcp_obtain_default_route
  ipv4_dhcp_default_route_metric        = each.value.ipv4_dhcp_default_route_metric
  ipv4_pppoe_authentication             = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                   = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric               = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings             = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                       = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name            = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                   = each.value.ipv4_static_address
  ipv4_static_netmask                   = each.value.ipv4_static_netmask
  ipv6_addresses                        = each.value.ipv6_addresses
  ipv6_dad_attempts                     = each.value.ipv6_dad_attempts
  ipv6_dhcp_obtain_default_route        = each.value.ipv6_dhcp_obtain_default_route
  ipv6_dhcp                             = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes     = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name       = each.value.ipv6_dhcp_client_pd_prefix_name
  # ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6                                      = each.value.ipv6
  ipv6_auto_config                          = each.value.ipv6_auto_config
  ipv6_dad                                  = each.value.ipv6_dad
  ipv6_dhcp_address_config                  = each.value.ipv6_dhcp_address_config
  ipv6_dhcp_nonaddress_config               = each.value.ipv6_dhcp_nonaddress_config
  ipv6_ra                                   = each.value.ipv6_ra
  ipv6_enforce_eui                          = each.value.ipv6_enforce_eui
  ipv6_link_local_address                   = each.value.ipv6_link_local_address
  ipv6_ns_interval                          = each.value.ipv6_ns_interval
  ipv6_prefixes                             = each.value.ipv6_prefixes
  ipv6_ra_interval                          = each.value.ipv6_ra_interval
  ipv6_ra_life_time                         = each.value.ipv6_ra_life_time
  ipv6_reachable_time                       = each.value.ipv6_reachable_time
  lldp_receive                              = each.value.lldp_receive
  lldp_transmit                             = each.value.lldp_transmit
  logical_name                              = each.value.logical_name
  management_access                         = each.value.management_access
  management_access_network_objects         = each.value.management_access_network_objects
  management_only                           = each.value.management_only
  mtu                                       = each.value.mtu
  nve_only                                  = each.value.nve_only
  override_default_fragment_setting_chain   = each.value.override_default_fragment_setting_chain
  override_default_fragment_setting_size    = each.value.override_default_fragment_setting_size
  override_default_fragment_setting_timeout = each.value.override_default_fragment_setting_timeout
  priority                                  = each.value.priority
  security_zone_id                          = each.value.security_zone_id
  speed                                     = each.value.speed
  standby_mac_address                       = each.value.standby_mac_address
}

##########################################################
###    DEVICE ETHERCHANNEL INTERFACE
##########################################################
locals {
  data_device_etherchannel_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : {
              domain      = domain.name
              name        = etherchannel_interface.name
              device_name = device.name
              device_id   = data.fmc_device.device["${domain.name}:${device.name}"].id
            }
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }

  resource_device_etherchannel_interface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : {
              domain      = domain.name
              vrf_name    = vrf.name
              device_name = device.name

              name                           = etherchannel_interface.name
              ether_channel_id               = split("Port-channel", etherchannel_interface.name)[length(split("Port-channel", etherchannel_interface.name)) - 1]
              device_id                      = local.map_devices["${domain.name}:${device.name}"].id
              mode                           = try(etherchannel_interface.mode, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.mode)
              active_mac_address             = try(etherchannel_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.active_mac_address, null)
              allow_full_fragment_reassembly = try(etherchannel_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.allow_full_fragment_reassembly, null)
              arp_table_entries = [for arp_table_entry in try(etherchannel_interface.arp_table_entries, []) : {
                enabled     = try(arp_table_entry.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.arp_table_entries.enabled, null)
                ip_address  = arp_table_entry.ip_address
                mac_address = arp_table_entry.mac_address
              }]
              auto_negotiation                      = try(etherchannel_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enabled, null)
              description                           = try(etherchannel_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.description, null)
              duplex                                = try(etherchannel_interface.duplex, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.duplex, null)
              anti_spoofing                         = try(etherchannel_interface.anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.anti_spoofing, null)
              sgt_propagate                         = try(etherchannel_interface.sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.sgt_propagate, null)
              enabled                               = try(etherchannel_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enabled, null)
              fec_mode                              = try(etherchannel_interface.fec_mode, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.fec_mode, null)
              flow_control_send                     = try(etherchannel_interface.flow_control_send, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.flow_control_send, null)
              ip_based_monitoring                   = try(etherchannel_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring, null)
              ip_based_monitoring_next_hop          = try(etherchannel_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_next_hop, null)
              ip_based_monitoring_type              = try(etherchannel_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_type, null)
              ipv4_dhcp_obtain_default_route        = try(etherchannel_interface.ipv4_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_obtain_default_route, null)
              ipv4_dhcp_default_route_metric        = try(etherchannel_interface.ipv4_dhcp_default_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_default_route_metric, null)
              ipv4_pppoe_authentication             = try(etherchannel_interface.ipv4_pppoe_authentication, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_authentication, null)
              ipv4_pppoe_password                   = try(etherchannel_interface.ipv4_pppoe_password, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_password, null)
              ipv4_pppoe_route_metric               = try(etherchannel_interface.ipv4_pppoe_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_route_metric, null)
              ipv4_pppoe_route_settings             = try(etherchannel_interface.ipv4_pppoe_route_settings, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_route_settings, null)
              ipv4_pppoe_store_credentials_in_flash = try(etherchannel_interface.ipv4_pppoe_store_credentials_in_flash, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_store_credentials_in_flash, null)
              ipv4_pppoe_user                       = try(etherchannel_interface.ipv4_pppoe_user, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_user, null)
              ipv4_pppoe_vpdn_group_name            = try(etherchannel_interface.ipv4_pppoe_vpdn_group_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_vpdn_group_name, null)
              ipv4_static_address                   = try(etherchannel_interface.ipv4_static_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_static_address, null)
              ipv4_static_netmask                   = try(etherchannel_interface.ipv4_static_netmask, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_static_netmask, null)
              ipv6_addresses = [for ipv6_address in try(etherchannel_interface.ipv6_addresses, []) : {
                address     = ipv6_address.address
                enforce_eui = try(ipv6_address.enforce_eui, null)
                prefix      = ipv6_address.prefix
              }]
              ipv6_dad_attempts                 = try(etherchannel_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dad_attempts, null)
              ipv6_dhcp_obtain_default_route    = try(etherchannel_interface.ipv6_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_obtain_default_route, null)
              ipv6_dhcp                         = try(etherchannel_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp, null)
              ipv6_dhcp_client_pd_hint_prefixes = try(etherchannel_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
              ipv6_dhcp_client_pd_prefix_name   = try(etherchannel_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
              # ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[etherchannel_interface.ipv6_dhcp_pool].id, null)
              ipv6                        = try(etherchannel_interface.ipv6, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6, null)
              ipv6_auto_config            = try(etherchannel_interface.ipv6_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_auto_config, null)
              ipv6_dad                    = try(etherchannel_interface.ipv6_dad, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dad, null)
              ipv6_dhcp_address_config    = try(etherchannel_interface.ipv6_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_address_config, null)
              ipv6_dhcp_nonaddress_config = try(etherchannel_interface.ipv6_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_nonaddress_config, null)
              ipv6_ra                     = try(etherchannel_interface.ipv6_ra, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra, null)
              ipv6_enforce_eui            = try(etherchannel_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enforce_eui, null)
              ipv6_link_local_address     = try(etherchannel_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_link_local_address, null)
              ipv6_ns_interval            = try(etherchannel_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ns_interval, null)
              ipv6_prefixes = [for ipv6_prefix in try(etherchannel_interface.ipv6_prefixes, []) : {
                address = try(ipv6_prefix.address, null)
                default = try(ipv6_prefix.default, null)
              }]
              ipv6_ra_interval    = try(etherchannel_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_interval, null)
              ipv6_ra_life_time   = try(etherchannel_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_life_time, null)
              ipv6_reachable_time = try(etherchannel_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_reachable_time, null)
              lldp_receive        = try(etherchannel_interface.lldp_receive, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.lldp_receive, null)
              lldp_transmit       = try(etherchannel_interface.lldp_transmit, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.lldp_transmit, null)
              logical_name        = try(etherchannel_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.logical_name, null)
              management_access   = try(etherchannel_interface.management_access, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.management_access, null)
              management_access_network_objects = [for management_access_network_object in try(etherchannel_interface.management_access_network_objects, []) : {
                id = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${management_access_network_object}"].id
                    if contains(keys(local.map_network_objects), "${domain_path}:${management_access_network_object}")
                  })[0],
                )
                type = try(
                  values({
                    for domain_path in local.related_domains[domain.name] :
                    domain_path => local.map_network_objects["${domain_path}:${management_access_network_object}"].type
                    if contains(keys(local.map_network_objects), "${domain_path}:${management_access_network_object}")
                  })[0],
                )
              }]
              management_only                           = try(etherchannel_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.management_only, null)
              mtu                                       = try(etherchannel_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.mtu, null)
              nve_only                                  = try(etherchannel_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.nve_only, null)
              override_default_fragment_setting_chain   = try(etherchannel_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_chain, null)
              override_default_fragment_setting_size    = try(etherchannel_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_size, null)
              override_default_fragment_setting_timeout = try(etherchannel_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_timeout, null)
              priority                                  = try(etherchannel_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.priority, null)
              security_zone_id = try(etherchannel_interface.security_zone, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_security_zones["${domain_path}:${etherchannel_interface.security_zone}"].id
                  if contains(keys(local.map_security_zones), "${domain_path}:${etherchannel_interface.security_zone}")
              })[0]) : null
              selected_interfaces = [for selected_interface in try(etherchannel_interface.selected_interfaces, []) : {
                name = selected_interface
                id   = try(fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${selected_interface}"].id, data.fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${selected_interface}"].id)
                type = try(fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${selected_interface}"].type, data.fmc_device_physical_interface.device_physical_interface["${domain.name}:${device.name}:${selected_interface}"].type)
              }]
              speed               = try(etherchannel_interface.speed, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.speed, null)
              standby_mac_address = try(etherchannel_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.standby_mac_address, null)
            } if !contains(try(keys(local.data_device_etherchannel_interface), []), "${domain.name}:${device.name}:${etherchannel_interface.name}")
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }
}

data "fmc_device_etherchannel_interface" "device_etherchannel_interface" {
  for_each = local.data_device_etherchannel_interface

  domain    = each.value.domain
  name      = each.value.name
  device_id = each.value.device_id
}

resource "fmc_device_etherchannel_interface" "device_etherchannel_interface" {
  for_each = local.resource_device_etherchannel_interface

  domain                                = each.value.domain
  device_id                             = each.value.device_id
  ether_channel_id                      = each.value.ether_channel_id
  mode                                  = each.value.mode
  active_mac_address                    = each.value.active_mac_address
  allow_full_fragment_reassembly        = each.value.allow_full_fragment_reassembly
  arp_table_entries                     = each.value.arp_table_entries
  auto_negotiation                      = each.value.auto_negotiation
  description                           = each.value.description
  duplex                                = each.value.duplex
  anti_spoofing                         = each.value.anti_spoofing
  sgt_propagate                         = each.value.sgt_propagate
  enabled                               = each.value.enabled
  fec_mode                              = each.value.fec_mode
  flow_control_send                     = each.value.flow_control_send
  ip_based_monitoring                   = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop          = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type              = each.value.ip_based_monitoring_type
  ipv4_dhcp_obtain_default_route        = each.value.ipv4_dhcp_obtain_default_route
  ipv4_dhcp_default_route_metric        = each.value.ipv4_dhcp_default_route_metric
  ipv4_pppoe_authentication             = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                   = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric               = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings             = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                       = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name            = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                   = each.value.ipv4_static_address
  ipv4_static_netmask                   = each.value.ipv4_static_netmask
  ipv6_addresses                        = each.value.ipv6_addresses
  ipv6_dad_attempts                     = each.value.ipv6_dad_attempts
  ipv6_dhcp_obtain_default_route        = each.value.ipv6_dhcp_obtain_default_route
  ipv6_dhcp                             = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes     = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name       = each.value.ipv6_dhcp_client_pd_prefix_name
  # ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6                                      = each.value.ipv6
  ipv6_auto_config                          = each.value.ipv6_auto_config
  ipv6_dad                                  = each.value.ipv6_dad
  ipv6_dhcp_address_config                  = each.value.ipv6_dhcp_address_config
  ipv6_dhcp_nonaddress_config               = each.value.ipv6_dhcp_nonaddress_config
  ipv6_ra                                   = each.value.ipv6_ra
  ipv6_enforce_eui                          = each.value.ipv6_enforce_eui
  ipv6_link_local_address                   = each.value.ipv6_link_local_address
  ipv6_ns_interval                          = each.value.ipv6_ns_interval
  ipv6_prefixes                             = each.value.ipv6_prefixes
  ipv6_ra_interval                          = each.value.ipv6_ra_interval
  ipv6_ra_life_time                         = each.value.ipv6_ra_life_time
  ipv6_reachable_time                       = each.value.ipv6_reachable_time
  lldp_receive                              = each.value.lldp_receive
  lldp_transmit                             = each.value.lldp_transmit
  logical_name                              = each.value.logical_name
  management_access                         = each.value.management_access
  management_access_network_objects         = each.value.management_access_network_objects
  management_only                           = each.value.management_only
  mtu                                       = each.value.mtu
  nve_only                                  = each.value.nve_only
  override_default_fragment_setting_chain   = each.value.override_default_fragment_setting_chain
  override_default_fragment_setting_size    = each.value.override_default_fragment_setting_size
  override_default_fragment_setting_timeout = each.value.override_default_fragment_setting_timeout
  priority                                  = each.value.priority
  security_zone_id                          = each.value.security_zone_id
  selected_interfaces                       = each.value.selected_interfaces
  speed                                     = each.value.speed
  standby_mac_address                       = each.value.standby_mac_address
}

##########################################################
###    DEVICE SUBINTERFACE
##########################################################
locals {
  data_device_subinterface = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for sub_interface in try(vrf.sub_interfaces, []) : {
              domain      = domain.name
              name        = sub_interface.name
              device_name = device.name
              device_id   = data.fmc_device.device["${domain.name}:${device.name}"].id
            }
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }

  resource_device_subinterface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for sub_interface in try(vrf.sub_interfaces, []) : {
              domain           = domain.name
              vrf_name         = vrf.name
              device_name      = device.name
              name             = sub_interface.name
              interface_name   = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 2]
              sub_interface_id = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 1]
              device_id        = local.map_devices["${domain.name}:${device.name}"].id
              vlan_id          = sub_interface.vlan

              active_mac_address             = try(sub_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.active_mac_address, null)
              allow_full_fragment_reassembly = try(sub_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.allow_full_fragment_reassembly, null)
              arp_table_entries = [for arp_table_entry in try(sub_interface.arp_table_entries, []) : {
                enabled     = try(arp_table_entry.enabled, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.arp_table_entries.enabled, null)
                ip_address  = arp_table_entry.ip_address
                mac_address = arp_table_entry.mac_address
              }]
              description                  = try(sub_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.description, null)
              anti_spoofing                = try(sub_interface.anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.anti_spoofing, null)
              sgt_propagate                = try(sub_interface.sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.sgt_propagate, null)
              enabled                      = try(sub_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.enabled, null)
              ip_based_monitoring          = try(sub_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ip_based_monitoring, null)
              ip_based_monitoring_next_hop = try(sub_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ip_based_monitoring_next_hop, null)
              ip_based_monitoring_type     = try(sub_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ip_based_monitoring_type, null)
              ipv4_address_pool_id = try(sub_interface.ipv4_address_pool, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_ipv4_address_pools["${domain_path}:${sub_interface.ipv4_address_pool}"].id
                  if contains(keys(local.map_ipv4_address_pools), "${domain_path}:${sub_interface.ipv4_address_pool}")
              })[0]) : null
              ipv4_dhcp_obtain_default_route        = try(sub_interface.ipv4_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_dhcp_obtain_default_route, null)
              ipv4_dhcp_default_route_metric        = try(sub_interface.ipv4_dhcp_default_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_dhcp_default_route_metric, null)
              ipv4_pppoe_authentication             = try(sub_interface.ipv4_pppoe_authentication, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_authentication, null)
              ipv4_pppoe_password                   = try(sub_interface.ipv4_pppoe_password, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_password, null)
              ipv4_pppoe_route_metric               = try(sub_interface.ipv4_pppoe_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_route_metric, null)
              ipv4_pppoe_route_settings             = try(sub_interface.ipv4_pppoe_route_settings, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_route_settings, null)
              ipv4_pppoe_store_credentials_in_flash = try(sub_interface.ipv4_pppoe_store_credentials_in_flash, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_store_credentials_in_flash, null)
              ipv4_pppoe_user                       = try(sub_interface.ipv4_pppoe_user, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_user, null)
              ipv4_pppoe_vpdn_group_name            = try(sub_interface.ipv4_pppoe_vpdn_group_name, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_pppoe_vpdn_group_name, null)
              ipv4_static_address                   = try(sub_interface.ipv4_static_address, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_static_address, null)
              ipv4_static_netmask                   = try(sub_interface.ipv4_static_netmask, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv4_static_netmask, null)
              ipv6_addresses = [for ipv6_address in try(sub_interface.ipv6_addresses, []) : {
                address     = ipv6_address.address
                enforce_eui = try(ipv6_address.enforce_eui, null)
                prefix      = ipv6_address.prefix
              }]
              ipv6_dad_attempts                 = try(sub_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dad_attempts, null)
              ipv6_dhcp_obtain_default_route    = try(sub_interface.ipv6_dhcp_obtain_default_route, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp_obtain_default_route, null)
              ipv6_dhcp                         = try(sub_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp, null)
              ipv6_dhcp_client_pd_hint_prefixes = try(sub_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
              ipv6_dhcp_client_pd_prefix_name   = try(sub_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
              # ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[sub_interface.ipv6_dhcp_pool].id, null)
              ipv6                        = try(sub_interface.ipv6, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6, null)
              ipv6_auto_config            = try(sub_interface.ipv6_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_auto_config, null)
              ipv6_dad                    = try(sub_interface.ipv6_dad, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dad, null)
              ipv6_dhcp_address_config    = try(sub_interface.ipv6_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp_address_config, null)
              ipv6_dhcp_nonaddress_config = try(sub_interface.ipv6_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_dhcp_nonaddress_config, null)
              ipv6_ra                     = try(sub_interface.ipv6_ra, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_ra, null)
              ipv6_enforce_eui            = try(sub_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_enforce_eui, null)
              ipv6_link_local_address     = try(sub_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_link_local_address, null)
              ipv6_ns_interval            = try(sub_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_ns_interval, null)
              ipv6_prefixes = [for ipv6_prefix in try(sub_interface.ipv6_prefixes, []) : {
                address = try(ipv6_prefix.address, null)
                default = try(ipv6_prefix.default, null)
              }]
              ipv6_ra_interval                          = try(sub_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_ra_interval, null)
              ipv6_ra_life_time                         = try(sub_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_ra_life_time, null)
              ipv6_reachable_time                       = try(sub_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.ipv6_reachable_time, null)
              logical_name                              = try(sub_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.logical_name, null)
              management_only                           = try(sub_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.management_only, null)
              mtu                                       = try(sub_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.mtu, null)
              nve_only                                  = try(sub_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.nve_only, null)
              override_default_fragment_setting_chain   = try(sub_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.override_default_fragment_setting_chain, null)
              override_default_fragment_setting_size    = try(sub_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.override_default_fragment_setting_size, null)
              override_default_fragment_setting_timeout = try(sub_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.override_default_fragment_setting_timeout, null)
              priority                                  = try(sub_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.priority, null)
              security_zone_id = try(sub_interface.security_zone, "") != "" ? try(
                values({
                  for domain_path in local.related_domains[domain.name] :
                  domain_path => local.map_security_zones["${domain_path}:${sub_interface.security_zone}"].id
                  if contains(keys(local.map_security_zones), "${domain_path}:${sub_interface.security_zone}")
              })[0]) : null
              standby_mac_address = try(sub_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.sub_interfaces.standby_mac_address, null)
            } if !contains(try(keys(local.data_device_subinterface), []), "${domain.name}:${device.name}:${sub_interface.name}")
          ]
        ]
      ]
    ]) : "${item.domain}:${item.device_name}:${item.name}" => item
  }
}

data "fmc_device_subinterface" "device_subinterface" {
  for_each = local.data_device_subinterface

  domain    = each.value.domain
  name      = each.value.name
  device_id = each.value.device_id
}

resource "fmc_device_subinterface" "device_subinterface" {
  for_each = local.resource_device_subinterface

  domain                                = each.value.domain
  device_id                             = each.value.device_id
  interface_name                        = each.value.interface_name
  sub_interface_id                      = each.value.sub_interface_id
  vlan_id                               = each.value.vlan_id
  active_mac_address                    = each.value.active_mac_address
  allow_full_fragment_reassembly        = each.value.allow_full_fragment_reassembly
  arp_table_entries                     = each.value.arp_table_entries
  description                           = each.value.description
  anti_spoofing                         = each.value.anti_spoofing
  sgt_propagate                         = each.value.sgt_propagate
  enabled                               = each.value.enabled
  ip_based_monitoring                   = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop          = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type              = each.value.ip_based_monitoring_type
  ipv4_dhcp_obtain_default_route        = each.value.ipv4_dhcp_obtain_default_route
  ipv4_dhcp_default_route_metric        = each.value.ipv4_dhcp_default_route_metric
  ipv4_pppoe_authentication             = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                   = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric               = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings             = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                       = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name            = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                   = each.value.ipv4_static_address
  ipv4_static_netmask                   = each.value.ipv4_static_netmask
  ipv6_addresses                        = each.value.ipv6_addresses
  ipv6_dad_attempts                     = each.value.ipv6_dad_attempts
  ipv6_dhcp_obtain_default_route        = each.value.ipv6_dhcp_obtain_default_route
  ipv6_dhcp                             = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes     = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name       = each.value.ipv6_dhcp_client_pd_prefix_name
  # ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6                                      = each.value.ipv6
  ipv6_auto_config                          = each.value.ipv6_auto_config
  ipv6_dad                                  = each.value.ipv6_dad
  ipv6_dhcp_address_config                  = each.value.ipv6_dhcp_address_config
  ipv6_dhcp_nonaddress_config               = each.value.ipv6_dhcp_nonaddress_config
  ipv6_ra                                   = each.value.ipv6_ra
  ipv6_enforce_eui                          = each.value.ipv6_enforce_eui
  ipv6_link_local_address                   = each.value.ipv6_link_local_address
  ipv6_ns_interval                          = each.value.ipv6_ns_interval
  ipv6_prefixes                             = each.value.ipv6_prefixes
  ipv6_ra_interval                          = each.value.ipv6_ra_interval
  ipv6_ra_life_time                         = each.value.ipv6_ra_life_time
  ipv6_reachable_time                       = each.value.ipv6_reachable_time
  logical_name                              = each.value.logical_name
  management_only                           = each.value.management_only
  mtu                                       = each.value.mtu
  override_default_fragment_setting_chain   = each.value.override_default_fragment_setting_chain
  override_default_fragment_setting_size    = each.value.override_default_fragment_setting_size
  override_default_fragment_setting_timeout = each.value.override_default_fragment_setting_timeout
  priority                                  = each.value.priority
  security_zone_id                          = each.value.security_zone_id
  standby_mac_address                       = each.value.standby_mac_address

  depends_on = [
    fmc_device_physical_interface.device_physical_interface,
    data.fmc_device_physical_interface.device_physical_interface,
    fmc_device_etherchannel_interface.device_etherchannel_interface,
    data.fmc_device_etherchannel_interface.device_etherchannel_interface,
  ]
}

##########################################################
###    CHASSIS
##########################################################
locals {
  data_chassis = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.chassis, {}) : {
          name   = device.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_chassis = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.chassis, []) : {
          domain           = domain.name
          name             = device.name
          host             = device.host
          registration_key = device.registration_key
          # device_group_id  = try(local.map_device_groups[device.device_group].id, null)
          nat_id = try(device.nat_id, null)
        } if !contains(try(keys(local.data_chassis), []), "${domain.name}:${device.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_chassis" "chassis" {
  for_each = local.data_chassis

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_chassis" "chassis" {
  for_each = local.resource_chassis

  domain           = each.value.domain
  name             = each.value.name
  host             = each.value.host
  registration_key = each.value.registration_key
  # device_group_id  = each.value.device_group_id
  nat_id = each.value.nat_id
}

##########################################################
###    CHASSIS PHYSICAL INTERFACE
##########################################################
locals {
  data_chassis_physical_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for chassis in try(domain.devices.chassis, []) : [
          for physical_interface in try(chassis.physical_interfaces, []) : {
            domain       = domain.name
            name         = physical_interface.name
            chassis_name = chassis.name
            chassis_id   = data.fmc_chassis.chassis["${domain.name}:${chassis.name}"].id
          }
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }

  resource_chassis_physical_interface = {
    for item in flatten([
      for domain in local.domains : [
        for chassis in try(domain.devices.chassis, []) : [
          for physical_interface in try(chassis.physical_interfaces, []) : {
            domain       = domain.name
            chassis_name = chassis.name
            name         = physical_interface.name
            chassis_id   = local.map_chassis["${domain.name}:${chassis.name}"].id

            speed            = try(physical_interface.speed, local.defaults.fmc.domains.devices.chassis.physical_interfaces.speed)
            port_type        = try(physical_interface.port_type, local.defaults.fmc.domains.devices.chassis.physical_interfaces.port_type)
            admin_state      = try(physical_interface.admin_state, local.defaults.fmc.domains.devices.chassis.physical_interfaces.admin_state)
            auto_negotiation = try(physical_interface.auto_negotiation, local.defaults.fmc.domains.devices.chassis.physical_interfaces.auto_negotiation, null)
            duplex           = try(physical_interface.duplex, local.defaults.fmc.domains.devices.chassis.physical_interfaces.duplex, null)
            fec_mode         = try(physical_interface.fec_mode, local.defaults.fmc.domains.devices.chassis.physical_interfaces.fec_mode, null)
          } if !contains(try(keys(local.data_chassis_physical_interface), []), "${domain.name}:${chassis.name}:${physical_interface.name}")
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }
}

data "fmc_chassis_physical_interface" "chassis_physical_interface" {
  for_each = local.data_chassis_physical_interface

  domain     = each.value.domain
  name       = each.value.name
  chassis_id = each.value.chassis_id
}

resource "fmc_chassis_physical_interface" "chassis_physical_interface" {
  for_each = local.resource_chassis_physical_interface

  domain           = each.value.domain
  name             = each.value.name
  chassis_id       = each.value.chassis_id
  speed            = each.value.speed
  port_type        = each.value.port_type
  admin_state      = each.value.admin_state
  auto_negotiation = each.value.auto_negotiation
  duplex           = each.value.duplex
  fec_mode         = each.value.fec_mode
}

##########################################################
###    DEVICE ETHERCHANNEL INTERFACE
##########################################################
locals {
  data_chassis_etherchannel_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for chassis in try(domain.devices.chassis, []) : [
          for etherchannel_interface in try(chassis.etherchannel_interfaces, []) : {
            domain       = domain.name
            name         = etherchannel_interface.name
            chassis_name = chassis.name
            chassis_id   = data.fmc_chassis.chassis["${domain.name}:${chassis.name}"].id
          }
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }

  resource_chassis_etherchannel_interface = {
    for item in flatten([
      for domain in local.domains : [
        for chassis in try(domain.devices.chassis, []) : [
          for etherchannel_interface in try(chassis.etherchannel_interfaces, []) : {
            domain       = domain.name
            chassis_name = chassis.name
            chassis_id   = local.map_chassis["${domain.name}:${chassis.name}"].id
            name         = etherchannel_interface.name

            ether_channel_id = split("Port-channel", etherchannel_interface.name)[length(split("Port-channel", etherchannel_interface.name)) - 1]
            port_type        = etherchannel_interface.port_type
            speed            = etherchannel_interface.speed
            admin_state      = try(etherchannel_interface.admin_state, local.defaults.fmc.domains.devices.chassis.etherchannel_interfaces.admin_state)
            auto_negotiation = try(etherchannel_interface.auto_negotiation, local.defaults.fmc.domains.devices.chassis.etherchannel_interfaces.auto_negotiation, null)
            duplex           = try(etherchannel_interface.duplex, local.defaults.fmc.domains.devices.chassis.etherchannel_interfaces.duplex, null)
            lacp_mode        = try(etherchannel_interface.lacp_mode, local.defaults.fmc.domains.devices.chassis.etherchannel_interfaces.lacp_mode, null)
            lacp_rate        = try(etherchannel_interface.lacp_rate, local.defaults.fmc.domains.devices.chassis.etherchannel_interfaces.lacp_rate, null)
            selected_interfaces = [for selected_interface in try(etherchannel_interface.selected_interfaces, []) : {
              name = selected_interface
              id   = try(fmc_chassis_physical_interface.chassis_physical_interface["${domain.name}:${chassis.name}:${selected_interface}"].id, data.fmc_chassis_physical_interface.chassis_physical_interface["${domain.name}:${chassis.name}:${selected_interface}"].id)
            }]
          } if !contains(try(keys(local.data_chassis_etherchannel_interface), []), "${domain.name}:${chassis.name}:${etherchannel_interface.name}")
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }
}

data "fmc_chassis_etherchannel_interface" "chassis_etherchannel_interface" {
  for_each = local.data_chassis_etherchannel_interface

  domain     = each.value.domain
  name       = each.value.name
  chassis_id = each.value.chassis_id
}

resource "fmc_chassis_etherchannel_interface" "chassis_etherchannel_interface" {
  for_each            = local.resource_chassis_etherchannel_interface
  domain              = each.value.domain
  chassis_id          = each.value.chassis_id
  ether_channel_id    = each.value.ether_channel_id
  port_type           = each.value.port_type
  speed               = each.value.speed
  admin_state         = each.value.admin_state
  auto_negotiation    = each.value.auto_negotiation
  duplex              = each.value.duplex
  lacp_mode           = each.value.lacp_mode
  lacp_rate           = each.value.lacp_rate
  selected_interfaces = each.value.selected_interfaces
}

##########################################################
###    CHASSIS SUBINTERFACE
##########################################################
locals {
  data_chassis_subinterface = {
    for item in flatten([
      for domain in local.data_existing : [
        for chassis in try(domain.devices.chassis, []) : [
          for sub_interface in try(chassis.sub_interfaces, []) : {
            domain       = domain.name
            name         = sub_interface.name
            chassis_name = chassis.name
            chassis_id   = data.fmc_chassis.chassis["${domain.name}:${chassis.name}"].id
          }
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }

  resource_chassis_subinterface = {
    for item in flatten([
      for domain in local.domains : [
        for chassis in try(domain.devices.chassis, []) : [
          for sub_interface in try(chassis.sub_interfaces, []) : {
            domain           = domain.name
            chassis_name     = chassis.name
            chassis_id       = local.map_chassis["${domain.name}:${chassis.name}"].id
            name             = sub_interface.name
            interface_name   = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 2]
            sub_interface_id = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 1]
            interface_id     = local.map_chassis_physical_and_ether_channel_interfaces["${domain.name}:${chassis.name}:${split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 2]}"].id
            vlan_id          = sub_interface.vlan
            port_type        = sub_interface.port_type
          } if !contains(try(keys(local.data_chassis_subinterface), []), "${domain.name}:${chassis.name}:${sub_interface.name}")
        ]
      ]
    ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
  }
}

data "fmc_chassis_subinterface" "chassis_subinterface" {
  for_each = local.data_chassis_subinterface

  domain     = each.value.domain
  name       = each.value.name
  chassis_id = each.value.chassis_id
}

resource "fmc_chassis_subinterface" "chassis_subinterface" {
  for_each = local.resource_chassis_subinterface

  domain           = each.value.domain
  chassis_id       = each.value.chassis_id
  interface_name   = each.value.interface_name
  interface_id     = each.value.interface_id
  port_type        = each.value.port_type
  sub_interface_id = each.value.sub_interface_id
  vlan_id          = each.value.vlan_id
}

##########################################################
###    CHASSIS LOGICAL DEVICE
##########################################################
locals {
  resource_chassis_logical_device = {
    for item in flatten([
      for domain in local.domains : [
        for chassis in try(domain.devices.chassis, []) : [
          for logical_device in try(chassis.logical_devices, []) : {
            domain                = domain.name
            chassis_name          = chassis.name
            chassis_id            = local.map_chassis["${domain.name}:${chassis.name}"].id
            name                  = logical_device.name
            ftd_version           = logical_device.ftd_version
            ipv4_address          = try(logical_device.ipv4_address, null)
            ipv4_netmask          = try(logical_device.ipv4_netmask, null)
            ipv4_gateway          = try(logical_device.ipv4_gateway, null)
            ipv6_address          = try(logical_device.ipv6_address, null)
            ipv6_prefix           = try(logical_device.ipv6_prefix, null)
            ipv6_gateway          = try(logical_device.ipv6_gateway, null)
            search_domain         = try(logical_device.search_domain, null)
            fqdn                  = try(logical_device.fqdn, null)
            firewall_mode         = logical_device.firewall_mode
            dns_servers           = try(join(",", logical_device.dns_servers), null)
            device_password       = logical_device.device_password
            admin_state           = try(logical_device.admin_state, local.defaults.fmc.domains.devices.chassis.logical_devices.admin_state, null)
            permit_expert_mode    = try(logical_device.permit_expert_mode, local.defaults.fmc.domains.devices.chassis.logical_devices.permit_expert_mode, null) == true ? "yes" : try(logical_device.permit_expert_mode, local.defaults.fmc.domains.devices.chassis.logical_devices.permit_expert_mode, null) == false ? "no" : null
            resource_profile_name = logical_device.resource_profile
            resource_profile_id = try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_resource_profiles["${domain_path}:${logical_device.resource_profile}"].id
                if contains(keys(local.map_resource_profiles), "${domain_path}:${logical_device.resource_profile}")
            })[0])
            assigned_interfaces = [for assigned_interface in try(logical_device.assigned_interfaces, []) : {
              id = local.map_chassis_interfaces["${domain.name}:${chassis.name}:${assigned_interface}"].id
            }]
            access_control_policy_id = try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_access_control_policies["${domain_path}:${logical_device.access_control_policy}"].id
                if contains(keys(local.map_access_control_policies), "${domain_path}:${logical_device.access_control_policy}")
            })[0])
            platform_settings_id = try(logical_device.platform_settings, "") != "" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ftd_platform_settings["${domain_path}:${logical_device.platform_settings}"].id
                if contains(keys(local.map_ftd_platform_settings), "${domain_path}:${logical_device.platform_settings}")
            })[0]) : null
            licenses = try(logical_device.licenses, null)
          }
        ]
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

resource "fmc_chassis_logical_device" "chassis_logical_device" {
  for_each = local.resource_chassis_logical_device

  domain                   = each.value.domain
  chassis_id               = each.value.chassis_id
  name                     = each.value.name
  ftd_version              = each.value.ftd_version
  ipv4_address             = each.value.ipv4_address
  ipv4_netmask             = each.value.ipv4_netmask
  ipv4_gateway             = each.value.ipv4_gateway
  ipv6_address             = each.value.ipv6_address
  ipv6_prefix              = each.value.ipv6_prefix
  ipv6_gateway             = each.value.ipv6_gateway
  search_domain            = each.value.search_domain
  fqdn                     = each.value.fqdn
  firewall_mode            = each.value.firewall_mode
  dns_servers              = each.value.dns_servers
  device_password          = each.value.device_password
  admin_state              = each.value.admin_state
  permit_expert_mode       = each.value.permit_expert_mode
  resource_profile_id      = each.value.resource_profile_id
  resource_profile_name    = each.value.resource_profile_name
  assigned_interfaces      = each.value.assigned_interfaces
  access_control_policy_id = each.value.access_control_policy_id
  platform_settings_id     = each.value.platform_settings_id
  licenses                 = each.value.licenses
}

##########################################################
###    FTD PLATFORM SETTINGS
##########################################################
locals {
  data_ftd_platform_settings = {
    for item in flatten([
      for domain in local.data_existing : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          name   = ftd_platform_setting.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_ftd_platform_settings = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain      = domain.name
          name        = ftd_platform_setting.name
          description = try(ftd_platform_setting.description, local.defaults.fmc.domains.devices.ftd_platform_settings.description, null)
        } if !contains(try(keys(local.data_ftd_platform_settings), []), "${domain.name}:${ftd_platform_setting.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_ftd_platform_settings" "ftd_platform_settings" {
  for_each = local.data_ftd_platform_settings

  domain = each.value.domain
  name   = each.value.name
}

resource "fmc_ftd_platform_settings" "ftd_platform_settings" {
  for_each = local.resource_ftd_platform_settings

  domain      = each.value.domain
  name        = each.value.name
  description = each.value.description
}

##########################################################
###    FTD PLATFORM SETTINGS BANNER
##########################################################
locals {
  resource_ftd_platform_settings_banner = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          text_lines = split("\n", trimsuffix(ftd_platform_setting.banner.text, "\n"))
        } if try(ftd_platform_setting.banner, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_banner" "ftd_platform_settings_banner" {
  for_each = local.resource_ftd_platform_settings_banner

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  text_lines = each.value.text_lines
}

##########################################################
###    FTD PLATFORM SETTINGS HTTP ACCESS
##########################################################
locals {
  resource_ftd_platform_settings_http_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          server_enabled = try(ftd_platform_setting.http_access.server_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.http_access.server_enabled, null)
          server_port    = try(ftd_platform_setting.http_access.server_port, local.defaults.fmc.domains.devices.ftd_platform_settings.http_access.server_port, null)
          configurations = [for configuration in try(ftd_platform_setting.http_access.configurations, []) : {
            source_network_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${configuration.source_network_object}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${configuration.source_network_object}")
            })[0]
            interface_literals = try(configuration.interface_literals, null)
            interface_objects = [for interface_object in try(configuration.interface_objects, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].type
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              name = interface_object
            }]
          }]
        } if try(ftd_platform_setting.http_access, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_http_access" "ftd_platform_settings_http_access" {
  for_each = local.resource_ftd_platform_settings_http_access

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  server_enabled           = each.value.server_enabled
  server_port              = each.value.server_port
  configurations           = each.value.configurations
}

##########################################################
###    FTD PLATFORM SETTINGS ICMP ACCESS
##########################################################
locals {
  resource_ftd_platform_settings_icmp_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          rate_limit = try(ftd_platform_setting.icmp_access.rate_limit, local.defaults.fmc.domains.devices.ftd_platform_settings.icmp_access.rate_limit, null)
          burst_size = try(ftd_platform_setting.icmp_access.burst_size, local.defaults.fmc.domains.devices.ftd_platform_settings.icmp_access.burst_size, null)
          configurations = [for configuration in try(ftd_platform_setting.icmp_access.configurations, []) : {
            action = configuration.action
            icmp_service_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_services["${domain_path}:${configuration.icmp_service_object}"].id
              if contains(keys(local.map_services), "${domain_path}:${configuration.icmp_service_object}")
            })[0]
            source_network_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${configuration.source_network_object}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${configuration.source_network_object}")
            })[0]
            interface_literals = try(configuration.interface_literals, null)
            interface_objects = [for interface_object in try(configuration.interface_objects, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].type
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              name = interface_object
            }]
          }]
        } if try(ftd_platform_setting.icmp_access, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_icmp_access" "ftd_platform_settings_icmp_access" {
  for_each = local.resource_ftd_platform_settings_icmp_access

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  rate_limit     = each.value.rate_limit
  burst_size     = each.value.burst_size
  configurations = each.value.configurations
}

##########################################################
###    FTD PLATFORM SETTINGS SSH ACCESS
##########################################################
locals {
  resource_ftd_platform_settings_ssh_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for ssh_access in try(ftd_platform_setting.ssh_accesses, []) : {
            domain                   = domain.name
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id
            source_network_object    = ssh_access.source_network_object

            source_network_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${ssh_access.source_network_object}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${ssh_access.source_network_object}")
            })[0],
            interface_literals = try(ssh_access.interface_literals, null)
            interface_objects = [for interface_object in try(ssh_access.interface_objects, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].type
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              name = interface_object
            }]
          }
        ]
      ]
    ]) : "${item.domain}:${item.platform_settings_name}:${item.source_network_object}" => item
  }
}

resource "fmc_ftd_platform_settings_ssh_access" "ftd_platform_settings_ssh_access" {
  for_each = local.resource_ftd_platform_settings_ssh_access

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  source_network_object_id = each.value.source_network_object_id
  interface_literals       = each.value.interface_literals
  interface_objects        = each.value.interface_objects
}

##########################################################
###    FTD PLATFORM SETTINGS SNMP
##########################################################
locals {
  resource_ftd_platform_settings_snmp = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          server_enabled       = try(ftd_platform_setting.snmp.server_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.server_enabled, null)
          server_port          = try(ftd_platform_setting.snmp.server_port, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.server_port, null)
          read_community       = try(ftd_platform_setting.snmp.read_community, null)
          system_administrator = try(ftd_platform_setting.snmp.system_administrator, null)
          location             = try(ftd_platform_setting.snmp.location, null)
          management_hosts = [for management_host in try(ftd_platform_setting.snmp.management_hosts, []) : {
            network_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${management_host.network_object}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${management_host.network_object}")
            })[0]
            snmp_version             = management_host.snmp_version
            username                 = management_host.snmp_version == "SNMPv3" ? try(management_host.username, null) : null
            read_community           = management_host.snmp_version != "SNMPv3" ? try(management_host.read_community, null) : null
            poll                     = try(management_host.poll, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.poll, null)
            trap                     = try(management_host.trap, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.trap, null)
            trap_port                = try(management_host.trap_port, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.trap_port, null)
            use_management_interface = try(management_host.use_management_interface, null)
            interface_literals       = try(management_host.interface_literals, null)
            interface_objects = [for interface_object in try(management_host.interface_objects, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].type
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              name = interface_object
            }]
          }]
          snmpv3_users = [for snmpv3_user in try(ftd_platform_setting.snmp.snmpv3_users, []) : {
            security_level           = snmpv3_user.security_level
            username                 = snmpv3_user.username
            password_type            = contains(["Auth", "Priv"], snmpv3_user.security_level) ? snmpv3_user.password_type : null
            authentication_algorithm = contains(["Auth", "Priv"], snmpv3_user.security_level) ? snmpv3_user.authentication_algorithm : null
            authentication_password  = contains(["Auth", "Priv"], snmpv3_user.security_level) ? snmpv3_user.authentication_password : null
            encryption_algorithm     = snmpv3_user.security_level == "Priv" ? snmpv3_user.encryption_algorithm : null
            encryption_password      = snmpv3_user.security_level == "Priv" ? snmpv3_user.encryption_password : null
          }]
          trap_syslog                        = try(ftd_platform_setting.snmp.traps.syslog, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.syslog, null)
          trap_authentication                = try(ftd_platform_setting.snmp.traps.authentication, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.authentication, null)
          trap_link_up                       = try(ftd_platform_setting.snmp.traps.link_up, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.link_up, null)
          trap_link_down                     = try(ftd_platform_setting.snmp.traps.link_down, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.link_down, null)
          trap_cold_start                    = try(ftd_platform_setting.snmp.traps.cold_start, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.cold_start, null)
          trap_warm_start                    = try(ftd_platform_setting.snmp.traps.warm_start, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.warm_start, null)
          trap_field_replacement_unit_insert = try(ftd_platform_setting.snmp.traps.field_replacement_unit_insert, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.field_replacement_unit_insert, null)
          trap_field_replacement_unit_delete = try(ftd_platform_setting.snmp.traps.field_replacement_unit_delete, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.field_replacement_unit_delete, null)
          trap_configuration_change          = try(ftd_platform_setting.snmp.traps.configuration_change, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.configuration_change, null)
          trap_connection_limit_reached      = try(ftd_platform_setting.snmp.traps.connection_limit_reached, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.connection_limit_reached, null)
          trap_nat_packet_discard            = try(ftd_platform_setting.snmp.traps.nat_packet_discard, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.nat_packet_discard, null)
          trap_cpu_rising                    = try(ftd_platform_setting.snmp.traps.cpu_rising, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.cpu_rising, null)
          trap_cpu_rising_threshold          = try(ftd_platform_setting.snmp.traps.cpu_rising_threshold, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.cpu_rising_threshold, null)
          trap_cpu_rising_interval           = try(ftd_platform_setting.snmp.traps.cpu_rising_interval, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.cpu_rising_interval, null)
          trap_memory_rising                 = try(ftd_platform_setting.snmp.traps.memory_rising, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.memory_rising, null)
          trap_memory_rising_threshold       = try(ftd_platform_setting.snmp.traps.memory_rising_threshold, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.memory_rising_threshold, null)
          trap_failover_state                = try(ftd_platform_setting.snmp.traps.failover_state, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.failover_state, null)
          trap_cluster_state                 = try(ftd_platform_setting.snmp.traps.cluster_state, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.cluster_state, null)
          trap_peer_flap                     = try(ftd_platform_setting.snmp.traps.peer_flap, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.traps.peer_flap, null)
        } if try(ftd_platform_setting.snmp, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_snmp" "ftd_platform_settings_snmp" {
  for_each = local.resource_ftd_platform_settings_snmp

  domain                             = each.value.domain
  ftd_platform_settings_id           = each.value.ftd_platform_settings_id
  server_enabled                     = each.value.server_enabled
  server_port                        = each.value.server_port
  read_community                     = each.value.read_community
  system_administrator               = each.value.system_administrator
  location                           = each.value.location
  management_hosts                   = each.value.management_hosts
  snmpv3_users                       = each.value.snmpv3_users
  trap_syslog                        = each.value.trap_syslog
  trap_authentication                = each.value.trap_authentication
  trap_link_up                       = each.value.trap_link_up
  trap_link_down                     = each.value.trap_link_down
  trap_cold_start                    = each.value.trap_cold_start
  trap_warm_start                    = each.value.trap_warm_start
  trap_field_replacement_unit_insert = each.value.trap_field_replacement_unit_insert
  trap_field_replacement_unit_delete = each.value.trap_field_replacement_unit_delete
  trap_configuration_change          = each.value.trap_configuration_change
  trap_connection_limit_reached      = each.value.trap_connection_limit_reached
  trap_nat_packet_discard            = each.value.trap_nat_packet_discard
  trap_cpu_rising                    = each.value.trap_cpu_rising
  trap_cpu_rising_threshold          = each.value.trap_cpu_rising_threshold
  trap_cpu_rising_interval           = each.value.trap_cpu_rising_interval
  trap_memory_rising                 = each.value.trap_memory_rising
  trap_memory_rising_threshold       = each.value.trap_memory_rising_threshold
  trap_failover_state                = each.value.trap_failover_state
  trap_cluster_state                 = each.value.trap_cluster_state
  trap_peer_flap                     = each.value.trap_peer_flap
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG LOGGING SETUP
##########################################################
locals {
  resource_ftd_platform_settings_syslog_logging_setup = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          logging_enabled                          = try(ftd_platform_setting.syslog.logging_setup.logging_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.logging_enabled, null)
          logging_on_failover_standby_unit_enabled = try(ftd_platform_setting.syslog.logging_setup.logging_on_failover_standby_unit_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.logging_on_failover_standby_unit_enabled, null)
          emblem_format                            = try(ftd_platform_setting.syslog.logging_setup.emblem_format, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.emblem_format, null)
          send_debug_messages_as_syslog            = try(ftd_platform_setting.syslog.logging_setup.send_debug_messages_as_syslog, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.send_debug_messages_as_syslog, null)
          internal_buffer_memory_size              = try(ftd_platform_setting.syslog.logging_setup.internal_buffer_memory_size, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.internal_buffer_memory_size, null)
          fmc_logging_mode                         = try(ftd_platform_setting.syslog.logging_setup.fmc_logging_mode, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_mode, null)
          fmc_logging_level                        = try(ftd_platform_setting.syslog.logging_setup.fmc_logging_mode, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_mode, null) != "OFF" ? try(ftd_platform_setting.syslog.logging_setup.fmc_logging_level, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_level, null) : null
          ftp_server_host_id = try(ftd_platform_setting.syslog.logging_setup.ftp_server_host, "") != "" ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_network_objects["${domain_path}:${ftd_platform_setting.syslog.logging_setup.ftp_server_host}"].id
            if contains(keys(local.map_network_objects), "${domain_path}:${ftd_platform_setting.syslog.logging_setup.ftp_server_host}")
          })[0] : null
          ftp_server_username      = try(ftd_platform_setting.syslog.logging_setup.ftp_server_username, null)
          ftp_server_path          = try(ftd_platform_setting.syslog.logging_setup.ftp_server_path, null)
          ftp_server_password      = try(ftd_platform_setting.syslog.logging_setup.ftp_server_password, null)
          flash_enabled            = try(ftd_platform_setting.syslog.logging_setup.flash_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_enabled, null)
          flash_maximum_space      = try(ftd_platform_setting.syslog.logging_setup.flash_maximum_space, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_maximum_space, null)
          flash_minimum_free_space = try(ftd_platform_setting.syslog.logging_setup.flash_minimum_free_space, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_minimum_free_space, null)
        } if try(ftd_platform_setting.syslog.logging_setup, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_logging_setup" "ftd_platform_settings_syslog_logging_setup" {
  for_each = local.resource_ftd_platform_settings_syslog_logging_setup

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  logging_enabled                          = each.value.logging_enabled
  logging_on_failover_standby_unit_enabled = each.value.logging_on_failover_standby_unit_enabled
  emblem_format                            = each.value.emblem_format
  send_debug_messages_as_syslog            = each.value.send_debug_messages_as_syslog
  internal_buffer_memory_size              = each.value.internal_buffer_memory_size
  fmc_logging_mode                         = each.value.fmc_logging_mode
  fmc_logging_level                        = each.value.fmc_logging_level
  ftp_server_host_id                       = each.value.ftp_server_host_id
  ftp_server_username                      = each.value.ftp_server_username
  ftp_server_path                          = each.value.ftp_server_path
  ftp_server_password                      = each.value.ftp_server_password
  flash_enabled                            = each.value.flash_enabled
  flash_maximum_space                      = each.value.flash_maximum_space
  flash_minimum_free_space                 = each.value.flash_minimum_free_space
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG LOGGING DESTINATIONS
##########################################################
locals {
  resource_ftd_platform_settings_syslog_logging_destination = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for logging_destination in try(ftd_platform_setting.syslog.logging_destinations, []) : {
            domain                   = domain.name
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

            logging_destination                = logging_destination.destination
            global_event_class_filter_criteria = logging_destination.global_event_class_filter_criteria
            global_event_class_filter_value    = logging_destination.global_event_class_filter_criteria != "DISABLE" ? try(logging_destination.global_event_class_filter_value, null) : null
            event_class_filters = [for class_filter in try(logging_destination.event_class_filters, []) : {
              class    = class_filter.class
              severity = class_filter.severity
            }]
          }
        ]
      ]
    ]) : "${item.domain}:${item.platform_settings_name}:${item.logging_destination}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_logging_destination" "ftd_platform_settings_syslog_logging_destination" {
  for_each = local.resource_ftd_platform_settings_syslog_logging_destination

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  logging_destination                = each.value.logging_destination
  global_event_class_filter_criteria = each.value.global_event_class_filter_criteria
  global_event_class_filter_value    = each.value.global_event_class_filter_value
  event_class_filters                = each.value.event_class_filters
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG EMAIL SETUP
##########################################################
locals {
  resource_ftd_platform_settings_syslog_email_setup = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          source_email_address = ftd_platform_setting.syslog.email_setup.source_email_address
          destinations = [for destination in try(ftd_platform_setting.syslog.email_setup.destinations, []) : {
            email_addresses = destination.email_addresses
            logging_level   = destination.logging_level
          }]
        } if try(ftd_platform_setting.syslog.email_setup, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_email_setup" "ftd_platform_settings_syslog_email_setup" {
  for_each = local.resource_ftd_platform_settings_syslog_email_setup

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  source_email_address = each.value.source_email_address
  destinations         = each.value.destinations
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG EVENT LIST
##########################################################
locals {
  resource_ftd_platform_settings_syslog_event_list = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for event_list in try(ftd_platform_setting.syslog.event_lists, []) : {
            domain                   = domain.name
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

            name = event_list.name
            event_classes = [for event_class in try(event_list.event_classes, []) : {
              class    = event_class.class
              severity = event_class.severity
            }]
            message_ids = try(event_list.message_ids, null)
          }
        ]
      ]
    ]) : "${item.domain}:${item.platform_settings_name}:${item.name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_event_list" "ftd_platform_settings_syslog_event_list" {
  for_each = local.resource_ftd_platform_settings_syslog_event_list

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  name          = each.value.name
  event_classes = each.value.event_classes
  message_ids   = each.value.message_ids
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG RATE LIMIT
##########################################################
locals {
  resource_ftd_platform_settings_syslog_rate_limit = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for rate_limit in try(ftd_platform_setting.syslog.rate_limits, []) : {
            domain                   = domain.name
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

            rate_limit_type    = rate_limit.type
            rate_limit_value   = rate_limit.value
            number_of_messages = rate_limit.number_of_messages
            interval           = try(rate_limit.interval, null)
          }
        ]
      ]
    ]) : "${item.domain}:${item.platform_settings_name}:${item.rate_limit_value}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_rate_limit" "ftd_platform_settings_syslog_rate_limit" {
  for_each = local.resource_ftd_platform_settings_syslog_rate_limit

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  rate_limit_type    = each.value.rate_limit_type
  rate_limit_value   = each.value.rate_limit_value
  number_of_messages = each.value.number_of_messages
  interval           = each.value.interval
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG SETTINGS
##########################################################
locals {
  resource_ftd_platform_settings_syslog_settings = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          facility               = try(ftd_platform_setting.syslog.settings.facility, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.facility, null)
          timestamp_format       = try(ftd_platform_setting.syslog.settings.timestamp_format, null)
          device_id_source       = try(ftd_platform_setting.syslog.settings.device_id_source, null)
          device_id_user_defined = try(ftd_platform_setting.syslog.settings.device_id_source, null) == "USERDEFINEDID" ? ftd_platform_setting.syslog.settings.device_id_user_defined : null
          device_id_interface_id = try(ftd_platform_setting.syslog.settings.device_id_source, null) == "INTERFACE" ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones["${domain_path}:${ftd_platform_setting.syslog.settings.device_id_interface}"].id
            if contains(keys(local.map_security_zones), "${domain_path}:${ftd_platform_setting.syslog.settings.device_id_interface}")
          })[0] : null
          all_syslog_messages_enabled       = try(ftd_platform_setting.syslog.settings.all_syslog_messages_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.all_syslog_messages_enabled, null)
          all_syslog_messages_logging_level = try(ftd_platform_setting.syslog.settings.all_syslog_messages_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.all_syslog_messages_enabled, null) == true ? ftd_platform_setting.syslog.settings.all_syslog_messages_logging_level : null
        } if try(ftd_platform_setting.syslog.settings, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_settings" "ftd_platform_settings_syslog_settings" {
  for_each = local.resource_ftd_platform_settings_syslog_settings

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  facility                          = each.value.facility
  timestamp_format                  = each.value.timestamp_format
  device_id_source                  = each.value.device_id_source
  device_id_user_defined            = each.value.device_id_user_defined
  device_id_interface_id            = each.value.device_id_interface_id
  all_syslog_messages_enabled       = each.value.all_syslog_messages_enabled
  all_syslog_messages_logging_level = each.value.all_syslog_messages_logging_level
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG SETTINGS SYSLOG ID
##########################################################
locals {
  resource_ftd_platform_settings_syslog_settings_syslog_id = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for syslog_id in try(ftd_platform_setting.syslog.settings.syslog_ids, []) : {
            domain                   = domain.name
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

            syslog_id     = syslog_id.syslog_id
            logging_level = try(syslog_id.logging_level, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.syslog_ids.logging_level, null)
            enabled       = try(syslog_id.enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.syslog_ids.enabled, null)
          }
        ]
      ]
    ]) : "${item.domain}:${item.platform_settings_name}:${item.syslog_id}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_settings_syslog_id" "ftd_platform_settings_syslog_settings_syslog_id" {
  for_each = local.resource_ftd_platform_settings_syslog_settings_syslog_id

  domain                                   = each.value.domain
  ftd_platform_settings_id                 = each.value.ftd_platform_settings_id
  ftd_platform_settings_syslog_settings_id = each.value.ftd_platform_settings_id

  syslog_id     = each.value.syslog_id
  logging_level = each.value.logging_level
  enabled       = each.value.enabled
}

##########################################################
###    FTD PLATFORM SETTINGS SYSLOG SETTINGS SYSLOG SERVERS
##########################################################
locals {
  resource_ftd_platform_settings_syslog_servers = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          allow_user_traffic_when_tcp_syslog_server_is_down = try(ftd_platform_setting.syslog.servers.allow_user_traffic_when_tcp_syslog_server_is_down, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.allow_user_traffic_when_tcp_syslog_server_is_down, null)
          message_queue_size                                = try(ftd_platform_setting.syslog.servers.message_queue_size, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.message_queue_size, null)
          servers = [for server in try(ftd_platform_setting.syslog.servers.servers, []) : {
            network_object_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_network_objects["${domain_path}:${server.network_object}"].id
              if contains(keys(local.map_network_objects), "${domain_path}:${server.network_object}")
            })[0]
            protocol                 = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null)
            port                     = try(server.port, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.port, null)
            emblem_format            = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null) == "UDP" ? try(server.emblem_format, null) : null
            secure_syslog            = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null) == "TCP" ? try(server.secure_syslog, null) : null
            use_management_interface = try(server.use_management_interface, null)
            interface_literals       = try(server.interface_literals, null)
            interface_objects = [for interface_object in try(server.interface_objects, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].id
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              type = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_security_zones["${domain_path}:${interface_object}"].type
                if contains(keys(local.map_security_zones), "${domain_path}:${interface_object}")
              })[0]
              name = interface_object
            }]
          }]
        } if try(ftd_platform_setting.syslog.servers, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_servers" "ftd_platform_settings_syslog_servers" {
  for_each = local.resource_ftd_platform_settings_syslog_servers

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  allow_user_traffic_when_tcp_syslog_server_is_down = each.value.allow_user_traffic_when_tcp_syslog_server_is_down
  message_queue_size                                = each.value.message_queue_size
  servers                                           = each.value.servers
}

##########################################################
###    FTD PLATFORM SETTINGS TIME SYNCHRONIZATION
##########################################################
locals {
  resource_ftd_platform_settings_time_synchronization = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : {
          domain                   = domain.name
          platform_settings_name   = ftd_platform_setting.name
          ftd_platform_settings_id = local.map_ftd_platform_settings["${domain.name}:${ftd_platform_setting.name}"].id

          synchronization_mode = ftd_platform_setting.time_synchronization.mode
          ntp_servers          = ftd_platform_setting.time_synchronization.mode == "SYNC_VIA_NTP_SERVER" ? ftd_platform_setting.time_synchronization.ntp_servers : null
        } if try(ftd_platform_setting.time_synchronization, null) != null
      ]
    ]) : "${item.domain}:${item.platform_settings_name}" => item
  }
}

resource "fmc_ftd_platform_settings_time_synchronization" "ftd_platform_settings_time_synchronization" {
  for_each = local.resource_ftd_platform_settings_time_synchronization

  domain                   = each.value.domain
  ftd_platform_settings_id = each.value.ftd_platform_settings_id

  synchronization_mode = each.value.synchronization_mode
  ntp_servers          = each.value.ntp_servers
}

##########################################################
###    Create maps for combined set of _data and _resources devices  
##########################################################

######
### map_devices
######
locals {
  map_devices = merge(
    # Devices - individual mode outputs
    { for key, resource in fmc_device.device : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Devices - data source
    { for key, data in data.fmc_device.device : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },

    # Chassis logical device - individual mode outputs
    { for key, resource in fmc_chassis_logical_device.chassis_logical_device : "${resource.domain}:${resource.name}" => { id = resource.device_id, type = resource.type } },
  )
}

######
### map_vrfs
######
locals {
  map_vrfs = merge(
    {
      for item in flatten([
        for vrf_key, vrf_value in local.resource_device_vrf : {
          domain      = vrf_value.domain
          device_name = vrf_value.device_name
          name        = vrf_value.name
          id          = fmc_device_vrf.device_vrf[vrf_key].id
          type        = fmc_device_vrf.device_vrf[vrf_key].type
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for vrf_key, vrf_value in local.data_device_vrf : {
          domain      = vrf_value.domain
          device_name = vrf_value.device_name
          name        = vrf_value.name
          id          = data.fmc_device_vrf.device_vrf[vrf_key].id
          type        = data.fmc_device_vrf.device_vrf[vrf_key].type
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
  )
}

######
### map_interface_by_names
######
locals {
  map_interfaces_by_names = merge(
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.resource_device_physical_interface : {
          name         = physical_interface_value.name
          type         = fmc_device_physical_interface.device_physical_interface[physical_interface_key].type
          device_name  = physical_interface_value.device_name
          id           = fmc_device_physical_interface.device_physical_interface[physical_interface_key].id
          logical_name = try(physical_interface_value.logical_name, null)
          domain       = physical_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.data_device_physical_interface : {
          name         = physical_interface_value.name
          type         = data.fmc_device_physical_interface.device_physical_interface[physical_interface_key].type
          device_name  = physical_interface_value.device_name
          id           = data.fmc_device_physical_interface.device_physical_interface[physical_interface_key].id
          logical_name = try(data.fmc_device_physical_interface.device_physical_interface[physical_interface_key].logical_name, null)
          domain       = physical_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.resource_device_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          type         = fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].type
          device_name  = etherchannel_interface_value.device_name
          id           = fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].id
          logical_name = etherchannel_interface_value.logical_name
          domain       = etherchannel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.data_device_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          type         = data.fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].type
          device_name  = etherchannel_interface_value.device_name
          id           = data.fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].id
          logical_name = try(data.fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].logical_name, null)
          domain       = etherchannel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for subinterface_key, subinterface_value in local.resource_device_subinterface : {
          name         = subinterface_value.name
          type         = fmc_device_subinterface.device_subinterface[subinterface_key].type
          device_name  = subinterface_value.device_name
          id           = fmc_device_subinterface.device_subinterface[subinterface_key].id
          logical_name = try(subinterface_value.logical_name, null)
          domain       = subinterface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for subinterface_key, subinterface_value in local.data_device_subinterface : {
          name         = subinterface_value.name
          type         = data.fmc_device_subinterface.device_subinterface[subinterface_key].type
          device_name  = subinterface_value.device_name
          id           = data.fmc_device_subinterface.device_subinterface[subinterface_key].id
          logical_name = try(data.fmc_device_subinterface.device_subinterface[subinterface_key].logical_name, null)
          domain_name  = subinterface_value.domain_name
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
  )
}

######
### map_interfaces_by_logical_names
######
locals {
  map_interfaces_by_logical_names = merge({
    for item in flatten([
      for physical_interface_key, physical_interface_value in local.resource_device_physical_interface : {
        name         = physical_interface_value.name
        device_name  = physical_interface_value.device_name
        id           = fmc_device_physical_interface.device_physical_interface[physical_interface_key].id
        logical_name = try(physical_interface_value.logical_name, null)
        domain       = physical_interface_value.domain
      }
    ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.data_device_physical_interface : {
          name         = physical_interface_value.name
          device_name  = physical_interface_value.device_name
          id           = data.fmc_device_physical_interface.device_physical_interface[physical_interface_key].id
          logical_name = try(data.fmc_device_physical_interface.device_physical_interface[physical_interface_key].logical_name, null)
          domain       = physical_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.resource_device_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          device_name  = etherchannel_interface_value.device_name
          id           = fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].id
          logical_name = etherchannel_interface_value.logical_name
          domain       = etherchannel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.data_device_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          device_name  = etherchannel_interface_value.device_name
          id           = data.fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].id
          logical_name = try(data.fmc_device_etherchannel_interface.device_etherchannel_interface[etherchannel_interface_key].logical_name, null)
          domain       = etherchannel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for subinterface_key, subinterface_value in local.resource_device_subinterface : {
          name         = subinterface_value.name
          device_name  = subinterface_value.device_name
          id           = fmc_device_subinterface.device_subinterface[subinterface_key].id
          logical_name = subinterface_value.logical_name
          domain       = subinterface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for subinterface_key, subinterface_value in local.data_device_subinterface : {
          name         = subinterface_value.name
          device_name  = subinterface_value.device_name
          id           = data.fmc_device_subinterface.device_subinterface[subinterface_key].id
          logical_name = try(data.fmc_device_subinterface.device_subinterface[subinterface_key].logical_name, null)
          domain       = subinterface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
  )
}

######
### map_chassis
######
locals {
  map_chassis = merge(
    # Chassis - individual mode outputs
    { for key, resource in fmc_chassis.chassis : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Chassis - data source
    { for key, data in data.fmc_chassis.chassis : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )
}

######
### map_chassis_physical_and_etherchannel_interfaces
######
locals {
  map_chassis_physical_and_ether_channel_interfaces = merge(
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.resource_chassis_physical_interface : {
          name         = physical_interface_value.name
          chassis_name = physical_interface_value.chassis_name
          id           = fmc_chassis_physical_interface.chassis_physical_interface[physical_interface_key].id
          domain       = physical_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.data_chassis_physical_interface : {
          name         = physical_interface_value.name
          chassis_name = physical_interface_value.chassis_name
          id           = data.fmc_chassis_physical_interface.chassis_physical_interface[physical_interface_key].id
          domain       = physical_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for ether_channel_interface_key, ether_channel_interface_value in local.resource_chassis_etherchannel_interface : {
          name         = ether_channel_interface_value.name
          chassis_name = ether_channel_interface_value.chassis_name
          id           = fmc_chassis_etherchannel_interface.chassis_etherchannel_interface[ether_channel_interface_key].id
          domain       = ether_channel_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for ether_channel_interface_key, ether_channel_interface_value in local.data_chassis_etherchannel_interface : {
          name         = ether_channel_interface_value.name
          chassis_name = ether_channel_interface_value.chassis_name
          id           = data.fmc_chassis_etherchannel_interface.chassis_etherchannel_interface[ether_channel_interface_key].id
          domain       = ether_channel_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
  )
}

######
### map_chassis_interfaces
######
locals {
  map_chassis_interfaces = merge(
    local.map_chassis_physical_and_ether_channel_interfaces,
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.resource_chassis_subinterface : {
          name         = sub_interface_value.name
          chassis_name = sub_interface_value.chassis_name
          id           = fmc_chassis_subinterface.chassis_subinterface[sub_interface_key].id
          domain       = sub_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.data_chassis_subinterface : {
          name         = sub_interface_value.name
          chassis_name = sub_interface_value.chassis_name
          id           = data.fmc_chassis_subinterface.chassis_subinterface[sub_interface_key].id
          domain       = sub_interface_value.domain
        }
      ]) : "${item.domain}:${item.chassis_name}:${item.name}" => item
    },
  )
}

######
### map_ftd_platform_settings
######
locals {
  map_ftd_platform_settings = merge(
    {
      for item in flatten([
        for ftd_platform_setting_key, ftd_platform_setting_value in local.resource_ftd_platform_settings : {
          name   = ftd_platform_setting_value.name
          id     = fmc_ftd_platform_settings.ftd_platform_settings[ftd_platform_setting_key].id
          type   = fmc_ftd_platform_settings.ftd_platform_settings[ftd_platform_setting_key].type
          domain = ftd_platform_setting_value.domain
        }
      ]) : "${item.domain}:${item.name}" => item
    },
    {
      for item in flatten([
        for ftd_platform_setting_key, ftd_platform_setting_value in local.data_ftd_platform_settings : {
          name   = ftd_platform_setting_value.name
          id     = data.fmc_ftd_platform_settings.ftd_platform_settings[ftd_platform_setting_key].id
          type   = data.fmc_ftd_platform_settings.ftd_platform_settings[ftd_platform_setting_key].type
          domain = ftd_platform_setting_value.domain
        }
      ]) : "${item.domain}:${item.name}" => item
    },
  )
}

######
### map_device_to_container
######
locals {
  map_device_to_container = merge(
    { for key, ha_pair in data.fmc_device_ha_pair.device_ha_pair : ha_pair.primary_device_id => { id = ha_pair.id } },
    { for key, ha_pair in fmc_device_ha_pair.device_ha_pair : ha_pair.primary_device_id => { id = ha_pair.id } }
  )
}

######
### FAKE - TODO
######
locals {
  map_device_groups = {}
}