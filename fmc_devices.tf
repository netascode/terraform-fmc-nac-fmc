##########################################################
###    Content of the file:
##########################################################
#
###
#  Resources
####
# resource "fmc_device" "module" 
# resource "fmc_device_ha_pair" "module" 
# resource "fmc_device_ha_pair_monitoring" "module" 
# resource "fmc_device_cluster" "module" 
# resource "fmc_device_physical_interface" "module" 
# resource "fmc_device_etherchannel_interface" "module" 
# resource "fmc_device_subinterface" "module" 
#
###  
#  Local variables
###
#  local.resource_device 
#  local.resource_device_ha_pair 
#  local.resource_device_ha_pair_monitored_interface 
#  local.resource_device_cluster
#  local.resource_physical_interface 
#  local.resource_etherchannel_interface 
#  local.resource_sub_interface 
#
#  local.map_devices 
#  local.map_vrfs 
#  local.map_interface_names 
#  local.map_interface_logical_names 
#  local.map_device_groups - fake
#
###

##########################################################
###    DEVICE
##########################################################

locals {

  resource_device = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          {
            name                 = device.name # MyDeviceName
            host_name            = device.host # IP or FQDN
            license_capabilities = device.licenses
            registration_key     = device.registration_key

            access_policy_id = local.map_access_control_policies[device.access_policy].id
            device_group_id  = try(local.map_device_groups[device.device_group].id, null)
            health_policy_id = try(local.map_health_policies[device.health_policy].id, null)
            nat_policy_id    = try(local.map_ftd_nat_policies[device.nat_policy].id, null)

            nat_id                   = try(device.nat_id, local.defaults.fmc.domains.devices.devices.nat_id, null)
            object_group_search      = try(device.object_group_search, local.defaults.fmc.domains.devices.devices.object_group_search, null)
            performance_tier         = try(device.performance_tier, local.defaults.fmc.domains.devices.devices.performance_tier, null)
            prohibit_packet_transfer = try(device.prohibit_packet_transfer, null)
            snort_engine             = try(device.snort_engine, local.defaults.fmc.domains.devices.devices.snort_engine, null)

            domain_name = domain.name
          }
        ] if !contains(try(keys(local.data_device), []), device.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_device), []), item.name) #The device name is unique across the different domains.
  }

}

resource "fmc_device" "module" {
  for_each = local.resource_device

  # Mandatory
  name                 = each.key
  host_name            = each.value.host_name
  registration_key     = each.value.registration_key
  access_policy_id     = each.value.access_policy_id
  license_capabilities = each.value.license_capabilities

  #Optional
  device_group_id  = each.value.device_group_id
  health_policy_id = each.value.health_policy_id
  nat_policy_id    = each.value.nat_policy_id

  nat_id                   = each.value.nat_id
  object_group_search      = each.value.object_group_search
  performance_tier         = each.value.performance_tier
  prohibit_packet_transfer = each.value.prohibit_packet_transfer
  snort_engine             = each.value.snort_engine

  domain = each.value.domain_name

  depends_on = [
    data.fmc_access_control_policy.module,
    fmc_access_control_policy.module,
    data.fmc_device.module,
  ]

}

##########################################################
###    DEVICE HA Pair
##########################################################

locals {

  resource_device_ha_pair = {
    for item in flatten([
      for domain in local.domains : [
        for ha_pair in try(domain.devices.ha_pairs, []) : [
          {
            # Mandatory
            name = ha_pair.name

            primary_device_id   = local.map_devices[ha_pair.primary_device].id
            secondary_device_id = local.map_devices[ha_pair.secondary_device].id

            ha_link_interface_id      = local.map_interface_names["${ha_pair.primary_device}:${ha_pair.ha_link_interface_name}"].id
            ha_link_interface_name    = ha_pair.ha_link_interface_name
            ha_link_interface_type    = local.map_interface_names["${ha_pair.primary_device}:${ha_pair.ha_link_interface_name}"].type
            ha_link_logical_name      = ha_pair.ha_link_logical_name
            ha_link_primary_ip        = ha_pair.ha_link_primary_ip
            ha_link_secondary_ip      = ha_pair.ha_link_secondary_ip
            ha_link_netmask           = ha_pair.ha_link_netmask
            state_link_use_same_as_ha = ha_pair.state_link_use_same_as_ha

            # Optional
            action                           = try(ha_pair.action, null)
            encryption_enabled               = try(ha_pair.encryption_enabled, null)
            encryption_key                   = try(ha_pair.encryption_key, null)
            encryption_key_generation_scheme = try(ha_pair.encryption_key_generation_scheme, null)
            failed_interfaces_limit          = try(ha_pair.failed_interfaces_limit, local.defaults.fmc.domains.devices.ha_pairs.failed_interfaces_limit, null)
            failed_interfaces_percent        = try(ha_pair.failed_interfaces_percent, null)
            ha_link_use_ipv6                 = try(ha_pair.ha_link_use_ipv6, null)
            interface_hold_time              = try(ha_pair.interface_hold_time, null)
            interface_poll_time              = try(ha_pair.interface_poll_time, null)
            interface_poll_time_unit         = try(ha_pair.interface_poll_time_unit, null)
            peer_hold_time                   = try(ha_pair.peer_hold_time, null)
            peer_hold_time_unit              = try(ha_pair.peer_hold_time_unit, null)
            peer_poll_time                   = try(ha_pair.peer_poll_time, null)
            peer_poll_time_unit              = try(ha_pair.peer_poll_time_unit, null)
            state_link_interface_id          = try(local.map_interface_names["${ha_pair.primary_device}:${ha_pair.state_link_interface_name}"].id, null)
            state_link_interface_name        = try(ha_pair.state_link_interface_name, null)
            state_link_interface_type        = try(local.map_interface_names["${ha_pair.primary_device}:${ha_pair.state_link_interface_name}"].type, null)
            state_link_logical_name          = try(ha_pair.state_link_logical_name, null)
            state_link_primary_ip            = try(ha_pair.state_link_primary_ip, null)
            state_link_secondary_ip          = try(ha_pair.state_link_secondary_ip, null)
            state_link_netmask               = try(ha_pair.state_link_netmask, null)
            state_link_use_ipv6              = try(ha_pair.state_link_use_ipv6, null)

            domain_name = domain.name

          }
        ] if !contains(try(keys(local.data_device_ha_pair), []), ha_pair.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_device_ha_pair), []), item.name) #The device name is unique across the different domains.
  }

}
resource "fmc_device_ha_pair" "module" {
  for_each = local.resource_device_ha_pair

  # Mandatory
  name                = each.value.name
  primary_device_id   = each.value.primary_device_id
  secondary_device_id = each.value.secondary_device_id

  ha_link_interface_id      = each.value.ha_link_interface_id
  ha_link_interface_name    = each.value.ha_link_interface_name
  ha_link_interface_type    = each.value.ha_link_interface_type
  ha_link_logical_name      = each.value.ha_link_logical_name
  ha_link_primary_ip        = each.value.ha_link_primary_ip
  ha_link_secondary_ip      = each.value.ha_link_secondary_ip
  ha_link_netmask           = each.value.ha_link_netmask
  state_link_use_same_as_ha = each.value.state_link_use_same_as_ha

  # Optional
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

  domain = each.value.domain_name

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
  ]
}
##########################################################
###    DEVICE HA Pair - Monitored interfaces - no data source used, no use case 
##########################################################

