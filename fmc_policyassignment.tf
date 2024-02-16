###
# POLICY ASSIGNMENT
###
locals {
  res_policyassignments = concat(
    flatten([
      for policyassignment in try(local.fmc.policy_assignments, []) : {
        device = policyassignment.device
        policy = policyassignment.nat_policy
        type   = "NAT"
      } if contains(keys(policyassignment), "nat_policy")
    ]),
    flatten([
      for policyassignment in try(local.fmc.policy_assignments, []) : {
        device = policyassignment.device
        policy = policyassignment.access_policy
        type   = "ACP"
      } if contains(keys(policyassignment), "access_policy")
    ])
  )
}

resource "fmc_policy_devices_assignments" "policy_assignment" {
  for_each = { for policyassignment in local.res_policyassignments : "${policyassignment.device}/${policyassignment.type}" => policyassignment }

  # Mandatory
  target_devices {
    id   = local.map_devices[each.value.device].id
    type = local.map_devices[each.value.device].type
  }

  policy {
    id   = try(local.map_accesspolicies[each.value.policy].id, local.map_natpolicies[each.value.policy].id)
    type = try(local.map_accesspolicies[each.value.policy].type, local.map_natpolicies[each.value.policy].type)
  }
}
