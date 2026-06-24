##########################################################
###    SMART LICENSE
##########################################################
resource "fmc_smart_license" "smart_license" {
  for_each = try(local.fmc.system.smart_license.registration_type, null) != null ? { license = {} } : {}

  registration_type   = local.fmc.system.smart_license.registration_type
  token               = try(local.fmc.system.smart_license.token, null)
  retain_registration = try(local.fmc.system.smart_license.retain, null)
  force               = try(local.fmc.system.smart_license.force, null)
}

##########################################################
###    POLICY ASSIGNMENT
##########################################################
locals {
  # Static set of access control policy definitions keyed by "domain:name", derived
  # from configuration (not resource attributes) so that the for_each keys below are
  # known at plan time. Apply-time values (id/type) are looked up from the map.
  policy_defs_acp = merge(
    { for k, v in local.resource_access_control_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.data_access_control_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.map_access_control_policies_external : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
  )

  resource_policy_assignment_acp = {
    for item in [
      for policy_key, policy_def in local.policy_defs_acp : {
        key                     = policy_key
        policy_domain           = policy_def.domain
        policy_id               = local.map_access_control_policies[policy_key].id
        policy_name             = policy_def.name
        policy_type             = local.map_access_control_policies[policy_key].type
        after_destroy_policy_id = try(local.map_access_control_policies["Global:${local.fmc.system.policy_assignment.after_destroy_access_control_policy}"].id, null)

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.access_control_policy, null) == policy_def.name && contains(try(keys(local.data_device), []), "${domain.name}:${device.name}")
          ]
        ])
      }
    ] : item.key => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "access_control_policy" {
  for_each = local.resource_policy_assignment_acp

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
  ]
}

locals {
  policy_defs_health = merge(
    { for k, v in local.resource_health_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.data_health_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.map_health_policies_external : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
  )

  resource_policy_assignments_health_policy = {
    for item in [
      for policy_key, policy_def in local.policy_defs_health : {
        key                     = policy_key
        policy_domain           = policy_def.domain
        policy_id               = local.map_health_policies[policy_key].id
        policy_name             = policy_def.name
        policy_type             = local.map_health_policies[policy_key].type
        after_destroy_policy_id = try(local.map_health_policies["Global:${local.fmc.system.policy_assignment.after_destroy_health_policy}"].id, null)

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.health_policy, null) == policy_def.name && !contains(try(keys(local.resource_device), []), "${domain.name}:${device.name}")
          ]
        ])
      }
    ] : item.key => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "health_policy" {
  for_each = local.resource_policy_assignments_health_policy

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
  ]
}

locals {
  policy_defs_ftd_nat = merge(
    { for k, v in local.resource_ftd_nat_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.data_ftd_nat_policy : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.map_ftd_nat_policies_external : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
  )

  resource_policy_assignments_ftd_nat_policy = {
    for item in [
      for policy_key, policy_def in local.policy_defs_ftd_nat : {
        key                     = policy_key
        policy_domain           = policy_def.domain
        policy_id               = local.map_ftd_nat_policies[policy_key].id
        policy_name             = policy_def.name
        policy_type             = local.map_ftd_nat_policies[policy_key].type
        after_destroy_policy_id = null

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.nat_policy, null) == policy_def.name && !contains(try(keys(local.resource_device), []), "${domain.name}:${device.name}")
          ]
        ])
      }
    ] : item.key => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "ftd_nat_policy" {
  for_each = local.resource_policy_assignments_ftd_nat_policy

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
  ]
}

