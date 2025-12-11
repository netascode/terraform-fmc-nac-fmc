##########################################################
###    SMART LICENSE
##########################################################
locals {
  resource_smart_license = {
    license = {
      registration_type   = try(local.fmc.system.smart_license.registration_type, null)
      token               = try(local.fmc.system.smart_license.token, null)
      force               = try(local.fmc.system.smart_license.force, null)
      retain_registration = try(local.fmc.system.smart_license.retain, null)
    }
  }
}

resource "fmc_smart_license" "smart_license" {
  for_each = try(local.resource_smart_license.license.registration_type, null) != null ? local.resource_smart_license : {}

  registration_type   = each.value.registration_type
  token               = each.value.token
  retain_registration = each.value.retain_registration
  force               = each.value.force
}

##########################################################
###    POLICY ASSIGNMENT
##########################################################
locals {
  resource_policy_assignment_acp = { for item in flatten([
    for acp_policy_key, acp_policy_value in local.map_access_control_policies : {
      policy_domain           = acp_policy_value.domain
      policy_id               = acp_policy_value.id
      policy_name             = acp_policy_value.name
      policy_type             = acp_policy_value.type
      after_destroy_policy_id = try(local.map_access_control_policies["Global:${local.fmc.system.policy_assignment.after_destroy_access_control_policy}"].id, null)

      targets = flatten([
        for domain in local.domains : [
          for device in try(domain.devices.devices, []) : {
            id   = local.map_devices["${domain.name}:${device.name}"].id
            type = local.map_devices["${domain.name}:${device.name}"].type
            name = device.name
          } if try(device.access_control_policy, null) == acp_policy_value.name && contains(try(keys(local.data_device), []), "${domain.name}:${device.name}")
        ]
      ])
    }
    ]) : "${item.policy_domain}:${item.policy_name}" => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "access_control_policy" {
  for_each = local.resource_policy_assignment_acp

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    # fmc_device.module,
    # data.fmc_device.module,
    fmc_device_ha_pair.device_ha_pair,
    data.fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
    data.fmc_device_cluster.device_cluster,
    fmc_access_control_policy.access_control_policy,
    data.fmc_access_control_policy.access_control_policy
  ]
}

locals {
  resource_policy_assignments_health_policy = {
    for item in flatten([
      for health_policy_key, health_policy_value in local.map_health_policies : {
        policy_domain           = health_policy_value.domain
        policy_id               = health_policy_value.id
        policy_name             = health_policy_value.name
        policy_type             = health_policy_value.type
        after_destroy_policy_id = try(local.map_health_policies["Global:${local.fmc.system.policy_assignment.after_destroy_health_policy}"].id, null)

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.health_policy, null) == health_policy_value.name && !contains(try(keys(local.resource_device), []), "${domain.name}:${device.name}")
          ]
        ])
      }
    ]) : "${item.policy_domain}:${item.policy_name}" => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "health_policy" {
  for_each = local.resource_policy_assignments_health_policy

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    # fmc_device.module,
    # data.fmc_device.module,
    fmc_device_ha_pair.device_ha_pair,
    data.fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
    data.fmc_device_cluster.device_cluster,
    fmc_health_policy.health_policy,
    data.fmc_health_policy.health_policy,
  ]
}

locals {
  resource_policy_assignments_ftd_nat_policy = {
    for item in flatten([
      for ftd_nat_policy_key, ftd_nat_policy_value in local.map_ftd_nat_policies : {
        policy_domain           = ftd_nat_policy_value.domain
        policy_id               = ftd_nat_policy_value.id
        policy_name             = ftd_nat_policy_value.name
        policy_type             = ftd_nat_policy_value.type
        after_destroy_policy_id = null

        targets = flatten([
          for domain in local.domains : [
            for device in try(domain.devices.devices, []) : {
              id   = local.map_devices["${domain.name}:${device.name}"].id
              type = local.map_devices["${domain.name}:${device.name}"].type
              name = device.name
            } if try(device.nat_policy, null) == ftd_nat_policy_value.name && !contains(try(keys(local.resource_device), []), "${domain.name}:${device.name}")
          ]
        ])
      }
    ]) : "${item.policy_domain}:${item.policy_name}" => item if length(item.targets) > 0
  }
}

resource "fmc_policy_assignment" "ftd_nat_policy" {
  for_each = local.resource_policy_assignments_ftd_nat_policy

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    # fmc_device.module,
    # data.fmc_device.module,
    fmc_device_ha_pair.device_ha_pair,
    data.fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
    data.fmc_device_cluster.device_cluster,
    fmc_ftd_nat_policy.ftd_nat_policy,
    data.fmc_ftd_nat_policy.ftd_nat_policy,
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
    # fmc_device.module,
    # data.fmc_device.module,
    fmc_device_ha_pair.device_ha_pair,
    data.fmc_device_ha_pair.device_ha_pair,
    fmc_device_cluster.device_cluster,
    data.fmc_device_cluster.device_cluster,
    fmc_ftd_platform_settings.ftd_platform_settings,
    data.fmc_ftd_platform_settings.ftd_platform_settings,
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

##########################################################
###    DEPLOY
##########################################################
locals {
  resource_deploy = {
    for item in flatten([
      for domain in local.domains : {
        domain          = domain.name
        ignore_warning  = try(local.fmc.system.deployment.ignore_warning, local.defaults.fmc.domains.devices.devices.deploy_ignore_warning, null)
        deployment_note = try(local.fmc.system.deployment.deployment_note, local.defaults.fmc.domains.devices.devices.deploy_deployment_note, null)
        device_id_list = flatten([
          for device in try(domain.devices.devices, []) : [local.map_devices["${domain.name}:${device.name}"].id] if try(device.deploy, false)
        ])
      }
    ]) : item.domain => item if length(item.device_id_list) > 0
  }
}

resource "fmc_device_deploy" "device_deploy" {
  for_each = var.manage_deployment ? local.resource_deploy : {}

  domain          = each.value.domain
  device_id_list  = each.value.device_id_list
  ignore_warning  = each.value.ignore_warning
  deployment_note = each.value.deployment_note

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
    fmc_device_deploy.chassis_deploy,
  ]
}

locals {
  resource_deploy_chassis = {
    for item in flatten([
      for domain in local.domains : {
        domain          = domain.name
        ignore_warning  = try(local.fmc.system.deployment.ignore_warning, local.defaults.fmc.domains.devices.devices.deploy_ignore_warning, null)
        deployment_note = try(local.fmc.system.deployment.deployment_note, local.defaults.fmc.domains.devices.devices.deploy_deployment_note, null)
        device_id_list = flatten([
          for chassis in try(domain.devices.chassis, []) : [local.map_chassis["${domain.name}:${chassis.name}"].id] if try(chassis.deploy, false)
        ])
      }
    ]) : item.domain => item if length(item.device_id_list) > 0
  }
}

resource "fmc_device_deploy" "chassis_deploy" {
  for_each = var.manage_deployment ? local.resource_deploy_chassis : {}

  domain          = each.value.domain
  device_id_list  = each.value.device_id_list
  ignore_warning  = each.value.ignore_warning
  deployment_note = each.value.deployment_note

  depends_on = [
    fmc_chassis_physical_interface.chassis_physical_interface,
    fmc_chassis_etherchannel_interface.chassis_etherchannel_interface,
    fmc_chassis_subinterface.chassis_subinterface,
  ]
}
