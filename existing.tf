###
# Define terraform data representation of objects that already exist on FMC
###

locals {
  data_devices        = [for obj in try(local.data_existing.fmc.domains[0].devices, []) : obj.name]
  data_clusters       = [for obj in try(local.data_existing.fmc.domains[0].clusters, []) : obj.name]
  data_accesspolicies = [for obj in try(local.data_existing.fmc.domains[0].access_policies, []) : obj.name]
  data_ftdnatpolicies = [for obj in try(local.data_existing.fmc.domains[0].ftd_nat_policies, []) : obj.name]
  data_ipspolicies    = [for obj in try(local.data_existing.fmc.domains[0].ips_policies, []) : obj.name]
  data_filepolicies   = [for obj in try(local.data_existing.fmc.domains[0].file_policies, []) : obj.name]
  data_hosts          = [for obj in try(local.data_existing.fmc.domains[0].objects.hosts, []) : obj.name]
  data_networks       = [for obj in try(local.data_existing.fmc.domains[0].objects.networks, []) : obj.name]
  #data_ranges        = []
  data_networkgroups = [for obj in try(local.data_existing.fmc.domains[0].objects.network_groups, []) : obj.name]
  data_ports         = [for obj in try(local.data_existing.fmc.domains[0].objects.ports, []) : obj.name]
  data_portgroups    = [for obj in try(local.data_existing.fmc.domains[0].objects.port_groups, []) : obj.name]
  #data_icmpv_4s       = []
  data_securityzones  = [for obj in try(local.data_existing.fmc.domains[0].objects.security_zones, []) : obj.name]
  data_urls           = [for obj in try(local.data_existing.fmc.domains[0].objects.urls, []) : obj.name]
  data_syslogalerts   = []
  data_sgts           = [for obj in try(local.data_existing.fmc.domains[0].objects.sgts, []) : obj.name]
  data_dynamicobjects = [for obj in try(local.data_existing.fmc.domains[0].objects.dynamic_objects, []) : obj.name]

  data_sub_interfaces = flatten([
    for device in try(local.data_existing.fmc.domains[0].devices, []) : [
      for physicalinterface in try(device.physical_interfaces, []) : [
        for subinterface in try(physicalinterface.subinterfaces, []) : {
          key               = "${device.name}/${physicalinterface.interface}/${subinterface.id}"
          device_id         = local.map_devices[device.name].id
          physicalinterface = physicalinterface.interface
          subinterface_id   = subinterface.id
        }
      ]
    ]
  ])

  data_sub_interfces_list = flatten([
    for device in try(local.data_existing.fmc.domains[0].devices, []) : [
      for physicalinterface in try(device.physical_interfaces, []) : [
        for subinterface in try(physicalinterface.subinterfaces, []) : "${device.name}/${physicalinterface.interface}/${subinterface.id}"
      ]
    ]
  ])

}

data "fmc_access_policies" "accesspolicy" {
  for_each = toset(local.data_accesspolicies)

  name = each.key
}

data "fmc_ftd_nat_policies" "ftdnatpolicy" {
  for_each = toset(local.data_ftdnatpolicies)

  name = each.key
}

data "fmc_host_objects" "host" {
  for_each = toset(local.data_hosts)

  name = each.key
}

data "fmc_network_objects" "network" {
  for_each = toset(local.data_networks)

  name = each.key
}

# No data.fmc_range_objects in the provider
#data "fmc_range_objects" "range" {
#  for_each = toset(local.data_ranges)
#
#  name = each.key 
#}

data "fmc_network_group_objects" "networkgroup" {
  for_each = toset(local.data_networkgroups)

  name = each.key
}

data "fmc_port_objects" "port" {
  for_each = toset(local.data_ports)

  name = each.key
}

data "fmc_port_group_objects" "portgroup" {
  for_each = toset(local.data_portgroups)

  name = each.key
}

# No data.fmc_icmpv4_objects in the provider
#data "fmc_icmpv4_objects" "icmpv4" {
#  for_each = toset(local.data_icmpv4s)
#
#  name = each.key 
#}

data "fmc_security_zones" "securityzone" {
  for_each = toset(local.data_securityzones)

  name = each.key
}

data "fmc_dynamic_objects" "dynamicobject" {
  for_each = toset(local.data_dynamicobjects)

  name = each.key
}

data "fmc_ips_policies" "ips_policy" {
  for_each = toset(local.data_ipspolicies)

  name = each.key
}

data "fmc_file_policies" "file_policy" {
  for_each = toset(local.data_filepolicies)

  name = each.key
}

data "fmc_devices" "device" {
  for_each = toset(local.data_devices)

  name = each.key
}

data "fmc_device_cluster" "cluster" {
  for_each = toset(local.data_clusters)

  name = each.key
}

data "fmc_device_physical_interfaces" "physical_interface" {
  for_each = local.map_interfaces

  device_id = each.value.device_id
  name      = each.value.data.interface

  depends_on = [
    fmc_devices.device,
    data.fmc_devices.device
  ]
}

data "fmc_device_subinterfaces" "sub_interfaces" {
  for_each = { for object in local.data_sub_interfaces : object.key => object }

  device_id       = each.value.device_id
  subinterface_id = each.value.subinterface_id

  depends_on = [
    fmc_devices.device,
    data.fmc_devices.device
  ]
}

data "fmc_sgt_objects" "sgt" {
  for_each = toset(local.data_sgts)

  name = each.key
}

data "fmc_url_objects" "url" {
  for_each = toset(local.data_urls)

  name = each.key
}

data "fmc_syslog_alerts" "syslogalert" {
  for_each = toset(local.data_syslogalerts)

  name = each.key
}
