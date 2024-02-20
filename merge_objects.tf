#
# Create maps for combined set of _data and _resources objects
#
locals {

  map_networkobjects = merge({
    for objecthost1 in local.res_hosts :
    objecthost1.name => {
      id   = fmc_host_objects.host[objecthost1.name].id
      type = fmc_host_objects.host[objecthost1.name].type
    }
    },
    {
      for objecthost2 in local.data_hosts :
      objecthost2 => {
        id   = data.fmc_host_objects.host[objecthost2].id
        type = data.fmc_host_objects.host[objecthost2].type
      }
    },
    {
      for objectnet1 in local.res_networks :
      objectnet1.name => {
        id   = fmc_network_objects.network[objectnet1.name].id
        type = fmc_network_objects.network[objectnet1.name].type
      }
    },
    {
      for objectnet2 in local.data_networks :
      objectnet2 => {
        id   = data.fmc_network_objects.network[objectnet2].id
        type = data.fmc_network_objects.network[objectnet2].type
      }
    },
    {
      for objectran1 in local.res_ranges :
      objectran1.name => {
        id = fmc_range_objects.range[objectran1.name].id
        #type = fmc_range_objects.range["${objectran1.name}"].type
        type = "Range" # TF provider does not include 'type' field for range resource
      }
    },
    # no data.fmc_range_objects in the provider
    #{
    #for objectran2 in local.data_ranges : 
    #  (objectran2) => {
    #    id = data.fmc_range_objects.range["${objectran2}"].id
    #    #type = data.fmc_range_objects.range["${objectran2}"].type
    #    type = "Range"
    #  }
    #},
    {
      for objectnetgr1 in local.data_networkgroups :
      objectnetgr1 => {
        id   = data.fmc_network_group_objects.networkgroup[objectnetgr1].id
        type = data.fmc_network_group_objects.networkgroup[objectnetgr1].type
      }
    },
    {
      for fqdn in local.res_fqdns :
      fqdn.name => {
        id = fmc_fqdn_objects.fqdn[fqdn.name].id
        #type = fmc_fqdn_objects.fqdn["${fqdn.name}"].type
        type = "FQDN" # TF provider does not include 'type' field for fqdn resource
      }
    }
  )

  map_interfaces = merge(concat(
    flatten([
      for domain in local.domains : [
        for device in try(domain.devices, []) : {
          for physicalinterface in try(device.physical_interfaces, []) : "${device.name}/${physicalinterface.interface}" => {
            key         = "${device.name}/${physicalinterface.interface}"
            device_id   = local.map_devices[device.name].id
            device_name = device.name
            data        = physicalinterface
            resource    = true
          }
        }
      ]
    ]),
    flatten([
      for device in try(local.data_existing.fmc.domains[0].devices, []) : {
        for physicalinterface in try(device.physical_interfaces, []) : "${device.name}/${physicalinterface.interface}" => {
          key         = "${device.name}/${physicalinterface.interface}"
          device_id   = local.map_devices[device.name].id
          device_name = device.name
          data        = physicalinterface
          resource    = false
        }
      }
    ])
    )...
  )

  map_securityzones = merge({
    for securityzone in local.res_securityzones :
    securityzone.name => {
      id   = fmc_security_zone.securityzone[securityzone.name].id
      type = fmc_security_zone.securityzone[securityzone.name].type
    }
    },
    {
      for securityzone in local.data_securityzones :
      securityzone => {
        id   = data.fmc_security_zones.securityzone[securityzone].id
        type = data.fmc_security_zones.securityzone[securityzone].type
      }
    }
  )

  map_ports = merge({
    for port in local.res_ports :
    port.name => {
      id   = fmc_port_objects.port[port.name].id
      type = fmc_port_objects.port[port.name].type
    }
    },
    {
      for port in local.data_ports :
      port => {
        id   = data.fmc_port_objects.port[port].id
        type = data.fmc_port_objects.port[port].type
      }
    },
    {
      for portgroup in local.data_portgroups :
      portgroup => {
        id = data.fmc_port_group_objects.portgroup[portgroup].id
        #type = data.fmc_port_group_objects.portgroup[portgroup].type
        type = "PortObjectGroup"
      }
    },
    {
      for icmpv4 in local.res_icmpv4s :
      icmpv4.name => {
        id   = fmc_icmpv4_objects.icmpv4[icmpv4.name].id
        type = fmc_icmpv4_objects.icmpv4[icmpv4.name].type
      }
    }
  )

  map_accesspolicies = merge({
    for accesspolicy in local.res_accesspolicies :
    accesspolicy.name => {
      id   = fmc_access_policies.accesspolicy[accesspolicy.name].id
      type = fmc_access_policies.accesspolicy[accesspolicy.name].type
    }
    },
    {
      for accesspolicy in local.data_accesspolicies :
      accesspolicy => {
        id   = data.fmc_access_policies.accesspolicy[accesspolicy].id
        type = data.fmc_access_policies.accesspolicy[accesspolicy].type
      }
    }
  )

  map_devices = merge({
    for device in local.res_devices :
    device.name => {
      id   = fmc_devices.device[device.name].id
      type = fmc_devices.device[device.name].type
    }
    },
    {
      for device in local.data_devices :
      device => {
        id   = data.fmc_devices.device[device].id
        type = data.fmc_devices.device[device].type
      }
    }
  )

  map_ipspolicies = merge({
    for ipspolicy in local.res_ipspolicies :
    ipspolicy.name => {
      id   = fmc_ips_policies.ips_policy[ipspolicy.name].id
      type = fmc_ips_policies.ips_policy[ipspolicy.name].type
    }
    },
    {
      for ipspolicy in local.data_ipspolicies :
      ipspolicy => {
        id   = data.fmc_ips_policies.ips_policy[ipspolicy].id
        type = data.fmc_ips_policies.ips_policy[ipspolicy].type
      }
    }
  )

  map_natpolicies = merge({
    for natpolicy in local.res_ftdnatpolicies :
    natpolicy.name => {
      id   = fmc_ftd_nat_policies.ftdnatpolicy[natpolicy.name].id
      type = fmc_ftd_nat_policies.ftdnatpolicy[natpolicy.name].type
    }
    },
    {
      for natpolicy in local.data_ftdnatpolicies :
      natpolicy => {
        id   = data.fmc_ftd_nat_policies.ftdnatpolicy[natpolicy].id
        type = data.fmc_ftd_nat_policies.ftdnatpolicy[natpolicy].type
      }
    }
  )

  map_urls = merge({
    for url in local.res_urls :
    url.name => {
      id   = fmc_url_objects.url[url.name].id
      type = fmc_url_objects.url[url.name].type
    }
    },
    {
      for url in local.data_urls :
      url => {
        id   = data.fmc_url_objects.url[url].id
        type = data.fmc_url_objects.url[url].type
      }
    }
  )

  map_urlgroups = merge({
    for url in local.res_urlgroups :
    url.name => {
      id   = fmc_url_object_group.urlgroup[url.name].id
      type = fmc_url_object_group.urlgroup[url.name].type
    }
    }
  )

  map_sgts = merge({
    for sgt in local.res_sgts :
    sgt.name => {
      id   = fmc_sgt_objects.sgt[sgt.name].id
      type = fmc_sgt_objects.sgt[sgt.name].type
    }
    },
    {
      for sgt in local.data_sgts :
      sgt => {
        id   = data.fmc_sgt_objects.sgt[sgt].id
        type = data.fmc_sgt_objects.sgt[sgt].type
      }
    }
  )

  map_dynamicobjects = merge({
    for dynobj in local.res_dynamicobjects :
    dynobj.name => {
      id   = fmc_dynamic_objects.dynamicobject[dynobj.name].id
      type = fmc_dynamic_objects.dynamicobject[dynobj.name].type
    }
    },
    {
      for dynobj in local.data_dynamicobjects :
      dynobj => {
        id   = data.fmc_dynamic_objects.dynamicobject[dynobj].id
        type = data.fmc_dynamic_objects.dynamicobject[dynobj].type
      }
    }
  )
}
