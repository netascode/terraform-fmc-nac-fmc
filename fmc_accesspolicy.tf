###
# ACCESS POLICY
###
locals {
  res_accesspolicies = flatten([
    for domains in local.domain : [
      for object in try(domains.accesspolicy, {}) : object if !contains(local.data_accesspolicies, object.name)
    ]
  ])
}

resource "fmc_access_policies" "accesspolicy" {
  for_each = { for accesspolicy in local.res_accesspolicies : accesspolicy.name => accesspolicy }

  # Mandatory
  name = each.value.name

  # Optional
  description                             = try(each.value.description, local.defaults.fmc.domain.accesspolicy.description, null)
  default_action                          = try(each.value.default_action, local.defaults.fmc.domain.accesspolicy.default_action, null)
  default_action_base_intrusion_policy_id = try(local.map_ipspolicies[each.value.base_ips_policy].id, local.map_ipspolicies[local.defaults.fmc.domain.accesspolicy.base_ips_policy].id, null)
  default_action_send_events_to_fmc       = try(each.value.send_events_to_fmc, local.defaults.fmc.domain.accesspolicy.send_events_to_fmc, null)
  default_action_log_begin                = try(each.value.log_begin, local.defaults.fmc.domain.accesspolicy.log_begin, null)
  default_action_log_end                  = try(each.value.log_end, local.defaults.fmc.domain.accesspolicy.log_end, null)
  default_action_syslog_config_id         = try(each.value.syslog_config_id, local.defaults.fmc.domain.accesspolicy.syslog_config_id, null)
}

###
# ACCESS POLICY CATEGORY
###
locals {
  res_accesspolicies_category = flatten([
    for domain in local.domain : [
      for accesspolicy in try(domain.accesspolicy, {}) : [
        for accesspolicy_category in try(accesspolicy.category, {}) : {
          key  = "${accesspolicy.name}/${accesspolicy_category}"
          acp  = local.map_accesspolicies[accesspolicy.name].id
          data = accesspolicy_category
        }
      ]
    ]
  ])
}

resource "fmc_access_policies_category" "accesspolicy_category" {
  for_each = { for accesspolicy_category in local.res_accesspolicies_category : accesspolicy_category.key => accesspolicy_category }

  # Mandatory
  name             = each.value.data
  access_policy_id = each.value.acp
}

###
# ACCESS RULE
###
locals {
  res_accessrules = flatten([
    for domain in local.domain : [
      for accesspolicy in try(domain.accesspolicy, {}) : [
        for accessrule in try(accesspolicy.accessrule, {}) : {
          key  = replace("${accesspolicy.name}_${accessrule.name}", " ", "")
          acp  = accesspolicy.name
          data = accessrule
        }
      ]
    ]
  ])

  unique_acps = distinct([for v in local.res_accessrules : v.acp])
  accessrules_by_acp = { for k in local.unique_acps :
    k => [for v in local.res_accessrules : v if v.acp == k]
  }
  accessrules_by_acp_prev = { for k in local.unique_acps :
    k => concat([""], [for v in local.res_accessrules : v.key if v.acp == k])
  }

  accessrules_template = {
    acps          = local.accessrules_by_acp,
    previous      = local.accessrules_by_acp_prev,
    defaults      = try(local.defaults.fmc.domain.accesspolicy.accessrule, {})
    networkgroups = local.res_networkgroups
  }
}

resource "local_file" "access_rule" {
  content = replace(
    templatefile("${path.module}/fmc_tpl_accessrule.tftpl", local.accessrules_template),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "${path.module}/generated_fmc_accessrule.tf"
}
