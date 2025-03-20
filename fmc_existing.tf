#############################################################
# Define terraform data representation of objects that already exist on FMC
##########################################################
###    Content of the file:
##########################################################
#
###
#  Data sources
####
# data "fmc_hosts" "module"
# data "fmc_networks" "module"
# data "fmc_ranges" "module"
# data "fmc_fqdn_objects" "module"
# data "fmc_ports" "module"
# data "fmc_icmpv4_objects" "module"
# data "fmc_port_groups" "module"
# data "fmc_dynamic_objects" "module"
# data "fmc_urls" "module"
# data "fmc_url_groups" "module"
# data "fmc_vlan_tags" "module"
# data "fmc_vlan_tag_groups" "module"
# data "fmc_sgts" "module"
# data "fmc_security_zones" "module"
# data "fmc_tunnel_zones" "module"
# data "fmc_time_ranges" "module"
# data "fmc_variable_set" "module"
# data "fmc_standard_acl" "module"
# data "fmc_extended_acl" "module"
# data "fmc_bfd_template" "module"
# data "fmc_snmp_alerts" "module"
# data "fmc_syslog_alerts" "module"
# data "fmc_file_types" "module"
# data "fmc_file_categories" "module"
# data "fmc_applications" "module"
# data "fmc_application_business_relevances" "module"
# data "fmc_application_categories" "module"
# data "fmc_application_risks" "module"
# data "fmc_application_tags" "module"
# data "fmc_application_types" "module"
# data "fmc_application_filters" "module"
# data "fmc_access_control_policy" "module"
# data "fmc_ftd_nat_policy" "module"
# data "fmc_intrusion_policy" "module"
# data "fmc_file_policy" "module"
# data "fmc_prefilter_policy" "module"
# data "fmc_device" "module"
# data "fmc_device_ha_pair" "module"
# data "fmc_device_cluster" "module"
# data "fmc_device_physical_interface" "module"
# data "fmc_device_etherchannel_interface" "module"
# data "fmc_device_subinterface" "module"
# data "fmc_device_vrf" "module"
# data "fmc_device_bfd" "module"
# data "fmc_device_bgp_general_settings" "module"
#
###  
#  Local variables
###
# local.data_hosts
# local.data_networks
# local.data_ranges
# local.data_fqdns
# local.data_ports
# local.data_icmpv4s
# local.data_port_groups
# local.data_dynamic_objects
# local.data_urls
# local.data_url_groups
# local.data_vlan_tags
# local.data_vlan_tag_groups
# local.data_sgts
# local.data_security_zones
# local.data_tunnel_zones
# local.data_time_ranges
# local.data_variable_set
# local.data_standard_acl
# local.data_extended_acl
# local.data_bfd_template
# local.data_snmp_alerts
# local.data_syslog_alerts
# local.data_file_types
# local.data_file_categories
# local.data_applications 
# local.data_application_business_relevances
# local.data_application_categories 
# local.data_application_risks 
# local.data_application_tags 
# local.data_application_types 
# local.data_application_filters 
# local.data_access_control_policy
# local.data_ftd_nat_policy
# local.data_intrusion_policy
# local.data_file_policy
# local.data_prefilter_policy
# local.data_device
# local.data_device_ha_pair
# local.data_device_cluster
# local.data_physical_interface
# local.data_etherchannel_interface
# local.data_sub_interface
# local.data_vrf
# local.data_bfd
# local.data_bgp_general_setting
#
#
##########################################################
##########################################################
###    Objects
##########################################################
##########################################################

##########################################################
###    Hosts + Networks + Ranges + FQDNs
##########################################################
locals {

  data_hosts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for host in try(domain.objects.hosts, []) : host.name => {}
      }
    } if length(try(domain.objects.hosts, [])) > 0
  }

}

data "fmc_hosts" "module" {
  for_each = local.data_hosts

  items  = each.value.items
  domain = each.key
}

