###
# IPV4 STATIC ROUTE
###
locals {
  res_ipv4staticroutes = flatten([
    for domain in local.domains : [
      for device in try(domain.devices, []) : [
        for ipv4staticroute in try(device.ipv4_static_routes, []) : {
          key               = "${device.name}/${ipv4staticroute.name}"
          device_id         = local.map_devices[device.name].id
          gateway_id        = local.map_networkobjects[ipv4staticroute.gateway].id
          gateway_type      = local.map_networkobjects[ipv4staticroute.gateway].type
          gateway_name      = ipv4staticroute.gateway
          interface_name    = ipv4staticroute.interface
          selected_networks = ipv4staticroute.selected_networks
        }
      ]
    ]
  ])
}

resource "fmc_staticIPv4_route" "ipv4staticroute" {
  for_each = { for ipv4staticroute in local.res_ipv4staticroutes : ipv4staticroute.key => ipv4staticroute }

  # Mandatory  
  device_id      = each.value.device_id
  interface_name = each.value.interface_name
  metric_value   = try(each.value.metric_value, local.defaults.fmc.domains.devices.ipv4_static_routes.metric_value)

  gateway {
    object {
      id   = each.value.gateway_id
      type = each.value.gateway_type
      name = each.value.gateway_name
    }
  }

  dynamic "selected_networks" {
    for_each = { for obj in each.value.selected_networks : obj => obj }
    content {
      id   = try(local.map_networkobjects[selected_networks.value].id, local.map_res_networkgroups[selected_networks.value].id)
      type = try(local.map_networkobjects[selected_networks.value].type, local.map_res_networkgroups[selected_networks.value].type)
    }
  }

  # Optional
  is_tunneled = try(each.value.tunneled, local.defaults.fmc.domains.devices.ipv4_static_routes.tunneled, null)

  depends_on = [
    fmc_device_physical_interfaces.physical_interface,
    data.fmc_device_physical_interfaces.physical_interface,
    fmc_device_subinterfaces.sub_interfaces,
    data.fmc_device_subinterfaces.sub_interfaces
  ]
}