locals {

  resource_device_ha_pair_monitored_interface = {
    for item in flatten([
      for domain in local.domains : [
        for ha_pair in try(domain.devices.ha_pairs, []) : [
          for monitored_interface in try(ha_pair.interfaces, []) : [
            {
              device_name          = ha_pair.name
              ha_pair_id           = try(data.fmc_device_ha_pair.module[ha_pair.name].id, fmc_device_ha_pair.module[ha_pair.name].id)
              logical_name         = monitored_interface.interface_logical_name
              ipv4_standby_address = try(monitored_interface.ipv4_standby_address, null)
              monitor_interface    = try(monitored_interface.monitor_interface, null)
              ipv6_addresses = [for ipv6_address in try(monitored_interface.ipv6_addresses, {}) : {
                active_address  = ipv6_address.active_address
                standby_address = ipv6_address.standby_address
              }]
              domain_name = domain.name
            }
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.logical_name}" => item if contains(keys(item), "logical_name") #The device name is unique across the different domains.
  }

}
#
# Ceavats - IPv6 standby address cannot be removed via API/Terraform/Module
#

resource "fmc_device_ha_pair_monitoring" "module" {
  for_each = local.resource_device_ha_pair_monitored_interface

  # Mandatory
  logical_name = each.value.logical_name
  ha_pair_id   = each.value.ha_pair_id

  #Optional
  monitor_interface    = each.value.monitor_interface
  ipv4_standby_address = each.value.ipv4_standby_address
  #ipv6_addresses        = each.value.ipv6_addresses

  depends_on = [
    data.fmc_device_ha_pair.module,
    fmc_device_ha_pair.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
  ]
}

##########################################################
###    DEVICE Cluster
##########################################################

locals {

  resource_device_cluster = {
    for item in flatten([
      for domain in local.domains : [
        for cluster in try(domain.devices.clusters, []) : [
          {
            # Mandatory
            name = cluster.name

            cluster_key                   = cluster.cluster_key
            control_node_device_id        = local.map_devices[cluster.control_node_device].id
            control_node_priority         = cluster.control_node_priority
            control_node_interface_id     = local.map_interface_names["${cluster.control_node_device}:${cluster.control_node_interface_name}"].id
            control_node_interface_name   = cluster.control_node_interface_name
            control_node_interface_type   = local.map_interface_names["${cluster.control_node_device}:${cluster.control_node_interface_name}"].type
            control_node_ccl_ipv4_address = cluster.control_node_ccl_ipv4_address
            control_node_ccl_prefix       = cluster.control_node_ccl_prefix

            # Optional
            control_node_vni_prefix = try(cluster.control_node_vni_prefix, null)
            data_devices = [for data_device in try(cluster.data_devices, []) : {
              data_node_ccl_ipv4_address = data_device.data_node_ccl_ipv4_address
              data_node_device_id        = local.map_devices[data_device.data_node_device].id
              data_node_priority         = data_device.data_node_priority
            }]

            domain_name = domain.name

          }
        ] if !contains(try(keys(local.data_device_cluster), []), cluster.name)
      ]
    ]) : item.name => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_device_cluster), []), item.name) #The device name is unique across the different domains.
  }

}
resource "fmc_device_cluster" "module" {
  for_each = local.resource_device_cluster

  # Mandatory
  name                          = each.value.name
  cluster_key                   = each.value.name
  control_node_device_id        = each.value.control_node_device_id
  control_node_priority         = each.value.control_node_priority
  control_node_interface_id     = each.value.control_node_interface_id
  control_node_interface_name   = each.value.control_node_interface_name
  control_node_interface_type   = each.value.control_node_interface_type
  control_node_ccl_ipv4_address = each.value.control_node_ccl_ipv4_address
  control_node_ccl_prefix       = each.value.control_node_ccl_prefix
  # Optional
  control_node_vni_prefix = each.value.control_node_vni_prefix
  data_devices            = each.value.data_devices

  domain = each.value.domain_name

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
  ]
}

##########################################################
###    Physical Interface
##########################################################

locals {

  resource_physical_interface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for physical_interface in try(vrf.physical_interfaces, []) : [
              {
                vrf_name    = vrf.name
                device_name = device.name

                name      = physical_interface.name
                device_id = local.map_devices[device.name].id
                mode      = try(physical_interface.mode, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.mode, null)

                active_mac_address             = try(physical_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.active_mac_address, null)
                allow_full_fragment_reassembly = try(physical_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.allow_full_fragment_reassembly, null)
                arp_table_entries = [for arp_table_entry in try(physical_interface.arp_table_entries, []) : {
                  enable_alias = try(arp_table_entry.enable_alias, null)
                  ip_address   = try(arp_table_entry.ip_address, null)
                  mac_address  = try(arp_table_entry.mac_address, null)
                }]
                auto_negotiation                      = try(physical_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.enabled, null)
                description                           = try(physical_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.description, null)
                domain_name                           = domain.name
                duplex                                = try(physical_interface.duplex, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.duplex, null)
                enable_anti_spoofing                  = try(physical_interface.enable_anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.enable_anti_spoofing, null)
                enable_sgt_propagate                  = try(physical_interface.enable_sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.enable_sgt_propagate, null)
                enabled                               = try(physical_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.enabled, null)
                fec_mode                              = try(physical_interface.fec_mode, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.fec_mode, null)
                flow_control_send                     = try(physical_interface.flow_control_send, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.flow_control_send, false) ? "ON" : null
                ip_based_monitoring                   = try(physical_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring, null)
                ip_based_monitoring_next_hop          = try(physical_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring_next_hop, null)
                ip_based_monitoring_type              = try(physical_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ip_based_monitoring_type, null)
                ipv4_address_pool_id                  = try(local.map_ipv4_address_pools[physical_interface.ipv4_address_pool].id, null)
                ipv4_dhcp_obtain_route                = try(physical_interface.ipv4_dhcp_obtain_route, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_dhcp_obtain_route, null)
                ipv4_dhcp_route_metric                = try(physical_interface.ipv4_dhcp_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_dhcp_route_metric, null)
                ipv4_pppoe_authentication             = try(physical_interface.ipv4_pppoe_authentication, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_authentication, null)
                ipv4_pppoe_password                   = try(physical_interface.ipv4_pppoe_password, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_password, null)
                ipv4_pppoe_route_metric               = try(physical_interface.ipv4_pppoe_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_route_metric, null)
                ipv4_pppoe_route_settings             = try(physical_interface.ipv4_pppoe_route_settings, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_route_settings, null)
                ipv4_pppoe_store_credentials_in_flash = try(physical_interface.ipv4_pppoe_store_credentials_in_flash, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_store_credentials_in_flash, null)
                ipv4_pppoe_user                       = try(physical_interface.ipv4_pppoe_user, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_user, null)
                ipv4_pppoe_vpdn_group_name            = try(physical_interface.ipv4_pppoe_vpdn_group_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_pppoe_vpdn_group_name, null)
                ipv4_static_address                   = try(physical_interface.ipv4_static_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_static_address, null)
                ipv4_static_netmask                   = try(physical_interface.ipv4_static_netmask, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv4_static_netmask, null)
                ipv6_address_pool_id                  = try(local.map_ipv6_address_pools[physical_interface.ipv6_address_pool].id, null)
                ipv6_addresses = [for ipv6_address in try(physical_interface.ipv6_addresses, []) : {
                  address     = try(ipv6_address.address, null)
                  enforce_eui = try(ipv6_address.enforce_eui, null)
                  prefix      = try(ipv6_address.prefix, null)
                }]
                ipv6_dad_attempts                  = try(physical_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dad_attempts, null)
                ipv6_default_route_by_dhcp         = try(physical_interface.ipv6_default_route_by_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_default_route_by_dhcp, null)
                ipv6_dhcp                          = try(physical_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp, null)
                ipv6_dhcp_client_pd_hint_prefixes  = try(physical_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
                ipv6_dhcp_client_pd_prefix_name    = try(physical_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
                ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[physical_interface.ipv6_dhcp_pool].id, null)
                ipv6_enable                        = try(physical_interface.ipv6_enable, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable, null)
                ipv6_enable_auto_config            = try(physical_interface.ipv6_enable_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable_auto_config, null)
                ipv6_enable_dad                    = try(physical_interface.ipv6_enable_dad, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable_dad, null)
                ipv6_enable_dhcp_address_config    = try(physical_interface.ipv6_enable_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable_dhcp_address_config, null)
                ipv6_enable_dhcp_nonaddress_config = try(physical_interface.ipv6_enable_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable_dhcp_nonaddress_config, null)
                ipv6_enable_ra                     = try(physical_interface.ipv6_enable_ra, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enable_ra, null)
                ipv6_enforce_eui                   = try(physical_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_enforce_eui, null)
                ipv6_link_local_address            = try(physical_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_link_local_address, null)
                ipv6_ns_interval                   = try(physical_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ns_interval, null)
                ipv6_prefixes = [for ipv6_prefix in try(physical_interface.ipv6_prefixes, []) : {
                  address     = try(ipv6_prefix.address, null)
                  enforce_eui = try(ipv6_prefix.enforce_eui, null)
                  default     = try(ipv6_prefix.default, null)
                }]
                ipv6_ra_interval    = try(physical_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ra_interval, null)
                ipv6_ra_life_time   = try(physical_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_ra_life_time, null)
                ipv6_reachable_time = try(physical_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.ipv6_reachable_time, null)
                lldp_receive        = try(physical_interface.lldp_receive, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.lldp_receive, null)
                lldp_transmit       = try(physical_interface.lldp_transmit, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.lldp_transmit, null)
                logical_name        = try(physical_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.logical_name, null)
                management_access   = try(physical_interface.management_access, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.management_access, null)
                management_access_network_objects = [for management_access_network_object in try(physical_interface.management_access_network_objects, []) : {
                  id   = try(local.map_network_objects[management_access_network_object].id, local.map_network_group_objects[management_access_network_object].id, null)
                  type = try(local.map_network_objects[management_access_network_object].type, local.map_network_group_objects[management_access_network_object].type, null)
                }]
                management_only                           = try(physical_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.management_only, null)
                mtu                                       = try(physical_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.mtu, null)
                nve_only                                  = try(physical_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.nve_only, null)
                override_default_fragment_setting_chain   = try(physical_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_chain, null)
                override_default_fragment_setting_size    = try(physical_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_size, null)
                override_default_fragment_setting_timeout = try(physical_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.override_default_fragment_setting_timeout, null)
                priority                                  = try(physical_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.priority, null)
                security_zone_id                          = try(local.map_security_zones[physical_interface.security_zone].id, null)
                speed                                     = try(physical_interface.speed, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.speed, null)
                standby_mac_address                       = try(physical_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.physical_interfaces.standby_mac_address, null)

              }
            ] if !contains(try(keys(local.data_physical_interface), []), "${device.name}:${physical_interface.name}")
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_physical_interface), []), "${item.device_name}:${item.name}") #The device name is unique across the different domains.
  }

}