locals {

  # data_network = { 
  #    for item in flatten([
  #      for domain in local.data_existing : [ 
  #        for element in try(domain.objects.networks, {}) : {
  #          "name"        = element.name
  #          "domain_name" = domain.name
  #        }
  #      ]
  #      ]) : item.name => item if contains(keys(item), "name" )
  #    } 

  data_networks = {
    for domain in local.data_existing : domain.name => {
      items = {
        for network in try(domain.objects.networks, []) : network.name => {}
      }
    } if length(try(domain.objects.networks, [])) > 0
  }

}

#data "fmc_network" "network" {
#  for_each = local.data_network

#  name    = each.key
#  domain  = each.value.domain_name
#}

data "fmc_networks" "module" {
  for_each = local.data_networks

  items  = each.value.items
  domain = each.key
}

locals {

  data_ranges = {
    for domain in local.data_existing : domain.name => {
      items = {
        for range in try(domain.objects.ranges, []) : range.name => {}
      }
    } if length(try(domain.objects.ranges, [])) > 0
  }

}

data "fmc_ranges" "module" {
  for_each = local.data_ranges

  items  = each.value.items
  domain = each.key
}

locals {

  data_fqdns = {
    for domain in local.data_existing : domain.name => {
      items = {
        for fqdn in try(domain.objects.fqdns, []) : fqdn.name => {}
      }
    } if length(try(domain.objects.fqdns, [])) > 0
  }

}

data "fmc_fqdn_objects" "module" {
  for_each = local.data_fqdns

  items  = each.value.items
  domain = each.key
}

##########################################################
###    PORTS + ICMPv4s + Port_Groups
##########################################################
locals {

  data_ports = {
    for domain in local.data_existing : domain.name => {
      items = {
        for port in try(domain.objects.ports, []) : port.name => {}
      }
    } if length(try(domain.objects.ports, [])) > 0
  }

}

data "fmc_ports" "module" {
  for_each = local.data_ports

  items  = each.value.items
  domain = each.key
}

locals {

  data_icmpv4s = {
    for domain in local.data_existing : domain.name => {
      items = {
        for icmpv4 in try(domain.objects.icmpv4s, []) : icmpv4.name => {}
      }
    } if length(try(domain.objects.icmpv4s, [])) > 0
  }

}

data "fmc_icmpv4_objects" "module" {
  for_each = local.data_icmpv4s

  items  = each.value.items
  domain = each.key
}

locals {

  data_port_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for port_group in try(domain.objects.port_groups, []) : port_group.name => {}
      }
    } if length(try(domain.objects.port_groups, [])) > 0
  }

}

data "fmc_port_groups" "module" {
  for_each = local.data_port_groups

  items  = each.value.items
  domain = each.key
}

##########################################################
###    DYNAMIC OBJECTS
##########################################################
locals {

  data_dynamic_objects = {
    for domain in local.data_existing : domain.name => {
      items = {
        for dynamic_object in try(domain.objects.dynamic_objects, []) : dynamic_object.name => {}
      }
    } if length(try(domain.objects.dynamic_objects, [])) > 0
  }

}

data "fmc_dynamic_objects" "module" {
  for_each = local.data_dynamic_objects

  items  = each.value.items
  domain = each.key
}

##########################################################
###    URLs + URL_Groups
##########################################################
locals {

  data_urls = {
    for domain in local.data_existing : domain.name => {
      items = {
        for url in try(domain.objects.urls, []) : url.name => {}
      }
    } if length(try(domain.objects.urls, [])) > 0
  }

}

data "fmc_urls" "module" {
  for_each = local.data_urls

  items  = each.value.items
  domain = each.key
}

locals {

  data_url_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for url_group in try(domain.objects.url_groups, []) : url_group.name => {}
      }
    } if length(try(domain.objects.url_groups, [])) > 0
  }

}

