###
# PREFILTER POLICY
###
locals {
  res_prefilterpolicies = flatten([
    for domains in local.domains : [
      for object in try(domains.prefilter_policies, {}) : object
    ]
  ])
}

resource "fmc_prefilter_policy" "prefilterpolicy" {
  for_each = { for prefpolicy in local.res_prefilterpolicies : prefpolicy.name => prefpolicy }

  # Mandatory  
  name = each.value.name

  # Optional    
  default_action {
    #log_end           = try(each.value.log_end, null)         # Not supported by provider
    log_begin          = try(each.value.log_begin, null)
    send_events_to_fmc = try(each.value.send_events_to_fmc, null)
    action             = try(each.value.action, local.defaults.fmc.domains.prefilter_policies.action, "ANALYZE_TUNNELS")
  }

  description = try(each.value.description, local.defaults.fmc.domains.prefilter_policies.description, null)
}