resource "fmc_device_physical_interface" "module" {
  for_each = local.resource_physical_interface

  # Mandatory
  name      = each.value.name
  device_id = each.value.device_id
  mode      = each.value.mode

  #Optional
  active_mac_address                        = each.value.active_mac_address
  allow_full_fragment_reassembly            = each.value.allow_full_fragment_reassembly
  arp_table_entries                         = each.value.arp_table_entries
  auto_negotiation                          = each.value.auto_negotiation
  description                               = each.value.description
  domain                                    = each.value.domain_name
  duplex                                    = each.value.duplex
  enable_anti_spoofing                      = each.value.enable_anti_spoofing
  enable_sgt_propagate                      = each.value.enable_sgt_propagate
  enabled                                   = each.value.enabled
  fec_mode                                  = each.value.fec_mode
  flow_control_send                         = each.value.flow_control_send
  ip_based_monitoring                       = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop              = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type                  = each.value.ip_based_monitoring_type
  ipv4_dhcp_obtain_route                    = each.value.ipv4_dhcp_obtain_route
  ipv4_dhcp_route_metric                    = each.value.ipv4_dhcp_route_metric
  ipv4_pppoe_authentication                 = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                       = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric                   = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings                 = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash     = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                           = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name                = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                       = each.value.ipv4_static_address
  ipv4_static_netmask                       = each.value.ipv4_static_netmask
  ipv6_addresses                            = each.value.ipv6_addresses
  ipv6_dad_attempts                         = each.value.ipv6_dad_attempts
  ipv6_default_route_by_dhcp                = each.value.ipv6_default_route_by_dhcp
  ipv6_dhcp                                 = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes         = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name           = each.value.ipv6_dhcp_client_pd_prefix_name
  ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6_enable                               = each.value.ipv6_enable
  ipv6_enable_auto_config                   = each.value.ipv6_enable_auto_config
  ipv6_enable_dad                           = each.value.ipv6_enable_dad
  ipv6_enable_dhcp_address_config           = each.value.ipv6_enable_dhcp_address_config
  ipv6_enable_dhcp_nonaddress_config        = each.value.ipv6_enable_dhcp_nonaddress_config
  ipv6_enable_ra                            = each.value.ipv6_enable_ra
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

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
  ]
}
##########################################################
###    Ether-Channel Interface
##########################################################

locals {

  resource_etherchannel_interface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : [
              {
                vrf_name    = vrf.name
                device_name = device.name

                name             = etherchannel_interface.name
                ether_channel_id = split("Port-channel", etherchannel_interface.name)[length(split("Port-channel", etherchannel_interface.name)) - 1]
                device_id        = local.map_devices[device.name].id
                mode             = try(etherchannel_interface.mode, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.mode, null)

                active_mac_address             = try(etherchannel_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.active_mac_address, null)
                allow_full_fragment_reassembly = try(etherchannel_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.allow_full_fragment_reassembly, null)
                arp_table_entries = [for arp_table_entry in try(etherchannel_interface.arp_table_entries, []) : {
                  enable_alias = try(arp_table_entry.enable_alias, null)
                  ip_address   = try(arp_table_entry.ip_address, null)
                  mac_address  = try(arp_table_entry.mac_address, null)
                }]
                auto_negotiation                      = try(etherchannel_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enabled, null)
                description                           = try(etherchannel_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.description, null)
                domain_name                           = domain.name
                duplex                                = try(etherchannel_interface.duplex, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.duplex, null)
                enable_anti_spoofing                  = try(etherchannel_interface.enable_anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enable_anti_spoofing, null)
                enable_sgt_propagate                  = try(etherchannel_interface.enable_sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enable_sgt_propagate, null)
                enabled                               = try(etherchannel_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enabled, null)
                fec_mode                              = try(etherchannel_interface.fec_mode, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.fec_mode, null)
                flow_control_send                     = try(etherchannel_interface.flow_control_send, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.flow_control_send, null)
                ip_based_monitoring                   = try(etherchannel_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring, null)
                ip_based_monitoring_next_hop          = try(etherchannel_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_next_hop, null)
                ip_based_monitoring_type              = try(etherchannel_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_type, null)
                ipv4_dhcp_obtain_route                = try(etherchannel_interface.ipv4_dhcp_obtain_route, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_obtain_route, null)
                ipv4_dhcp_route_metric                = try(etherchannel_interface.ipv4_dhcp_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_route_metric, null)
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
                  address     = try(ipv6_address.address, null)
                  enforce_eui = try(ipv6_address.enforce_eui, null)
                  prefix      = try(ipv6_address.prefix, null)
                }]
                ipv6_dad_attempts                  = try(etherchannel_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dad_attempts, null)
                ipv6_default_route_by_dhcp         = try(etherchannel_interface.ipv6_default_route_by_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_default_route_by_dhcp, null)
                ipv6_dhcp                          = try(etherchannel_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp, null)
                ipv6_dhcp_client_pd_hint_prefixes  = try(etherchannel_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
                ipv6_dhcp_client_pd_prefix_name    = try(etherchannel_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
                ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[etherchannel_interface.ipv6_dhcp_pool].id, null)
                ipv6_enable                        = try(etherchannel_interface.ipv6_enable, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable, null)
                ipv6_enable_auto_config            = try(etherchannel_interface.ipv6_enable_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_auto_config, null)
                ipv6_enable_dad                    = try(etherchannel_interface.ipv6_enable_dad, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dad, null)
                ipv6_enable_dhcp_address_config    = try(etherchannel_interface.ipv6_enable_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dhcp_address_config, null)
                ipv6_enable_dhcp_nonaddress_config = try(etherchannel_interface.ipv6_enable_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dhcp_nonaddress_config, null)
                ipv6_enable_ra                     = try(etherchannel_interface.ipv6_enable_ra, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_ra, null)
                ipv6_enforce_eui                   = try(etherchannel_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enforce_eui, null)
                ipv6_link_local_address            = try(etherchannel_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_link_local_address, null)
                ipv6_ns_interval                   = try(etherchannel_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ns_interval, null)
                ipv6_prefixes = [for ipv6_prefix in try(etherchannel_interface.ipv6_prefixes, []) : {
                  address     = try(ipv6_prefix.address, null)
                  enforce_eui = try(ipv6_prefix.enforce_eui, null)
                  default     = try(ipv6_prefix.default, null)
                }]
                ipv6_ra_interval    = try(etherchannel_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_interval, null)
                ipv6_ra_life_time   = try(etherchannel_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_life_time, null)
                ipv6_reachable_time = try(etherchannel_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_reachable_time, null)
                lldp_receive        = try(etherchannel_interface.lldp_receive, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.lldp_receive, null)
                lldp_transmit       = try(etherchannel_interface.lldp_transmit, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.lldp_transmit, null)
                logical_name        = try(etherchannel_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.logical_name, null)
                management_access   = try(etherchannel_interface.management_access, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.management_access, null)
                management_access_network_objects = [for management_access_network_object in try(etherchannel_interface.management_access_network_objects, []) : {
                  id   = try(local.map_network_objects[management_access_network_object].id, local.map_network_group_objects[management_access_network_object].id, null)
                  type = try(local.map_network_objects[management_access_network_object].type, local.map_network_group_objects[management_access_network_object].type, null)
                }]
                management_only                           = try(etherchannel_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.management_only, null)
                mtu                                       = try(etherchannel_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.mtu, null)
                nve_only                                  = try(etherchannel_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.nve_only, null)
                override_default_fragment_setting_chain   = try(etherchannel_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_chain, null)
                override_default_fragment_setting_size    = try(etherchannel_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_size, null)
                override_default_fragment_setting_timeout = try(etherchannel_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_timeout, null)
                priority                                  = try(etherchannel_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.priority, null)
                security_zone_id                          = try(local.map_security_zones[etherchannel_interface.security_zone].id, null)
                selected_interfaces = [for selected_interface in try(etherchannel_interface.selected_interfaces, []) : {
                  id   = try(fmc_device_physical_interface.module["${device.name}:${selected_interface}"].id, data.fmc_device_physical_interface.module["${device.name}:${selected_interface}"].id)
                  name = selected_interface
                  type = try(fmc_device_physical_interface.module["${device.name}:${selected_interface}"].type, data.fmc_device_physical_interface.module["${device.name}:${selected_interface}"].type)
                }]
                speed               = try(etherchannel_interface.speed, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.speed, null)
                standby_mac_address = try(etherchannel_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.standby_mac_address, null)

              }
            ] if !contains(try(keys(local.data_etherchannel_interface), []), "${device.name}:${etherchannel_interface.name}")
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_physical_interface), []), "${item.device_name}:${item.name}") #The device name is unique across the different domains.
  }

}

