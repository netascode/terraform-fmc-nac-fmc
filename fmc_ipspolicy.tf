###
# IPS POLICY
###
locals {
  res_ipspolicies = flatten([
    for domains in local.domain : [
      for object in try(domains.ipspolicy, []) : object
    ]
  ])
}

resource "fmc_ips_policies" "ips_policy" {
  for_each = { for ipspolicy in local.res_ipspolicies : ipspolicy.name => ipspolicy }

  # Mandatory  
  name = each.value.name

  # Optional  
  inspection_mode = try(each.value.inspection_mode, local.defaults.fmc.domain.ipspolicy.inspection_mode, null)
  basepolicy_id   = try(data.fmc_ips_policies.ips_policy[each.value.base_policy].id, null)
}