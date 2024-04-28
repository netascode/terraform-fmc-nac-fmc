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
      } if try(object.deploy, false) && var.manage_deployment
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
    fmc_policy_devices_assignments.nat_policy_assignment,
    fmc_policy_devices_assignments.access_policy_assignment,
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
    fmc_access_rules.access_rule_30,
    fmc_ftd_manualnat_rules.manualnat_rules_30,
    fmc_access_rules.access_rule_31,
    fmc_ftd_manualnat_rules.manualnat_rules_31,
    fmc_access_rules.access_rule_32,
    fmc_ftd_manualnat_rules.manualnat_rules_32,
    fmc_access_rules.access_rule_33,
    fmc_ftd_manualnat_rules.manualnat_rules_33,
    fmc_access_rules.access_rule_34,
    fmc_ftd_manualnat_rules.manualnat_rules_34,
    fmc_access_rules.access_rule_35,
    fmc_ftd_manualnat_rules.manualnat_rules_35,
    fmc_access_rules.access_rule_36,
    fmc_ftd_manualnat_rules.manualnat_rules_36,
    fmc_access_rules.access_rule_37,
    fmc_ftd_manualnat_rules.manualnat_rules_37,
    fmc_access_rules.access_rule_38,
    fmc_ftd_manualnat_rules.manualnat_rules_38,
    fmc_access_rules.access_rule_39,
    fmc_ftd_manualnat_rules.manualnat_rules_39,
    fmc_access_rules.access_rule_40,
    fmc_ftd_manualnat_rules.manualnat_rules_40,
    fmc_access_rules.access_rule_41,
    fmc_ftd_manualnat_rules.manualnat_rules_41,
    fmc_access_rules.access_rule_42,
    fmc_ftd_manualnat_rules.manualnat_rules_42,
    fmc_access_rules.access_rule_43,
    fmc_ftd_manualnat_rules.manualnat_rules_43,
    fmc_access_rules.access_rule_44,
    fmc_ftd_manualnat_rules.manualnat_rules_44,
    fmc_access_rules.access_rule_45,
    fmc_ftd_manualnat_rules.manualnat_rules_45,
    fmc_access_rules.access_rule_46,
    fmc_ftd_manualnat_rules.manualnat_rules_46,
    fmc_access_rules.access_rule_47,
    fmc_ftd_manualnat_rules.manualnat_rules_47,
    fmc_access_rules.access_rule_48,
    fmc_ftd_manualnat_rules.manualnat_rules_48,
    fmc_access_rules.access_rule_49,
    fmc_ftd_manualnat_rules.manualnat_rules_49,
    fmc_access_rules.access_rule_50,
    fmc_ftd_manualnat_rules.manualnat_rules_50,
    fmc_access_rules.access_rule_51,
    fmc_ftd_manualnat_rules.manualnat_rules_51,
    fmc_access_rules.access_rule_52,
    fmc_ftd_manualnat_rules.manualnat_rules_52,
    fmc_access_rules.access_rule_53,
    fmc_ftd_manualnat_rules.manualnat_rules_53,
    fmc_access_rules.access_rule_54,
    fmc_ftd_manualnat_rules.manualnat_rules_54,
    fmc_access_rules.access_rule_55,
    fmc_ftd_manualnat_rules.manualnat_rules_55,
    fmc_access_rules.access_rule_56,
    fmc_ftd_manualnat_rules.manualnat_rules_56,
    fmc_access_rules.access_rule_57,
    fmc_ftd_manualnat_rules.manualnat_rules_57,
    fmc_access_rules.access_rule_58,
    fmc_ftd_manualnat_rules.manualnat_rules_58,
    fmc_access_rules.access_rule_59,
    fmc_ftd_manualnat_rules.manualnat_rules_59,
    fmc_access_rules.access_rule_60,
    fmc_ftd_manualnat_rules.manualnat_rules_60,
    fmc_access_rules.access_rule_61,
    fmc_ftd_manualnat_rules.manualnat_rules_61,
    fmc_access_rules.access_rule_62,
    fmc_ftd_manualnat_rules.manualnat_rules_62,
    fmc_access_rules.access_rule_63,
    fmc_ftd_manualnat_rules.manualnat_rules_63,
    fmc_access_rules.access_rule_64,
    fmc_ftd_manualnat_rules.manualnat_rules_64,
    fmc_access_rules.access_rule_65,
    fmc_ftd_manualnat_rules.manualnat_rules_65,
    fmc_access_rules.access_rule_66,
    fmc_ftd_manualnat_rules.manualnat_rules_66,
    fmc_access_rules.access_rule_67,
    fmc_ftd_manualnat_rules.manualnat_rules_67,
    fmc_access_rules.access_rule_68,
    fmc_ftd_manualnat_rules.manualnat_rules_68,
    fmc_access_rules.access_rule_69,
    fmc_ftd_manualnat_rules.manualnat_rules_69,
    fmc_access_rules.access_rule_70,
    fmc_ftd_manualnat_rules.manualnat_rules_70,
    fmc_access_rules.access_rule_71,
    fmc_ftd_manualnat_rules.manualnat_rules_71,
    fmc_access_rules.access_rule_72,
    fmc_ftd_manualnat_rules.manualnat_rules_72,
    fmc_access_rules.access_rule_73,
    fmc_ftd_manualnat_rules.manualnat_rules_73,
    fmc_access_rules.access_rule_74,
    fmc_ftd_manualnat_rules.manualnat_rules_74,
    fmc_access_rules.access_rule_75,
    fmc_ftd_manualnat_rules.manualnat_rules_75,
    fmc_access_rules.access_rule_76,
    fmc_ftd_manualnat_rules.manualnat_rules_76,
    fmc_access_rules.access_rule_77,
    fmc_ftd_manualnat_rules.manualnat_rules_77,
    fmc_access_rules.access_rule_78,
    fmc_ftd_manualnat_rules.manualnat_rules_78,
    fmc_access_rules.access_rule_79,
    fmc_ftd_manualnat_rules.manualnat_rules_79,
    fmc_access_rules.access_rule_80,
    fmc_ftd_manualnat_rules.manualnat_rules_80,
    fmc_access_rules.access_rule_81,
    fmc_ftd_manualnat_rules.manualnat_rules_81,
    fmc_access_rules.access_rule_82,
    fmc_ftd_manualnat_rules.manualnat_rules_82,
    fmc_access_rules.access_rule_83,
    fmc_ftd_manualnat_rules.manualnat_rules_83,
    fmc_access_rules.access_rule_84,
    fmc_ftd_manualnat_rules.manualnat_rules_84,
    fmc_access_rules.access_rule_85,
    fmc_ftd_manualnat_rules.manualnat_rules_85,
    fmc_access_rules.access_rule_86,
    fmc_ftd_manualnat_rules.manualnat_rules_86,
    fmc_access_rules.access_rule_87,
    fmc_ftd_manualnat_rules.manualnat_rules_87,
    fmc_access_rules.access_rule_88,
    fmc_ftd_manualnat_rules.manualnat_rules_88,
    fmc_access_rules.access_rule_89,
    fmc_ftd_manualnat_rules.manualnat_rules_89,
    fmc_access_rules.access_rule_90,
    fmc_ftd_manualnat_rules.manualnat_rules_90,
    fmc_access_rules.access_rule_91,
    fmc_ftd_manualnat_rules.manualnat_rules_91,
    fmc_access_rules.access_rule_92,
    fmc_ftd_manualnat_rules.manualnat_rules_92,
    fmc_access_rules.access_rule_93,
    fmc_ftd_manualnat_rules.manualnat_rules_93,
    fmc_access_rules.access_rule_94,
    fmc_ftd_manualnat_rules.manualnat_rules_94,
    fmc_access_rules.access_rule_95,
    fmc_ftd_manualnat_rules.manualnat_rules_95,
    fmc_access_rules.access_rule_96,
    fmc_ftd_manualnat_rules.manualnat_rules_96,
    fmc_access_rules.access_rule_97,
    fmc_ftd_manualnat_rules.manualnat_rules_97,
    fmc_access_rules.access_rule_98,
    fmc_ftd_manualnat_rules.manualnat_rules_98,
    fmc_access_rules.access_rule_99,
    fmc_ftd_manualnat_rules.manualnat_rules_99,
    fmc_network_group_objects.networkgroup_l5
  ]
}