resource "fmc_device_etherchannel_interface" "module" {
  for_each = local.resource_etherchannel_interface

  # Mandatory
  device_id        = each.value.device_id
  ether_channel_id = each.value.ether_channel_id
  mode             = each.value.mode

  #Optional
  active_mac_address                        = each.value.active_mac_address
  allow_full_fragment_reassembly            = each.value.allow_full_fragment_reassembly
  arp_table_entries                         = each.value.arp_table_entries
  auto_negotiation                          = each.value.auto_negotiation
  description                               = each.value.description
  domain                                    = each.value.domain_name
  duplex                                    = each.value.duplex
  enable_anti_spoofing                      = each.value.enable_anti_spoofing
  enable_sgt_propagate                      = each.value.enable_sgt_propagate
  enabled                                   = each.value.enabled
  fec_mode                                  = each.value.fec_mode
  flow_control_send                         = each.value.flow_control_send
  ip_based_monitoring                       = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop              = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type                  = each.value.ip_based_monitoring_type
  ipv4_dhcp_obtain_route                    = each.value.ipv4_dhcp_obtain_route
  ipv4_dhcp_route_metric                    = each.value.ipv4_dhcp_route_metric
  ipv4_pppoe_authentication                 = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                       = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric                   = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings                 = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash     = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                           = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name                = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                       = each.value.ipv4_static_address
  ipv4_static_netmask                       = each.value.ipv4_static_netmask
  ipv6_addresses                            = each.value.ipv6_addresses
  ipv6_dad_attempts                         = each.value.ipv6_dad_attempts
  ipv6_default_route_by_dhcp                = each.value.ipv6_default_route_by_dhcp
  ipv6_dhcp                                 = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes         = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name           = each.value.ipv6_dhcp_client_pd_prefix_name
  ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6_enable                               = each.value.ipv6_enable
  ipv6_enable_auto_config                   = each.value.ipv6_enable_auto_config
  ipv6_enable_dad                           = each.value.ipv6_enable_dad
  ipv6_enable_dhcp_address_config           = each.value.ipv6_enable_dhcp_address_config
  ipv6_enable_dhcp_nonaddress_config        = each.value.ipv6_enable_dhcp_nonaddress_config
  ipv6_enable_ra                            = each.value.ipv6_enable_ra
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

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
  ]

}

##########################################################
###    Sub-Interface
##########################################################

