######
### map_devices
######
locals {
  map_devices_internal = merge(
    # Devices - individual mode outputs
    { for key, resource in fmc_device.device : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Devices - data source
    { for key, data in data.fmc_device.device : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },

    # Chassis logical device - individual mode outputs
    { for key, resource in fmc_chassis_logical_device.chassis_logical_device : "${resource.domain}:${resource.name}" => { id = resource.device_id, type = resource.device_type } },
  )

  # External objects
  map_devices_external = {
    for key, value in try(local.data.devices.devices, {}) : key => value
  }

  # Internal + External for reference in other objects
  map_devices = merge(
    local.map_devices_internal,
    local.map_devices_external,
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
  map_interfaces_by_names_internal = merge(
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
          domain       = subinterface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
  )

  map_interfaces_by_names_external = {
    for key, value in try(local.data.devices.interfaces_by_names, {}) : key => value
  }

  map_interfaces_by_names = merge(
    local.map_interfaces_by_names_internal,
    local.map_interfaces_by_names_external,
  )

}

######
### map_interfaces_by_logical_names
######
locals {
  map_interfaces_by_logical_names_internal = merge({
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
    {
      for item in flatten([
        for loopback_interface_key, loopback_interface_value in local.resource_device_loopback_interface : {
          name         = loopback_interface_value.name
          device_name  = loopback_interface_value.device_name
          id           = fmc_device_loopback_interface.device_loopback_interface[loopback_interface_key].id
          logical_name = try(loopback_interface_value.logical_name, null)
          domain       = loopback_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for loopback_interface_key, loopback_interface_value in local.data_device_loopback_interface : {
          name         = loopback_interface_value.name
          device_name  = loopback_interface_value.device_name
          id           = data.fmc_device_loopback_interface.device_loopback_interface[loopback_interface_key].id
          logical_name = try(data.fmc_device_loopback_interface.device_loopback_interface[loopback_interface_key].logical_name, null)
          domain       = loopback_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for tunnel_interface_key, tunnel_interface_value in local.resource_device_virtual_tunnel_interface : {
          name         = tunnel_interface_value.name
          device_name  = tunnel_interface_value.device_name
          id           = fmc_device_virtual_tunnel_interface.device_virtual_tunnel_interface[tunnel_interface_key].id
          logical_name = try(tunnel_interface_value.logical_name, null)
          domain       = tunnel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
    {
      for item in flatten([
        for tunnel_interface_key, tunnel_interface_value in local.data_device_virtual_tunnel_interface : {
          name         = tunnel_interface_value.name
          device_name  = tunnel_interface_value.device_name
          id           = data.fmc_device_virtual_tunnel_interface.device_virtual_tunnel_interface[tunnel_interface_key].id
          logical_name = try(data.fmc_device_virtual_tunnel_interface.device_virtual_tunnel_interface[tunnel_interface_key].logical_name, null)
          domain       = tunnel_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.logical_name}" => item if item.logical_name != null
    },
  )

  map_interfaces_by_logical_names_external = {
    for key, value in try(local.data.devices.interfaces_by_logical_names, {}) : key => value
  }

  map_interfaces_by_logical_names = merge(
    local.map_interfaces_by_logical_names_internal,
    local.map_interfaces_by_logical_names_external,
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
  map_ftd_platform_settings_internal = merge(
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

  map_ftd_platform_settings_external = {
    for key, value in try(local.data.devices.ftd_platform_settings, {}) : key => value
  }

  map_ftd_platform_settings = merge(
    local.map_ftd_platform_settings_internal,
    local.map_ftd_platform_settings_external,
  )
}

######
### map_primary_device_to_container
######
locals {
  # Keyed by PRIMARY member device id only.
  map_primary_device_to_container = merge(
    { for key, ha_pair in data.fmc_device_ha_pair.device_ha_pair : ha_pair.primary_device_id => { id = ha_pair.id } },
    { for key, ha_pair in fmc_device_ha_pair.device_ha_pair : ha_pair.primary_device_id => { id = ha_pair.id } }
  )
}

######
### map_ha_pairs
######
locals {
  map_ha_pairs = merge(
    {
      for item in flatten([
        for ha_pair_key, ha_pair_value in local.resource_device_ha_pair : {
          name   = ha_pair_value.name
          domain = ha_pair_value.domain
          id     = fmc_device_ha_pair.device_ha_pair[ha_pair_key].id
          type   = fmc_device_ha_pair.device_ha_pair[ha_pair_key].type
        }
      ]) : "${item.domain}:${item.name}" => item
    },
    {
      for item in flatten([
        for ha_pair_key, ha_pair_value in local.data_device_ha_pair : {
          name   = ha_pair_value.name
          domain = ha_pair_value.domain
          id     = data.fmc_device_ha_pair.device_ha_pair[ha_pair_key].id
          type   = data.fmc_device_ha_pair.device_ha_pair[ha_pair_key].type
        }
      ]) : "${item.domain}:${item.name}" => item
    },
  )
}

######
### map_member_device_to_container
######
locals {
  # HA pairs declared in the data model, keyed by ANY member device name (primary and
  # secondary).
  map_member_device_to_container = {
    for item in flatten([
      for domain in local.domains : [
        for ha_pair in try(domain.devices.ha_pairs, []) : [
          for member_name in [ha_pair.primary_device, ha_pair.secondary_device] : {
            key         = "${domain.name}:${member_name}"
            ha_pair_key = "${domain.name}:${ha_pair.name}"
          }
        ]
      ]
      ]) : item.key => {
      id   = local.map_ha_pairs[item.ha_pair_key].id
      type = local.map_ha_pairs[item.ha_pair_key].type
      name = local.map_ha_pairs[item.ha_pair_key].name
    }
  }
}

######
### ha_pair_secondary_devices
######
locals {
  # Devices that are the secondary member of an HA pair declared in the data model.
  #
  # Only the primary member's policy values are taken into account, for all five policy
  # types. The access control policy, FTD NAT policy, FTD platform settings and RA VPN are
  # assigned to the HA pair rather than to the member device, so without this two members
  # naming different policies produce two policy assignments that both target the same pair
  # and overwrite each other on every apply. The health policy is assigned to the primary
  # member device itself and replicated to the standby by FMC, so the secondary's value is
  # redundant there too.
  ha_pair_secondary_devices = flatten([
    for domain in local.domains : [
      for ha_pair in try(domain.devices.ha_pairs, []) : "${domain.name}:${ha_pair.secondary_device}"
    ]
  ])
}

######
### map_existing_ha_pair_members
######
locals {
  # Devices read through a data source, keyed by their id. Data sources are read during
  # plan, so these ids are known and can safely be matched against HA pair members.
  map_data_device_keys = {
    for key, device in data.fmc_device.device : device.id => key
  }

  # HA pairs declared under `existing`, keyed by the data model key of each member device.
  #
  # The `existing` model carries only the pair name, so the members are resolved through
  # the data source. Only ids that come from data sources are matched here - the id of a
  # device that is being created is unknown at plan time, and using it as a lookup key
  # would make this map unknown, which in turn breaks the policy assignment for_each.
  # A device being created cannot be a member of an already existing HA pair anyway.
  map_existing_ha_pair_members = {
    for item in flatten([
      for key, ha_pair in data.fmc_device_ha_pair.device_ha_pair : [
        for member_id in [ha_pair.primary_device_id, ha_pair.secondary_device_id] : {
          key       = lookup(local.map_data_device_keys, member_id, "")
          container = { id = ha_pair.id, type = ha_pair.type, name = ha_pair.name }
        }
      ]
    ]) : item.key => item.container if item.key != ""
  }

  # Same, extended to every device of the data model, so that it can be indexed
  # unconditionally. A device that is not a member of an existing HA pair yields an empty
  # container, which is what a device without a parent container looks like anyway.
  map_device_to_existing_ha_pair = {
    for item in flatten([
      for domain in local.domains : [
        for device in try(domain.devices.devices, []) : {
          key       = "${domain.name}:${device.name}"
          container = lookup(local.map_existing_ha_pair_members, "${domain.name}:${device.name}", { id = "", type = "", name = "" })
        }
      ]
    ]) : item.key => item.container
  }
}

######
### map_policy_assignment_targets
######
locals {
  # FMC keeps a policy assignment of an HA pair member against the parent DeviceHAPair
  # container, not against the member device itself.
  map_policy_assignment_targets = merge(
    {
      for item in flatten([
        for domain in local.domains : [
          for chassis in try(domain.devices.chassis, []) : [
            for logical_device in try(chassis.logical_devices, []) : {
              key = "${domain.name}:${logical_device.name}"
              target = (
                contains(keys(local.map_member_device_to_container), "${domain.name}:${logical_device.name}")
                ? local.map_member_device_to_container["${domain.name}:${logical_device.name}"]
                : {
                  id   = local.map_devices["${domain.name}:${logical_device.name}"].id
                  type = local.map_devices["${domain.name}:${logical_device.name}"].type
                  name = logical_device.name
                }
              )
            }
          ]
        ]
      ]) : item.key => item.target
    },
    {
      for item in flatten([
        for domain in local.domains : [
          for device in try(domain.devices.devices, []) : {
            key = "${domain.name}:${device.name}"
            target = (
              contains(keys(local.map_member_device_to_container), "${domain.name}:${device.name}")
              ? local.map_member_device_to_container["${domain.name}:${device.name}"]
              : local.map_device_to_existing_ha_pair["${domain.name}:${device.name}"].type == "DeviceHAPair"
              ? local.map_device_to_existing_ha_pair["${domain.name}:${device.name}"]
              : {
                id   = local.map_devices["${domain.name}:${device.name}"].id
                type = local.map_devices["${domain.name}:${device.name}"].type
                name = device.name
              }
            )
          }
        ]
      ]) : item.key => item.target
    },
  )
}
######
### map_loopback_interfaces
######
locals {
  map_loopback_interfaces_internal = merge(
    {
      for item in flatten([
        for loopback_interface_key, loopback_interface_value in local.resource_device_loopback_interface : {
          name        = loopback_interface_value.name
          device_name = loopback_interface_value.device_name
          id          = fmc_device_loopback_interface.device_loopback_interface[loopback_interface_key].id
          domain      = loopback_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
    {
      for item in flatten([
        for loopback_interface_key, loopback_interface_value in local.data_device_loopback_interface : {
          name        = loopback_interface_value.name
          device_name = loopback_interface_value.device_name
          id          = data.fmc_device_loopback_interface.device_loopback_interface[loopback_interface_key].id
          domain      = loopback_interface_value.domain
        }
      ]) : "${item.domain}:${item.device_name}:${item.name}" => item
    },
  )

  map_loopback_interfaces_external = {
    for key, value in try(local.data.devices.loopback_interfaces, {}) : key => value
  }

  map_loopback_interfaces = merge(
    local.map_loopback_interfaces_internal,
    local.map_loopback_interfaces_external,
  )
}