data "fmc_url_groups" "module" {
  for_each = local.data_url_groups

  items  = each.value.items
  domain = each.key
}

##########################################################
###    SGTs (VLAN Tags) + SGT Groups
##########################################################
locals {

  data_vlan_tags = {
    for domain in local.data_existing : domain.name => {
      items = {
        for vlan_tag in try(domain.objects.vlan_tags, []) : vlan_tag.name => {}
      }
    } if length(try(domain.objects.vlan_tags, [])) > 0
  }

}

data "fmc_vlan_tags" "module" {
  for_each = local.data_vlan_tags

  items  = each.value.items
  domain = each.key
}

locals {

  data_vlan_tag_groups = {
    for domain in local.data_existing : domain.name => {
      items = {
        for vlan_tag_group in try(domain.objects.vlan_tag_groups, []) : vlan_tag_group.name => {}
      }
    } if length(try(domain.objects.vlan_tag_groups, [])) > 0
  }

}

data "fmc_vlan_tag_groups" "module" {
  for_each = local.data_vlan_tag_groups

  items  = each.value.items
  domain = each.key
}

##########################################################
###    Security Group Tags
##########################################################
locals {

  data_sgts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for sgt in try(domain.objects.sgts, []) : sgt.name => {}
      }
    } if length(try(domain.objects.sgts, [])) > 0
  }

}

data "fmc_sgts" "module" {
  for_each = local.data_sgts

  items  = each.value.items
  domain = each.key
}

##########################################################
###    SECURITY ZONE
##########################################################
locals {

  data_security_zones = {
    for domain in local.data_existing : domain.name => {
      items = {
        for security_zone in try(domain.objects.security_zones, []) : security_zone.name => {}
      }
    } if length(try(domain.objects.security_zones, [])) > 0
  }

}

data "fmc_security_zones" "module" {
  for_each = local.data_security_zones

  items  = each.value.items
  domain = each.key
}
##########################################################
###    Tunnel Zone
##########################################################
locals {

  data_tunnel_zones = {
    for domain in local.data_existing : domain.name => {
      items = {
        for tunnel_zone in try(domain.objects.tunnel_zones, []) : tunnel_zone.name => {}
      }
    } if length(try(domain.objects.tunnel_zones, [])) > 0
  }

}

data "fmc_tunnel_zones" "module" {
  for_each = local.data_tunnel_zones

  items  = each.value.items
  domain = each.key
}

##########################################################
###    Time Ranges
##########################################################
locals {

  data_time_ranges = {
    for domain in local.data_existing : domain.name => {
      items = {
        for time_range in try(domain.objects.time_ranges, []) : time_range.name => {}
      }
    } if length(try(domain.objects.time_ranges, [])) > 0
  }

}