locals {

  resource_sub_interface = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for sub_interface in try(vrf.sub_interfaces, []) : [
              {
                vrf_name    = vrf.name
                device_name = device.name

                name             = sub_interface.name
                interface_name   = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 2]
                sub_interface_id = split(".", sub_interface.name)[length(split(".", sub_interface.name)) - 1]
                device_id        = local.map_devices[device.name].id
                vlan_id          = sub_interface.vlan

                active_mac_address             = try(sub_interface.active_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.active_mac_address, null)
                allow_full_fragment_reassembly = try(sub_interface.allow_full_fragment_reassembly, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.allow_full_fragment_reassembly, null)
                arp_table_entries = [for arp_table_entry in try(sub_interface.arp_table_entries, []) : {
                  enable_alias = try(arp_table_entry.enable_alias, null)
                  ip_address   = try(arp_table_entry.ip_address, null)
                  mac_address  = try(arp_table_entry.mac_address, null)
                }]
                description                           = try(sub_interface.description, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.description, null)
                domain_name                           = domain.name
                enable_anti_spoofing                  = try(sub_interface.enable_anti_spoofing, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enable_anti_spoofing, null)
                enable_sgt_propagate                  = try(sub_interface.enable_sgt_propagate, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enable_sgt_propagate, null)
                enabled                               = try(sub_interface.enabled, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.enabled, null)
                ip_based_monitoring                   = try(sub_interface.ip_based_monitoring, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring, null)
                ip_based_monitoring_next_hop          = try(sub_interface.ip_based_monitoring_next_hop, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_next_hop, null)
                ip_based_monitoring_type              = try(sub_interface.ip_based_monitoring_type, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ip_based_monitoring_type, null)
                ipv4_dhcp_obtain_route                = try(sub_interface.ipv4_dhcp_obtain_route, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_obtain_route, null)
                ipv4_dhcp_route_metric                = try(sub_interface.ipv4_dhcp_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_dhcp_route_metric, null)
                ipv4_pppoe_authentication             = try(sub_interface.ipv4_pppoe_authentication, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_authentication, null)
                ipv4_pppoe_password                   = try(sub_interface.ipv4_pppoe_password, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_password, null)
                ipv4_pppoe_route_metric               = try(sub_interface.ipv4_pppoe_route_metric, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_route_metric, null)
                ipv4_pppoe_route_settings             = try(sub_interface.ipv4_pppoe_route_settings, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_route_settings, null)
                ipv4_pppoe_store_credentials_in_flash = try(sub_interface.ipv4_pppoe_store_credentials_in_flash, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_store_credentials_in_flash, null)
                ipv4_pppoe_user                       = try(sub_interface.ipv4_pppoe_user, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_user, null)
                ipv4_pppoe_vpdn_group_name            = try(sub_interface.ipv4_pppoe_vpdn_group_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_pppoe_vpdn_group_name, null)
                ipv4_static_address                   = try(sub_interface.ipv4_static_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_static_address, null)
                ipv4_static_netmask                   = try(sub_interface.ipv4_static_netmask, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv4_static_netmask, null)
                ipv6_addresses = [for ipv6_address in try(sub_interface.ipv6_addresses, []) : {
                  address     = try(ipv6_address.address, null)
                  enforce_eui = try(ipv6_address.enforce_eui, null)
                  prefix      = try(ipv6_address.prefix, null)
                }]
                ipv6_dad_attempts                  = try(sub_interface.ipv6_dad_attempts, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dad_attempts, null)
                ipv6_default_route_by_dhcp         = try(sub_interface.ipv6_default_route_by_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_default_route_by_dhcp, null)
                ipv6_dhcp                          = try(sub_interface.ipv6_dhcp, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp, null)
                ipv6_dhcp_client_pd_hint_prefixes  = try(sub_interface.ipv6_dhcp_client_pd_hint_prefixes, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_hint_prefixes, null)
                ipv6_dhcp_client_pd_prefix_name    = try(sub_interface.ipv6_dhcp_client_pd_prefix_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_dhcp_client_pd_prefix_name, null)
                ipv6_dhcp_pool_id                  = try(local.map_ipv6_dhcp_pools[sub_interface.ipv6_dhcp_pool].id, null)
                ipv6_enable                        = try(sub_interface.ipv6_enable, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable, null)
                ipv6_enable_auto_config            = try(sub_interface.ipv6_enable_auto_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_auto_config, null)
                ipv6_enable_dad                    = try(sub_interface.ipv6_enable_dad, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dad, null)
                ipv6_enable_dhcp_address_config    = try(sub_interface.ipv6_enable_dhcp_address_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dhcp_address_config, null)
                ipv6_enable_dhcp_nonaddress_config = try(sub_interface.ipv6_enable_dhcp_nonaddress_config, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_dhcp_nonaddress_config, null)
                ipv6_enable_ra                     = try(sub_interface.ipv6_enable_ra, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enable_ra, null)
                ipv6_enforce_eui                   = try(sub_interface.ipv6_enforce_eui, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_enforce_eui, null)
                ipv6_link_local_address            = try(sub_interface.ipv6_link_local_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_link_local_address, null)
                ipv6_ns_interval                   = try(sub_interface.ipv6_ns_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ns_interval, null)
                ipv6_prefixes = [for ipv6_prefix in try(sub_interface.ipv6_prefixes, []) : {
                  address     = try(ipv6_prefix.address, null)
                  enforce_eui = try(ipv6_prefix.enforce_eui, null)
                  default     = try(ipv6_prefix.default, null)
                }]
                ipv6_ra_interval                          = try(sub_interface.ipv6_ra_interval, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_interval, null)
                ipv6_ra_life_time                         = try(sub_interface.ipv6_ra_life_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_ra_life_time, null)
                ipv6_reachable_time                       = try(sub_interface.ipv6_reachable_time, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.ipv6_reachable_time, null)
                logical_name                              = try(sub_interface.logical_name, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.logical_name, null)
                management_only                           = try(sub_interface.management_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.management_only, null)
                mtu                                       = try(sub_interface.mtu, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.mtu, null)
                nve_only                                  = try(sub_interface.nve_only, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.nve_only, null)
                override_default_fragment_setting_chain   = try(sub_interface.override_default_fragment_setting_chain, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_chain, null)
                override_default_fragment_setting_size    = try(sub_interface.override_default_fragment_setting_size, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_size, null)
                override_default_fragment_setting_timeout = try(sub_interface.override_default_fragment_setting_timeout, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.override_default_fragment_setting_timeout, null)
                priority                                  = try(sub_interface.priority, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.priority, null)
                security_zone_id                          = try(local.map_security_zones[sub_interface.security_zone].id, null)
                standby_mac_address                       = try(sub_interface.standby_mac_address, local.defaults.fmc.domains.devices.devices.vrfs.etherchannel_interfaces.standby_mac_address, null)

              }
            ] if !contains(try(keys(local.data_sub_interface), []), "${device.name}:${sub_interface.name}")
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #&& !contains(try(keys(local.data_sub_interface), []), "${item.device_name}:${item.name}") #The device name is unique across the different domains.
  }

}

resource "fmc_device_subinterface" "module" {
  for_each = local.resource_sub_interface

  # Mandatory
  device_id        = each.value.device_id
  interface_name   = each.value.interface_name
  sub_interface_id = each.value.sub_interface_id
  vlan_id          = each.value.vlan_id

  # Optional
  active_mac_address                        = each.value.active_mac_address
  allow_full_fragment_reassembly            = each.value.allow_full_fragment_reassembly
  arp_table_entries                         = each.value.arp_table_entries
  description                               = each.value.description
  domain                                    = each.value.domain_name
  enable_anti_spoofing                      = each.value.enable_anti_spoofing
  enable_sgt_propagate                      = each.value.enable_sgt_propagate
  enabled                                   = each.value.enabled
  ip_based_monitoring                       = each.value.ip_based_monitoring
  ip_based_monitoring_next_hop              = each.value.ip_based_monitoring_next_hop
  ip_based_monitoring_type                  = each.value.ip_based_monitoring_type
  ipv4_dhcp_obtain_route                    = each.value.ipv4_dhcp_obtain_route
  ipv4_dhcp_route_metric                    = each.value.ipv4_dhcp_route_metric
  ipv4_pppoe_authentication                 = each.value.ipv4_pppoe_authentication
  ipv4_pppoe_password                       = each.value.ipv4_pppoe_password
  ipv4_pppoe_route_metric                   = each.value.ipv4_pppoe_route_metric
  ipv4_pppoe_route_settings                 = each.value.ipv4_pppoe_route_settings
  ipv4_pppoe_store_credentials_in_flash     = each.value.ipv4_pppoe_store_credentials_in_flash
  ipv4_pppoe_user                           = each.value.ipv4_pppoe_user
  ipv4_pppoe_vpdn_group_name                = each.value.ipv4_pppoe_vpdn_group_name
  ipv4_static_address                       = each.value.ipv4_static_address
  ipv4_static_netmask                       = each.value.ipv4_static_netmask
  ipv6_addresses                            = each.value.ipv6_addresses
  ipv6_dad_attempts                         = each.value.ipv6_dad_attempts
  ipv6_default_route_by_dhcp                = each.value.ipv6_default_route_by_dhcp
  ipv6_dhcp                                 = each.value.ipv6_dhcp
  ipv6_dhcp_client_pd_hint_prefixes         = each.value.ipv6_dhcp_client_pd_hint_prefixes
  ipv6_dhcp_client_pd_prefix_name           = each.value.ipv6_dhcp_client_pd_prefix_name
  ipv6_dhcp_pool_id                         = each.value.ipv6_dhcp_pool_id
  ipv6_enable                               = each.value.ipv6_enable
  ipv6_enable_auto_config                   = each.value.ipv6_enable_auto_config
  ipv6_enable_dad                           = each.value.ipv6_enable_dad
  ipv6_enable_dhcp_address_config           = each.value.ipv6_enable_dhcp_address_config
  ipv6_enable_dhcp_nonaddress_config        = each.value.ipv6_enable_dhcp_nonaddress_config
  ipv6_enable_ra                            = each.value.ipv6_enable_ra
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
    fmc_device.module,
    data.fmc_device.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
  ]

}

##########################################################
###    Platform Settings
##########################################################
locals {
  resource_ftd_platform_settings = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            name        = ftd_platform_setting.name
            domain      = domain.name
            description = try(ftd_platform_setting.description, local.defaults.fmc.domains.devices.ftd_platform_settings.description, null)
          }
        ] if !contains(try(keys(local.data_ftd_platform_settings), []), ftd_platform_setting.name)
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }
}

