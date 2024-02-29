###
# DEVICE
###
locals {
  res_devices = flatten([
    for domains in local.domains : [
      for object in try(domains.devices, []) : object if !contains(local.data_devices, object.name)
    ]
  ])
}

resource "fmc_devices" "device" {
  for_each = { for device in local.res_devices : device.name => device }

  # Mandatory  
  name     = each.value.name
  hostname = each.value.host
  regkey   = each.value.registration_key

  access_policy {
    id = local.map_accesspolicies[each.value.access_policy].id
  }

  # Optional  
  license_caps     = try(each.value.licenses)
  nat_id           = try(each.value.nat_id, local.defaults.fmc.domains.devices.nat_id, null)
  performance_tier = try(each.value.performance_tier, local.defaults.fmc.domains.devices.performance_tier, null)

  lifecycle {
    ignore_changes = [regkey, access_policy]
  }
}

###
# PHYSICAL INTERFACE
###
resource "fmc_device_physical_interfaces" "physical_interface" {
  for_each = { for physicalinterface in local.map_interfaces : physicalinterface.key => physicalinterface if physicalinterface.resource }

  # Mandatory
  name                  = each.value.data.interface
  device_id             = each.value.device_id
  physical_interface_id = data.fmc_device_physical_interfaces.physical_interface[each.value.key].id

  # Optional
  if_name                = try(each.value.data.name, null)
  security_zone_id       = try(local.map_securityzones[each.value.data.security_zone].id, null)
  enabled                = try(each.value.data.enabled, local.defaults.fmc.domains.devices.physical_interfaces.enabled)
  mode                   = try(each.value.data.mode, local.defaults.fmc.domains.devices.physical_interfaces.mode)
  ipv4_static_address    = try(each.value.data.ipv4_static_address, null)
  ipv4_static_netmask    = try(each.value.data.ipv4_static_netmask, null)
  ipv4_dhcp_enabled      = try(each.value.data.ipv4_dhcp, null)
  ipv4_dhcp_route_metric = try(each.value.data.ipv4_dhcp_route_metric, null)
  ipv6_address           = try(each.value.data.ipv6_address, null)
  ipv6_prefix            = try(each.value.data.ipv6_prefix, null)
  ipv6_enforce_eui       = try(each.value.data.ipv6_enforce_eui64, null)
  description            = try(each.value.data.description, local.defaults.fmc.domains.devices.physical_interfaces.description, null)

  depends_on = [
    data.fmc_device_physical_interfaces.physical_interface
  ]
}

###
# SUBINTERFACE
###
locals {
  res_sub_interface = flatten([
    for domain in local.domains : [
      for device in try(domain.devices, []) : [
        for physicalinterface in try(device.physical_interfaces, []) : [
          for subinterface in try(physicalinterface.subinterfaces, []) : {
            key          = "${device.name}/${physicalinterface.interface}/${subinterface.id}"
            phyinterface = physicalinterface.interface
            device_id    = local.map_devices[device.name].id
            device_name  = device.name
            data         = subinterface
          } if !contains(local.data_sub_interfces_list, "${device.name}/${physicalinterface.interface}/${subinterface.id}")
        ]
      ]
    ]
  ])
}

resource "fmc_device_subinterfaces" "sub_interfaces" {
  for_each = { for subinterface in local.res_sub_interface : subinterface.key => subinterface }

  # Mandatory  
  name            = each.value.phyinterface
  device_id       = each.value.device_id
  subinterface_id = each.value.data.id

  # Optional
  ifname                 = try(each.value.data.name, null)
  vlan_id                = try(each.value.data.vlan, null)
  enable_ipv6            = try(each.value.data.enable_ipv6, null)
  enabled                = try(each.value.data.enable_ipv6, null)
  ipv4_dhcp_enabled      = try(each.value.data.ipv4_dhcp, null)
  ipv4_dhcp_route_metric = try(each.value.data.ipv4_dhcp_route_metric, null)
  ipv4_static_address    = try(each.value.data.ipv4_static_address, null)
  ipv4_static_netmask    = try(each.value.data.ipv4_static_netmask, null)
  ipv6_address           = try(each.value.data.ipv6_address, null)
  ipv6_enforce_eui       = try(each.value.data.ipv6_enforce_eui, null)
  ipv6_prefix            = try(each.value.data.ipv6_prefix, null)
  management_only        = try(each.value.data.management_only, null)
  mode                   = try(each.value.data.mode, local.defaults.fmc.domains.devices.physical_interfaces.subinterfaces.mode, null)
  mtu                    = try(each.value.data.mtu, null)
  priority               = try(each.value.data.priority, null)
  security_zone_id       = try(local.map_securityzones[each.value.data.security_zone].id, null)
}