data "fmc_time_ranges" "module" {
  for_each = local.data_time_ranges

  items  = each.value.items
  domain = each.key
}
##########################################################
###    Variable Set
##########################################################
locals {

  data_variable_set = {
    for item in flatten([
      for domain in local.data_existing : [
        for variable_set in try(domain.objects.variable_sets, {}) : {
          name        = variable_set.name
          domain_name = domain.name
        } if length(try(domain.objects.variable_sets, [])) > 0
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }


}

data "fmc_variable_set" "module" {
  for_each = local.data_variable_set

  name   = each.key
  domain = each.value.domain_name

}

##########################################################
###    ACCESS POLICY - STANDARD + EXTENDED
##########################################################
locals {
  data_standard_acl = {
    for item in flatten([
      for domain in local.data_existing : [
        for element in try(domain.objects.standard_acls, {}) : {
          name        = element.name
          domain_name = domain.name
        }
      ]
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
  }

}

data "fmc_standard_acl" "module" {
  for_each = local.data_standard_acl

  name   = each.value.name
  domain = each.value.domain_name
}

locals {
  data_extended_acl = {
    for item in flatten([
      for domain in local.data_existing : [
        for element in try(domain.objects.extended_acls, {}) : {
          name        = element.name
          domain_name = domain.name
        }
      ]
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name")
  }

}

data "fmc_extended_acl" "module" {
  for_each = local.data_extended_acl

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
##########################################################
###    Templates
##########################################################
##########################################################
##########################################################
###    BFD TEMPLATES
##########################################################
locals {

  data_bfd_template = {
    for item in flatten([
      for domain in local.data_existing : [
        for bfd_template in try(domain.objects.bfd_templates, []) : [
          {
            name        = bfd_template.name
            domain_name = domain.name
        }]
      ]
    ]) : "${item.domain_name}:${item.name}" => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}
data "fmc_bfd_template" "module" {
  for_each = local.data_bfd_template

  name   = each.value.name
  domain = each.value.domain_name

}

##########################################################
##########################################################
###    Alerts
##########################################################
##########################################################

##########################################################
###    SNMP Alert
##########################################################
locals {
  data_snmp_alerts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for snmp in try(domain.policies.alerts.snmps, {}) : snmp.name => {}
      }
    } if length(try(domain.policies.alerts.snmps, [])) > 0
  }

}

data "fmc_snmp_alerts" "module" {
  for_each = local.data_snmp_alerts

  items  = each.value.items
  domain = each.key
}

##########################################################
###    Syslog Alert
##########################################################
locals {
  data_syslog_alerts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for syslog in try(domain.policies.alerts.syslogs, {}) : syslog.name => {}
      }
    } if length(try(domain.policies.alerts.syslogs, [])) > 0
  }

}

data "fmc_syslog_alerts" "module" {
  for_each = local.data_syslog_alerts

  items  = each.value.items
  domain = each.key
}
##########################################################
##########################################################
###    File Types / Categories
##########################################################
##########################################################

locals {
  data_file_types = {
    for domain in local.data_existing : domain.name => {
      items = {
        for file_type in try(domain.objects.file_types, {}) : file_type.name => {}
      }
    } if length(try(domain.objects.file_types, [])) > 0
  }

}

data "fmc_file_types" "module" {
  for_each = local.data_file_types

  items  = each.value.items
  domain = each.key
}

locals {
  data_file_categories = {
    for domain in local.data_existing : domain.name => {
      items = {
        for file_category in try(domain.objects.file_categories, {}) : file_category.name => {}
      }
    } if length(try(domain.objects.file_categories, [])) > 0
  }

}

data "fmc_file_categories" "module" {
  for_each = local.data_file_categories

  items  = each.value.items
  domain = each.key
}

##########################################################
##########################################################
###    Applications / Filters
##########################################################
##########################################################
#Applications - built-in
locals {
  data_applications = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application in try(domain.objects.applications, {}) : application.name => {}
      }
    } if length(try(domain.objects.applications, [])) > 0
  }

}

data "fmc_applications" "module" {
  for_each = local.data_applications

  items  = each.value.items
  domain = each.key
}

#Application Business Relevances
locals {
  data_application_business_relevances = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_business_relevance in try(domain.objects.application_filters.business_relevances, {}) : application_business_relevance.name => {}
      }
    } if length(try(domain.objects.application_filters.business_relevances, [])) > 0
  }

}

data "fmc_application_business_relevances" "module" {
  for_each = local.data_application_business_relevances

  items  = each.value.items
  domain = each.key
}

#Application Categories
locals {
  data_application_categories = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_category in try(domain.objects.application_filters.categories, {}) : application_category.name => {}
      }
    } if length(try(domain.objects.application_filters.categories, [])) > 0
  }

}

data "fmc_application_categories" "module" {
  for_each = local.data_application_categories

  items  = each.value.items
  domain = each.key
}

# Application Risks
locals {
  data_application_risks = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_risk in try(domain.objects.application_filters.risks, {}) : application_risk.name => {}
      }
    } if length(try(domain.objects.application_filters.risks, [])) > 0
  }

}

