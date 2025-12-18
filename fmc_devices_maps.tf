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