resource "fmc_ftd_platform_settings" "module" {
  for_each = local.resource_ftd_platform_settings

  name        = each.value.name
  domain      = each.value.domain
  description = each.value.description
}

locals {
  resource_ftd_platform_settings_banner = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            text = split("\n", trimsuffix(ftd_platform_setting.banner.text, "\n"))
          }
        ] if try(ftd_platform_setting.banner, null) != null
      ]
    ]) : "${item.platform_settings_name}:banner" => item
  }
}

resource "fmc_ftd_platform_settings_banner" "module" {
  for_each = local.resource_ftd_platform_settings_banner

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  text = each.value.text
}

locals {
  resource_ftd_platform_settings_http_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            server_enabled = try(ftd_platform_setting.http_access.server_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.http_access.server_enabled, null)
            server_port    = try(ftd_platform_setting.http_access.server_port, local.defaults.fmc.domains.devices.ftd_platform_settings.http_access.server_port, null)
            configurations = [for configuration in try(ftd_platform_setting.http_access.configurations, []) : {
              source_network_object_id = local.map_network_objects[configuration.source_network_object].id
              interface_literals       = try(configuration.interface_literals, null)
              interface_objects = [for interface_object in try(configuration.interface_objects, []) : {
                id   = local.map_security_zones[interface_object].id
                type = local.map_security_zones[interface_object].type
                name = interface_object
              }]
            }]
          }
        ] if try(ftd_platform_setting.http_access, null) != null
      ]
    ]) : "${item.platform_settings_name}:http_access" => item
  }
}

resource "fmc_ftd_platform_settings_http_access" "module" {
  for_each = local.resource_ftd_platform_settings_http_access

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  server_enabled = each.value.server_enabled
  server_port    = each.value.server_port
  configurations = each.value.configurations
}

locals {
  resource_ftd_platform_settings_icmp_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            rate_limit = try(ftd_platform_setting.icmp_access.rate_limit, local.defaults.fmc.domains.devices.ftd_platform_settings.icmp_access.rate_limit, null)
            burst_size = try(ftd_platform_setting.icmp_access.burst_size, local.defaults.fmc.domains.devices.ftd_platform_settings.icmp_access.burst_size, null)
            configurations = [for configuration in try(ftd_platform_setting.icmp_access.configurations, []) : {
              action                   = configuration.action
              icmp_service_object_id   = local.map_services[configuration.icmp_service_object].id
              source_network_object_id = local.map_network_objects[configuration.source_network_object].id
              interface_literals       = try(configuration.interface_literals, null)
              interface_objects = [for interface_object in try(configuration.interface_objects, []) : {
                id   = local.map_security_zones[interface_object].id
                type = local.map_security_zones[interface_object].type
                name = interface_object
              }]
            }]
          }
        ] if try(ftd_platform_setting.icmp_access, null) != null
      ]
    ]) : "${item.platform_settings_name}:icmp_access" => item
  }
}

resource "fmc_ftd_platform_settings_icmp_access" "module" {
  for_each = local.resource_ftd_platform_settings_icmp_access

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  rate_limit     = each.value.rate_limit
  burst_size     = each.value.burst_size
  configurations = each.value.configurations
}

locals {
  resource_ftd_platform_settings_ssh_access = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for ssh_access in try(ftd_platform_setting.ssh_accesses, []) : [
            {
              platform_settings_name   = ftd_platform_setting.name
              ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
              domain                   = domain.name
              source_network_object    = ssh_access.source_network_object

              source_network_object_id = local.map_network_objects[ssh_access.source_network_object].id
              interface_literals       = try(ssh_access.interface_literals, null)
              interface_objects = [for interface_object in try(ssh_access.interface_objects, []) : {
                id   = local.map_security_zones[interface_object].id
                type = local.map_security_zones[interface_object].type
                name = interface_object
              }]
          }]
        ]
      ]
    ]) : "${item.platform_settings_name}:ssh_access:${item.source_network_object}" => item
  }
}

resource "fmc_ftd_platform_settings_ssh_access" "module" {
  for_each = local.resource_ftd_platform_settings_ssh_access

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  source_network_object_id = each.value.source_network_object_id
  interface_literals       = each.value.interface_literals
  interface_objects        = each.value.interface_objects
}

locals {
  resource_ftd_platform_settings_snmp = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            server_enabled       = try(ftd_platform_setting.snmp.server_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.server_enabled, null)
            server_port          = try(ftd_platform_setting.snmp.server_port, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.server_port, null)
            read_community       = try(ftd_platform_setting.snmp.read_community, null)
            system_administrator = try(ftd_platform_setting.snmp.system_administrator, null)
            location             = try(ftd_platform_setting.snmp.location, null)
            management_hosts = [for management_host in try(ftd_platform_setting.snmp.management_hosts, []) : {
              network_object_id        = local.map_network_objects[management_host.network_object].id
              snmp_version             = management_host.snmp_version
              username                 = management_host.snmp_version == "SNMPv3" ? try(management_host.username, null) : null
              read_community           = management_host.snmp_version != "SNMPv3" ? try(management_host.read_community, null) : null
              poll                     = try(management_host.poll, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.poll, null)
              trap                     = try(management_host.trap, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.trap, null)
              trap_port                = try(management_host.trap_port, local.defaults.fmc.domains.devices.ftd_platform_settings.snmp.management_hosts.trap_port, null)
              use_management_interface = try(management_host.use_management_interface, null)
              interface_literals       = try(management_host.interface_literals, null)
              interface_objects = [for interface_object in try(management_host.interface_objects, []) : {
                id   = local.map_security_zones[interface_object].id
                type = local.map_security_zones[interface_object].type
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
          }
        ] if try(ftd_platform_setting.snmp, null) != null
      ]
    ]) : "${item.platform_settings_name}:snmp" => item
  }
}

resource "fmc_ftd_platform_settings_snmp" "module" {
  for_each = local.resource_ftd_platform_settings_snmp

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

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

locals {
  resource_ftd_platform_settings_syslog_logging_setup = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            logging_enabled                          = try(ftd_platform_setting.syslog.logging_setup.logging_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.logging_enabled, null)
            logging_on_failover_standby_unit_enabled = try(ftd_platform_setting.syslog.logging_setup.logging_on_failover_standby_unit_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.logging_on_failover_standby_unit_enabled, null)
            emblem_format                            = try(ftd_platform_setting.syslog.logging_setup.emblem_format, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.emblem_format, null)
            send_debug_messages_as_syslog            = try(ftd_platform_setting.syslog.logging_setup.send_debug_messages_as_syslog, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.send_debug_messages_as_syslog, null)
            internal_buffer_memory_size              = try(ftd_platform_setting.syslog.logging_setup.internal_buffer_memory_size, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.internal_buffer_memory_size, null)
            fmc_logging_mode                         = try(ftd_platform_setting.syslog.logging_setup.fmc_logging_mode, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_mode, null)
            fmc_logging_level                        = try(ftd_platform_setting.syslog.logging_setup.fmc_logging_mode, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_mode, null) != "OFF" ? try(ftd_platform_setting.syslog.logging_setup.fmc_logging_level, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.fmc_logging_level, null) : null
            ftp_server_host_id                       = try(local.map_network_objects[ftd_platform_setting.syslog.logging_setup.ftp_server_host].id, null)
            ftp_server_username                      = try(ftd_platform_setting.syslog.logging_setup.ftp_server_username, null)
            ftp_server_path                          = try(ftd_platform_setting.syslog.logging_setup.ftp_server_path, null)
            ftp_server_password                      = try(ftd_platform_setting.syslog.logging_setup.ftp_server_password, null)
            flash_enabled                            = try(ftd_platform_setting.syslog.logging_setup.flash_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_enabled, null)
            flash_maximum_space                      = try(ftd_platform_setting.syslog.logging_setup.flash_maximum_space, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_maximum_space, null)
            flash_minimum_free_space                 = try(ftd_platform_setting.syslog.logging_setup.flash_minimum_free_space, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.logging_setup.flash_minimum_free_space, null)

          }
        ] if try(ftd_platform_setting.syslog.logging_setup, null) != null
      ]
    ]) : "${item.platform_settings_name}:syslog:logging_setup" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_logging_setup" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_logging_setup

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

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

