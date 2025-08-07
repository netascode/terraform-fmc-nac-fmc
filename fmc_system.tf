##########################################################
###    Content of the file:
##########################################################
#
###
#  Resources
####
# resource "fmc_smart_license" "module" {
# resource "fmc_policy_assignment" "access_control_policy" {
# resource "fmc_device_deploy" "module" {
#
###  
#  Local variables
###
# local.resource_smart_license
# local.resource_policy_assignments_acp
# local.resource_deploy
#


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

resource "fmc_smart_license" "module" {
  for_each = try(local.resource_smart_license.license.registration_type, null) != null ? local.resource_smart_license : {}

  # Mandatory
  registration_type = each.value.registration_type

  # Optional
  token               = each.value.token
  retain_registration = each.value.retain_registration
  force               = each.value.force
}


##########################################################
###    POLICY ASSIGNMENT
##########################################################
locals {
  resource_policy_assignments_acp = { for item in flatten([
    for acp_policy_key, acp_policy_value in local.map_access_control_policies : {
      policy_id               = acp_policy_value.id
      policy_name             = acp_policy_key
      policy_type             = "AccessPolicy"
      after_destroy_policy_id = try(local.map_access_control_policies[local.fmc.system.policy_assignment.after_destroy_policy].id, null)
      targets = flatten([
        for domain in local.domains : [
          for device in try(domain.devices.devices, []) : [
            {
              id   = local.map_devices[device.name].id
              type = local.map_devices[device.name].type
              name = device.name
            }
          ] if try(device.access_policy, null) == acp_policy_key && !contains(try(keys(local.resource_device), []), device.name)
        ]

      ])
    }
    ]) : item.policy_name => item if length(item.targets) > 0
  }

}

resource "fmc_policy_assignment" "access_control_policy" {
  for_each = local.resource_policy_assignments_acp

  policy_id               = each.value.policy_id
  policy_type             = each.value.policy_type
  after_destroy_policy_id = each.value.after_destroy_policy_id
  targets                 = each.value.targets

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    fmc_access_control_policy.module,
    data.fmc_access_control_policy.module,
  ]
}


##########################################################
###    Deploy
##########################################################

locals {
  resource_deploy = { for item in flatten([
    for domain in local.domains : {
      domain_name    = domain.name
      ignore_warning = try(local.fmc.system.deployment.ignore_warning, null)
      #version    = null
      deployment_note = try(local.fmc.system.deployment.deployment_note, null)
      device_id_list = flatten([for device in try(domain.devices.devices, []) : [local.map_devices[device.name].id] if try(device.deploy, false) && var.manage_deployment
      ])
    }
    ]) : item.domain_name => item if length(item.device_id_list) > 0
  }
}

resource "fmc_device_deploy" "module" {
  for_each = local.resource_deploy
  # Mandatory  
  device_id_list = each.value.device_id_list
  # Optional      
  ignore_warning  = each.value.ignore_warning
  deployment_note = each.value.deployment_note
  domain          = each.value.domain_name

  depends_on = [
    fmc_device.module,
    data.fmc_device.module,
    fmc_device_physical_interface.module,
    data.fmc_device_physical_interface.module,
    fmc_device_etherchannel_interface.module,
    data.fmc_device_etherchannel_interface.module,
    fmc_device_subinterface.module,
    data.fmc_device_subinterface.module,
    fmc_device_ha_pair.module,
    data.fmc_device_ha_pair.module,
    fmc_device_ha_pair_monitoring.module,
    fmc_device_cluster.module,
    data.fmc_device_cluster.module,
    fmc_policy_assignment.access_control_policy,
  ]

}