data "fmc_application_risks" "module" {
  for_each = local.data_application_risks

  items  = each.value.items
  domain = each.key
}

# Application Tags
locals {
  data_application_tags = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_tag in try(domain.objects.application_filters.tags, {}) : application_tag.name => {}
      }
    } if length(try(domain.objects.application_filters.tags, [])) > 0
  }

}

data "fmc_application_tags" "module" {
  for_each = local.data_application_tags

  items  = each.value.items
  domain = each.key
}

#Application Types
locals {
  data_application_types = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_type in try(domain.objects.application_filters.types, {}) : application_type.name => {}
      }
    } if length(try(domain.objects.application_filters.types, [])) > 0
  }

}

data "fmc_application_types" "module" {
  for_each = local.data_application_types

  items  = each.value.items
  domain = each.key
}

#Application Filter
locals {
  data_application_filters = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_filter in try(domain.objects.application_filters.filters, {}) : application_filter.name => {}
      }
    } if length(try(domain.objects.application_filters.filters, [])) > 0
  }

}

data "fmc_application_filters" "module" {
  for_each = local.data_application_filters

  items  = each.value.items
  domain = each.key
}
##########################################################
##########################################################
###    Policies
##########################################################
##########################################################

##########################################################
###    ACCESS CONTROL POLICY
##########################################################
locals {
  data_access_control_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for access_policy in try(domain.policies.access_policies, {}) : {
          name        = access_policy.name
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

data "fmc_access_control_policy" "module" {
  for_each = local.data_access_control_policy

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    FTD NAT Policy
##########################################################
locals {
  data_ftd_nat_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for ftd_nat_policy in try(domain.policies.ftd_nat_policies, {}) : {
          name        = ftd_nat_policy.name
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

data "fmc_ftd_nat_policy" "module" {
  for_each = local.data_ftd_nat_policy

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    Intrusion (IPS) Policy
##########################################################
locals {
  data_intrusion_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for intrusion_policy in try(domain.policies.intrusion_policies, {}) : {
          name        = intrusion_policy.name
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

data "fmc_intrusion_policy" "module" {
  for_each = local.data_intrusion_policy

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    File Policy
##########################################################
locals {
  data_file_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for file_policy in try(domain.policies.file_policies, {}) : {
          name        = file_policy.name
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

data "fmc_file_policy" "module" {
  for_each = local.data_file_policy

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    Prefilter Policy
##########################################################
locals {
  data_prefilter_policy = {
    for item in flatten([
      for domain in local.data_existing : [
        for prefilter_policy in try(domain.policies.prefilter_policies, {}) : {
          name        = prefilter_policy.name
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name")
  }

}

data "fmc_prefilter_policy" "module" {
  for_each = local.data_prefilter_policy

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    DEVICE
##########################################################
locals {

  data_device = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, {}) : {
          name        = try(device.name, null)
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device" "module" {
  for_each = local.data_device

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    DEVICE HA Pair
##########################################################
locals {

  data_device_ha_pair = {
    for item in flatten([
      for domain in local.data_existing : [
        for ha_pair in try(domain.devices.ha_pairs, {}) : {
          name        = try(ha_pair.name, null)
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device_ha_pair" "module" {
  for_each = local.data_device_ha_pair

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    DEVICE Cluster
##########################################################
locals {

  data_device_cluster = {
    for item in flatten([
      for domain in local.data_existing : [
        for cluster in try(domain.devices.clusters, {}) : {
          name        = try(cluster.name, null)
          domain_name = domain.name
        }
      ]
    ]) : item.name => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device_cluster" "module" {
  for_each = local.data_device_cluster

  name   = each.value.name
  domain = each.value.domain_name
}

##########################################################
###    Physical Interface
##########################################################

locals {

  data_physical_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for physical_interface in try(vrf.physical_interfaces, []) : [
              {
                name        = physical_interface.name
                device_name = device.name
                device_id   = data.fmc_device.module[device.name].id
                domain_name = domain.name
            }]
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device_physical_interface" "module" {
  for_each = local.data_physical_interface

  name      = each.value.name
  device_id = each.value.device_id
  domain    = each.value.domain_name

  depends_on = [
    data.fmc_device.module
  ]
}

##########################################################
###    Ether Channel Interface
##########################################################

locals {

  data_etherchannel_interface = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            for etherchannel_interface in try(vrf.etherchannel_interfaces, []) : [
              {
                name        = etherchannel_interface.name
                device_name = device.name
                device_id   = data.fmc_device.module[device.name].id
                domain_name = domain.name
            }]
          ]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device_etherchannel_interface" "module" {
  for_each = local.data_etherchannel_interface

  name      = each.value.name
  device_id = each.value.device_id
  domain    = each.value.domain_name

  depends_on = [
    data.fmc_device.module
  ]
}

##########################################################
###    Sub-Interface
##########################################################

locals {
  data_sub_interface = { for item in flatten([
    for domain in local.data_existing : [
      for device in try(domain.devices.devices, []) : [
        for vrf in try(device.vrfs, []) : [
          for sub_interface in try(vrf.sub_interfaces, []) : [
            {
              name        = sub_interface.name
              device_name = device.name
              device_id   = data.fmc_device.module[device.name].id
              domain_name = domain.name
          }]
        ]
      ]
    ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #The device name is unique across the different domains. We want to search by index=Sub-Interface_id
  }

}

data "fmc_device_subinterface" "module" {
  for_each = local.data_sub_interface

  name      = each.value.name
  device_id = each.value.device_id
  domain    = each.value.domain_name

  depends_on = [
    data.fmc_device.module
  ]
}

##########################################################
###    VRF
##########################################################
locals {

  data_vrf = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for vrf in try(device.vrfs, []) : [
            {
              name        = vrf.name
              device_name = device.name
              device_id   = data.fmc_device.module[device.name].id
              domain_name = domain.name
          }]
        ]
      ]
    ]) : "${item.device_name}:${item.name}" => item if contains(keys(item), "name") #The device name is unique across the different domains.
  }

}

data "fmc_device_vrf" "module" {
  for_each = local.data_vrf

  name      = each.value.name
  device_id = each.value.device_id
  domain    = each.value.domain_name

  depends_on = [
    data.fmc_device.module
  ]
}

##########################################################
###    BFD 
##########################################################

locals {

  data_bfd = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          for bfd in try(device.bfds, []) : [
            {
              interface_logical_name = bfd.interface_logical_name
              device_id              = data.fmc_device.module[device.name].id
              domain_name            = domain.name
          }]
        ]
      ]
    ]) : "${item.domain_name}:${item.interface_logical_name}" => item if contains(keys(item), "interface_logical_name") #The device name is unique across the different domains.
  }

}
data "fmc_device_bfd" "module" {
  for_each = local.data_bfd

  interface_logical_name = each.value.interface_logical_name
  device_id              = each.value.device_id
  domain                 = each.value.domain_name

}


##########################################################
###    BGP - General Settings
##########################################################
locals {

  data_bgp_general_setting = {
    for item in flatten([
      for domain in local.data_existing : [
        for device in try(domain.devices.devices, []) : [
          {
            as_number   = device.bgp_general_settings.as_number
            device_name = device.name
            domain_name = domain.name
          }
        ] if contains(keys(device), "bgp_general_settings")
      ]
    ]) : "${item.device_name}:BGP" => item if contains(keys(item), "device_name")
  }

}

data "fmc_device_bgp_general_settings" "module" {
  for_each = local.data_bgp_general_setting

  as_number = each.value.as_number
  device_id = data.fmc_device.module[each.value.device_name].id
  domain    = each.value.domain_name

  depends_on = [
    data.fmc_device.module
  ]
}