locals {
  resource_ftd_platform_settings_syslog_logging_destinations = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for logging_destination in try(ftd_platform_setting.syslog.logging_destinations, []) : [
            {
              platform_settings_name   = ftd_platform_setting.name
              ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
              domain                   = domain.name

              logging_destination                = logging_destination.destination
              global_event_class_filter_criteria = logging_destination.global_event_class_filter_criteria
              global_event_class_filter_value    = logging_destination.global_event_class_filter_criteria != "DISABLE" ? try(logging_destination.global_event_class_filter_value, null) : null
              event_class_filters = [for class_filter in try(logging_destination.event_class_filters, []) : {
                class    = class_filter.class
                severity = class_filter.severity
              }]
          }]
        ]
      ]
    ]) : "${item.platform_settings_name}:logging_destinations:${item.logging_destination}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_logging_destination" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_logging_destinations

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  logging_destination                = each.value.logging_destination
  global_event_class_filter_criteria = each.value.global_event_class_filter_criteria
  global_event_class_filter_value    = each.value.global_event_class_filter_value
  event_class_filters                = each.value.event_class_filters
}

locals {
  resource_ftd_platform_settings_syslog_email_setup = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            source_email_address = ftd_platform_setting.syslog.email_setup.source_email_address
            destinations = [for destination in try(ftd_platform_setting.syslog.email_setup.destinations, []) : {
              email_addresses = destination.email_addresses
              logging_level   = destination.logging_level
            }]
          }
        ] if try(ftd_platform_setting.syslog.email_setup, null) != null
      ]
    ]) : "${item.platform_settings_name}:syslog:email_setup" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_email_setup" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_email_setup

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  source_email_address = each.value.source_email_address
  destinations         = each.value.destinations
}

locals {
  resource_ftd_platform_settings_syslog_event_lists = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for event_list in try(ftd_platform_setting.syslog.event_lists, []) : [
            {
              platform_settings_name   = ftd_platform_setting.name
              ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
              domain                   = domain.name

              name = event_list.name
              event_classes = [for event_class in try(event_list.event_classes, []) : {
                class    = event_class.class
                severity = event_class.severity
              }]
              message_ids = try(event_list.message_ids, null)
          }]
        ]
      ]
    ]) : "${item.platform_settings_name}:syslog:event_list:${item.name}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_event_list" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_event_lists

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  name          = each.value.name
  event_classes = each.value.event_classes
  message_ids   = each.value.message_ids
}

locals {
  resource_ftd_platform_settings_syslog_rate_limits = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for rate_limit in try(ftd_platform_setting.syslog.rate_limits, []) : [
            {
              platform_settings_name   = ftd_platform_setting.name
              ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
              domain                   = domain.name

              rate_limit_type    = rate_limit.type
              rate_limit_value   = rate_limit.value
              number_of_messages = rate_limit.number_of_messages
              interval           = try(rate_limit.interval, null)
          }]
        ]
      ]
    ]) : "${item.platform_settings_name}:syslog:rate_limit:${item.rate_limit_value}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_rate_limit" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_rate_limits

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  rate_limit_type    = each.value.rate_limit_type
  rate_limit_value   = each.value.rate_limit_value
  number_of_messages = each.value.number_of_messages
  interval           = each.value.interval
}

locals {
  resource_ftd_platform_settings_syslog_settings = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            facility                          = try(ftd_platform_setting.syslog.settings.facility, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.facility, null)
            timestamp_format                  = try(ftd_platform_setting.syslog.settings.timestamp_format, null)
            device_id_source                  = try(ftd_platform_setting.syslog.settings.device_id_source, null)
            device_id_user_defined            = try(ftd_platform_setting.syslog.settings.device_id_source, null) == "USERDEFINEDID" ? ftd_platform_setting.syslog.settings.device_id_user_defined : null
            device_id_interface_id            = try(ftd_platform_setting.syslog.settings.device_id_source, null) == "INTERFACE" ? local.map_security_zones[ftd_platform_setting.syslog.settings.device_id_interface].id : null
            all_syslog_messages_enabled       = try(ftd_platform_setting.syslog.settings.all_syslog_messages_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.all_syslog_messages_enabled, null)
            all_syslog_messages_logging_level = try(ftd_platform_setting.syslog.settings.all_syslog_messages_enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.all_syslog_messages_enabled, null) == true ? ftd_platform_setting.syslog.settings.all_syslog_messages_logging_level : null
          }
        ] if try(ftd_platform_setting.syslog.settings, null) != null
      ]
    ]) : "${item.platform_settings_name}:syslog:settings" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_settings" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_settings

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  facility                          = each.value.facility
  timestamp_format                  = each.value.timestamp_format
  device_id_source                  = each.value.device_id_source
  device_id_user_defined            = each.value.device_id_user_defined
  device_id_interface_id            = each.value.device_id_interface_id
  all_syslog_messages_enabled       = each.value.all_syslog_messages_enabled
  all_syslog_messages_logging_level = each.value.all_syslog_messages_logging_level
}

locals {
  resource_ftd_platform_settings_syslog_settings_syslog_ids = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          for syslog_id in try(ftd_platform_setting.syslog.settings.syslog_ids, []) : [
            {
              platform_settings_name   = ftd_platform_setting.name
              ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
              domain                   = domain.name

              syslog_id     = syslog_id.syslog_id
              logging_level = try(syslog_id.logging_level, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.syslog_ids.logging_level, null)
              enabled       = try(syslog_id.enabled, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.settings.syslog_ids.enabled, null)
          }]
        ]
      ]
    ]) : "${item.platform_settings_name}:syslog:settings:syslog_id:${item.syslog_id}" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_settings_syslog_id" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_settings_syslog_ids

  ftd_platform_settings_id                 = each.value.ftd_platform_settings_id
  ftd_platform_settings_syslog_settings_id = each.value.ftd_platform_settings_id
  domain                                   = each.value.domain

  syslog_id     = each.value.syslog_id
  logging_level = each.value.logging_level
  enabled       = each.value.enabled
}

locals {
  resource_ftd_platform_settings_syslog_servers = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            allow_user_traffic_when_tcp_syslog_server_is_down = try(ftd_platform_setting.syslog.servers.allow_user_traffic_when_tcp_syslog_server_is_down, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.allow_user_traffic_when_tcp_syslog_server_is_down, null)
            message_queue_size                                = try(ftd_platform_setting.syslog.servers.message_queue_size, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.message_queue_size, null)
            servers = [for server in try(ftd_platform_setting.syslog.servers.servers, []) : {
              network_object_id        = local.map_network_objects[server.network_object].id
              protocol                 = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null)
              port                     = try(server.port, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.port, null)
              emblem_format            = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null) == "UDP" ? try(server.emblem_format, null) : null
              secure_syslog            = try(server.protocol, local.defaults.fmc.domains.devices.ftd_platform_settings.syslog.servers.servers.protocol, null) == "TCP" ? try(server.secure_syslog, null) : null
              use_management_interface = try(server.use_management_interface, null)
              interface_literals       = try(server.interface_literals, null)
              interface_objects = [for interface_object in try(server.interface_objects, []) : {
                id   = local.map_security_zones[interface_object].id
                type = local.map_security_zones[interface_object].type
                name = interface_object
              }]
            }]
          }
        ] if try(ftd_platform_setting.syslog.servers, null) != null
      ]
    ]) : "${item.platform_settings_name}:syslog:servers" => item
  }
}

resource "fmc_ftd_platform_settings_syslog_servers" "module" {
  for_each = local.resource_ftd_platform_settings_syslog_servers

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

  allow_user_traffic_when_tcp_syslog_server_is_down = each.value.allow_user_traffic_when_tcp_syslog_server_is_down
  message_queue_size                                = each.value.message_queue_size
  servers                                           = each.value.servers
}

