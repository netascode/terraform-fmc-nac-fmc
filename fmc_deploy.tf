###
# DEPLOY
###
locals {
  res_deploy = flatten([
    for domains in local.domains : [
      for object in try(domains.devices, []) : {
        device                = object.name
        deploy_ignore_warning = try(object.deploy_ignore_warning, local.defaults.fmc.domains.devices.deploy_ignore_warning, null)
        deploy_force          = try(object.deploy_force, local.defaults.fmc.domains.devices.deploy_force, null)
      } if try(object.deploy, false) && var.deploy_support
    ]
  ])
}
resource "fmc_ftd_deploy" "ftd" {
  for_each = { for deploymemt in local.res_deploy : deploymemt.device => deploymemt }
  # Mandatory  
  device = local.map_devices[each.value.device].id
  # Optional      
  ignore_warning = each.value.deploy_ignore_warning
  force_deploy   = each.value.deploy_force
  depends_on = [
    fmc_access_policies.accesspolicy,
    fmc_device_physical_interfaces.physical_interface,
    fmc_device_subinterfaces.sub_interfaces,
    fmc_devices.device,
    fmc_device_cluster.cluster,
    fmc_dynamic_objects.dynamicobject,
    fmc_fqdn_objects.fqdn,
    fmc_ftd_autonat_rules.ftdautonatrule,
    fmc_ftd_nat_policies.ftdnatpolicy,
    fmc_host_objects.host,
    fmc_icmpv4_objects.icmpv4,
    fmc_ips_policies.ips_policy,
    fmc_network_objects.network,
    fmc_policy_devices_assignments.policy_assignment,
    fmc_port_objects.port,
    fmc_prefilter_policy.prefilterpolicy,
    fmc_range_objects.range,
    fmc_security_zone.securityzone,
    fmc_staticIPv4_route.ipv4staticroute,
    fmc_url_objects.url,
    fmc_access_rules.access_rule_0,
    fmc_ftd_manualnat_rules.manualnat_rules_0,
    fmc_access_rules.access_rule_1,
    fmc_ftd_manualnat_rules.manualnat_rules_1,
    fmc_access_rules.access_rule_2,
    fmc_ftd_manualnat_rules.manualnat_rules_2,
    fmc_access_rules.access_rule_3,
    fmc_ftd_manualnat_rules.manualnat_rules_3,
    fmc_access_rules.access_rule_4,
    fmc_ftd_manualnat_rules.manualnat_rules_4,
    fmc_access_rules.access_rule_5,
    fmc_ftd_manualnat_rules.manualnat_rules_5,
    fmc_access_rules.access_rule_6,
    fmc_ftd_manualnat_rules.manualnat_rules_6,
    fmc_access_rules.access_rule_7,
    fmc_ftd_manualnat_rules.manualnat_rules_7,
    fmc_access_rules.access_rule_8,
    fmc_ftd_manualnat_rules.manualnat_rules_8,
    fmc_access_rules.access_rule_9,
    fmc_ftd_manualnat_rules.manualnat_rules_9,
    fmc_access_rules.access_rule_10,
    fmc_ftd_manualnat_rules.manualnat_rules_10,
    fmc_access_rules.access_rule_11,
    fmc_ftd_manualnat_rules.manualnat_rules_11,
    fmc_access_rules.access_rule_12,
    fmc_ftd_manualnat_rules.manualnat_rules_12,
    fmc_access_rules.access_rule_13,
    fmc_ftd_manualnat_rules.manualnat_rules_13,
    fmc_access_rules.access_rule_14,
    fmc_ftd_manualnat_rules.manualnat_rules_14,
    fmc_access_rules.access_rule_15,
    fmc_ftd_manualnat_rules.manualnat_rules_15,
    fmc_access_rules.access_rule_16,
    fmc_ftd_manualnat_rules.manualnat_rules_16,
    fmc_access_rules.access_rule_17,
    fmc_ftd_manualnat_rules.manualnat_rules_17,
    fmc_access_rules.access_rule_18,
    fmc_ftd_manualnat_rules.manualnat_rules_18,
    fmc_access_rules.access_rule_19,
    fmc_ftd_manualnat_rules.manualnat_rules_19,
    fmc_access_rules.access_rule_20,
    fmc_ftd_manualnat_rules.manualnat_rules_20,
    fmc_access_rules.access_rule_21,
    fmc_ftd_manualnat_rules.manualnat_rules_21,
    fmc_access_rules.access_rule_22,
    fmc_ftd_manualnat_rules.manualnat_rules_22,
    fmc_access_rules.access_rule_23,
    fmc_ftd_manualnat_rules.manualnat_rules_23,
    fmc_access_rules.access_rule_24,
    fmc_ftd_manualnat_rules.manualnat_rules_24,
    fmc_access_rules.access_rule_25,
    fmc_ftd_manualnat_rules.manualnat_rules_25,
    fmc_access_rules.access_rule_26,
    fmc_ftd_manualnat_rules.manualnat_rules_26,
    fmc_access_rules.access_rule_27,
    fmc_ftd_manualnat_rules.manualnat_rules_27,
    fmc_access_rules.access_rule_28,
    fmc_ftd_manualnat_rules.manualnat_rules_28,
    fmc_access_rules.access_rule_29,
    fmc_ftd_manualnat_rules.manualnat_rules_29,
    fmc_network_group_objects.networkgroup_l5
  ]
}