locals {
  resource_policy_assignments_ftd_platform_settings = {
    for item in flatten([
      for ftd_platform_settings_key, ftd_platform_settings_value in local.map_ftd_platform_settings : {
        policy_domain           = ftd_platform_settings_value.domain
        policy_id               = ftd_platform_settings_value.id
        policy_name             = ftd_platform_settings_key
        policy_type             = ftd_platform_settings_value.type
        after_destroy_policy_id = null
        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.platform_settings, null) == ftd_platform_settings_value.name
          ]
        ])
      }
    ]) : "${item.policy_domain}:${item.policy_name}" => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "ftd_platform_settings" {
  for_each = local.resource_policy_assignments_ftd_platform_settings

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
    fmc_ftd_platform_settings.ftd_platform_settings,
    fmc_ftd_platform_settings_banner.ftd_platform_settings_banner,
    fmc_ftd_platform_settings_http_access.ftd_platform_settings_http_access,
    fmc_ftd_platform_settings_icmp_access.ftd_platform_settings_icmp_access,
    fmc_ftd_platform_settings_snmp.ftd_platform_settings_snmp,
    fmc_ftd_platform_settings_ssh_access.ftd_platform_settings_ssh_access,
    fmc_ftd_platform_settings_syslog_logging_setup.ftd_platform_settings_syslog_logging_setup,
    fmc_ftd_platform_settings_syslog_logging_destination.ftd_platform_settings_syslog_logging_destination,
    fmc_ftd_platform_settings_syslog_email_setup.ftd_platform_settings_syslog_email_setup,
    fmc_ftd_platform_settings_syslog_event_list.ftd_platform_settings_syslog_event_list,
    fmc_ftd_platform_settings_syslog_rate_limit.ftd_platform_settings_syslog_rate_limit,
    fmc_ftd_platform_settings_syslog_settings.ftd_platform_settings_syslog_settings,
    fmc_ftd_platform_settings_syslog_settings_syslog_id.ftd_platform_settings_syslog_settings_syslog_id,
    fmc_ftd_platform_settings_syslog_servers.ftd_platform_settings_syslog_servers,
    fmc_ftd_platform_settings_time_synchronization.ftd_platform_settings_time_synchronization
  ]
}

locals {
  policy_defs_vpn_ra = merge(
    { for k, v in local.resource_vpn_ra : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.data_vpn_ra : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
    { for k, v in local.map_vpn_ra_external : "${v.domain}:${v.name}" => { domain = v.domain, name = v.name } },
  )

  resource_policy_assignments_vpn_ra = {
    for item in [
      for policy_key, policy_def in local.policy_defs_vpn_ra : {
        key                     = policy_key
        policy_domain           = policy_def.domain
        policy_id               = local.map_vpn_ra[policy_key].id
        policy_name             = policy_def.name
        policy_type             = local.map_vpn_ra[policy_key].type
        after_destroy_policy_id = null

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.remote_access_vpn, null) == policy_def.name
          ]
        ])
      }
    ] : item.key => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "vpn_ra" {
  for_each = local.resource_policy_assignments_vpn_ra

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
  ]
}

##########################################################
###    DEPLOY
##########################################################
resource "fmc_device_deploy" "device_deploy" {
  for_each = {
    for k, v in {
      for domain in local.domains : domain.name => [
        for device in try(domain.devices.devices, []) : local.map_devices["${domain.name}:${device.name}"].id if try(device.deploy, false)
      ]
    } : k => { device_id_list = v } if var.manage_deployment && length(v) > 0
  }

  domain          = each.key
  device_id_list  = each.value.device_id_list
  ignore_warning  = try(local.fmc.system.deployment.ignore_warning, local.defaults.fmc.domains.devices.devices.deploy_ignore_warning, null)
  deployment_note = try(local.fmc.system.deployment.deployment_note, local.defaults.fmc.domains.devices.devices.deploy_deployment_note, null)

  depends_on = [
    fmc_device_physical_interface.device_physical_interface,
    fmc_device_etherchannel_interface.device_etherchannel_interface,
    fmc_device_subinterface.device_subinterface,
    fmc_device_ha_pair.device_ha_pair,
    fmc_device_ha_pair_monitoring.device_ha_pair_monitoring,
    fmc_device_cluster.device_cluster,
    fmc_policy_assignment.access_control_policy,
    fmc_policy_assignment.ftd_nat_policy,
    fmc_policy_assignment.ftd_platform_settings,
    fmc_policy_assignment.vpn_ra,
    fmc_device_deploy.chassis_deploy,
  ]
}

resource "fmc_device_deploy" "chassis_deploy" {
  for_each = {
    for k, v in {
      for domain in local.domains : domain.name => [
        for chassis in try(domain.devices.chassis, []) : local.map_chassis["${domain.name}:${chassis.name}"].id if try(chassis.deploy, false)
      ]
    } : k => { device_id_list = v } if var.manage_deployment && length(v) > 0
  }

  domain          = each.key
  device_id_list  = each.value.device_id_list
  ignore_warning  = try(local.fmc.system.deployment.ignore_warning, local.defaults.fmc.domains.devices.devices.deploy_ignore_warning, null)
  deployment_note = try(local.fmc.system.deployment.deployment_note, local.defaults.fmc.domains.devices.devices.deploy_deployment_note, null)

  depends_on = [
    fmc_chassis_physical_interface.chassis_physical_interface,
    fmc_chassis_etherchannel_interface.chassis_etherchannel_interface,
    fmc_chassis_subinterface.chassis_subinterface,
  ]
}