locals {
  resource_ftd_platform_settings_time_synchronization = {
    for item in flatten([
      for domain in local.domains : [
        for ftd_platform_setting in try(domain.devices.ftd_platform_settings, []) : [
          {
            platform_settings_name   = ftd_platform_setting.name
            ftd_platform_settings_id = local.map_ftd_platform_settings[ftd_platform_setting.name].id
            domain                   = domain.name

            synchronization_mode = ftd_platform_setting.time_synchronization.mode
            ntp_servers          = ftd_platform_setting.time_synchronization.mode == "SYNC_VIA_NTP_SERVER" ? ftd_platform_setting.time_synchronization.ntp_servers : null
          }
        ] if try(ftd_platform_setting.time_synchronization, null) != null
      ]
    ]) : "${item.platform_settings_name}:time_synchronization" => item
  }
}

resource "fmc_ftd_platform_settings_time_synchronization" "module" {
  for_each = local.resource_ftd_platform_settings_time_synchronization

  ftd_platform_settings_id = each.value.ftd_platform_settings_id
  domain                   = each.value.domain

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
  map_devices = merge({
    for item in flatten([
      for device_key, device_value in local.resource_device : {
        name        = device_key
        id          = fmc_device.module[device_key].id
        type        = fmc_device.module[device_key].type
        domain_name = device_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for device_key, device_value in local.data_device : {
          name        = device_key
          id          = data.fmc_device.module[device_key].id
          type        = data.fmc_device.module[device_key].type
          domain_name = device_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

##########################################################
###    Create maps for combined set of _data and _resources vrf  
##########################################################

######
### map_vrfs
######
locals {
  map_vrfs = merge({
    for item in flatten([
      for vrf_key, vrf_value in local.resource_vrf : {
        name        = vrf_key
        id          = fmc_device_vrf.module[vrf_key].id
        domain_name = vrf_value.domain_name
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for vrf_key, vrf_value in local.data_vrf : {
          name        = vrf_key
          id          = data.fmc_device_vrf.module[vrf_key].id
          domain_name = vrf_value.domain_name
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

##########################################################
###    Create maps for combined set of _data and _resources physical_interfaces  
##########################################################

######
### map_physical_interfaces by logical_name as a key
######

locals {
  map_interface_names = merge({
    for item in flatten([
      for physical_interface_key, physical_interface_value in local.resource_physical_interface : {
        name         = physical_interface_value.name
        type         = fmc_device_physical_interface.module[physical_interface_key].type
        device_name  = physical_interface_value.device_name
        id           = fmc_device_physical_interface.module[physical_interface_key].id
        logical_name = physical_interface_value.logical_name
        domain_name  = physical_interface_value.domain_name
      }
    ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.data_physical_interface : {
          name         = physical_interface_value.name
          type         = data.fmc_device_physical_interface.module[physical_interface_key].type
          device_name  = physical_interface_value.device_name
          id           = data.fmc_device_physical_interface.module[physical_interface_key].id
          logical_name = try(data.fmc_device_physical_interface.module[physical_interface_key].logical_name, null)
          domain_name  = physical_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.resource_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          type         = fmc_device_etherchannel_interface.module[etherchannel_interface_key].type
          device_name  = etherchannel_interface_value.device_name
          id           = fmc_device_etherchannel_interface.module[etherchannel_interface_key].id
          logical_name = etherchannel_interface_value.logical_name
          domain_name  = etherchannel_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.data_etherchannel_interface : {
          name         = etherchannel_interface_value.name
          type         = data.fmc_device_etherchannel_interface.module[etherchannel_interface_key].type
          device_name  = etherchannel_interface_value.device_name
          id           = data.fmc_device_etherchannel_interface.module[etherchannel_interface_key].id
          logical_name = try(data.fmc_device_etherchannel_interface.module[etherchannel_interface_key].logical_name, null)
          domain_name  = etherchannel_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.resource_sub_interface : {
          name         = sub_interface_value.name
          type         = fmc_device_subinterface.module[sub_interface_key].type
          device_name  = sub_interface_value.device_name
          id           = fmc_device_subinterface.module[sub_interface_key].id
          logical_name = sub_interface_value.logical_name
          domain_name  = sub_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.data_sub_interface : {
          name         = sub_interface_value.name
          type         = data.fmc_device_subinterface.module[sub_interface_key].type
          device_name  = sub_interface_value.device_name
          id           = data.fmc_device_subinterface.module[sub_interface_key].id
          logical_name = try(data.fmc_device_subinterface.module[sub_interface_key].logical_name, null)
          domain_name  = sub_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.name}" => item if item.name != null
    },
  )
}
######
### map_interface_logical_names by logical_name as a key
######

locals {
  map_interface_logical_names = merge({
    for item in flatten([
      for physical_interface_key, physical_interface_value in local.resource_physical_interface : {
        name         = physical_interface_key
        device_name  = physical_interface_value.device_name
        id           = fmc_device_physical_interface.module[physical_interface_key].id
        logical_name = physical_interface_value.logical_name
        domain_name  = physical_interface_value.domain_name
      }
    ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for physical_interface_key, physical_interface_value in local.data_physical_interface : {
          name         = physical_interface_key
          device_name  = physical_interface_value.device_name
          id           = data.fmc_device_physical_interface.module[physical_interface_key].id
          logical_name = try(data.fmc_device_physical_interface.module[physical_interface_key].logical_name, null)
          domain_name  = physical_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.resource_etherchannel_interface : {
          name         = etherchannel_interface_key
          device_name  = etherchannel_interface_value.device_name
          id           = fmc_device_etherchannel_interface.module[etherchannel_interface_key].id
          logical_name = etherchannel_interface_value.logical_name
          domain_name  = etherchannel_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for etherchannel_interface_key, etherchannel_interface_value in local.data_etherchannel_interface : {
          name         = etherchannel_interface_key
          device_name  = etherchannel_interface_value.device_name
          id           = data.fmc_device_etherchannel_interface.module[etherchannel_interface_key].id
          logical_name = try(data.fmc_device_etherchannel_interface.module[etherchannel_interface_key].logical_name, null)
          domain_name  = etherchannel_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.resource_sub_interface : {
          name         = sub_interface_key
          device_name  = sub_interface_value.device_name
          id           = fmc_device_subinterface.module[sub_interface_key].id
          logical_name = sub_interface_value.logical_name
          domain_name  = sub_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for sub_interface_key, sub_interface_value in local.data_sub_interface : {
          name         = sub_interface_key
          device_name  = sub_interface_value.device_name
          id           = data.fmc_device_subinterface.module[sub_interface_key].id
          logical_name = try(data.fmc_device_subinterface.module[sub_interface_key].logical_name, null)
          domain_name  = sub_interface_value.domain_name
        }
      ]) : "${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
  )

}

######
### map_ftd_platform_settings
######
locals {
  map_ftd_platform_settings = merge({
    for item in flatten([
      for ftd_platform_setting_key, ftd_platform_setting_value in local.resource_ftd_platform_settings : {
        name        = ftd_platform_setting_key
        id          = fmc_ftd_platform_settings.module[ftd_platform_setting_key].id
        type        = fmc_ftd_platform_settings.module[ftd_platform_setting_key].type
        domain_name = ftd_platform_setting_value.domain
      }
    ]) : item.name => item if contains(keys(item), "name")
    },
    {
      for item in flatten([
        for ftd_platform_setting_key, ftd_platform_setting_value in local.data_ftd_platform_settings : {
          name        = ftd_platform_setting_key
          id          = data.fmc_ftd_platform_settings.module[ftd_platform_setting_key].id
          type        = data.fmc_ftd_platform_settings.module[ftd_platform_setting_key].type
          domain_name = ftd_platform_setting_value.domain
        }
      ]) : item.name => item if contains(keys(item), "name")
    },
  )

}

######
### FAKE - TODO
######


locals {

  map_device_groups = {}

}