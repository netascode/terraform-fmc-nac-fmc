######
### map_access_control_policies
######
locals {
  map_access_control_policies_internal = merge(

    # Access Policy - individual mode outputs
    { for key, resource in fmc_access_control_policy.access_control_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # Access Policy - data source
    { for key, data in data.fmc_access_control_policy.access_control_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )

  map_access_control_policies_external = {
    for key, value in try(local.data.policies.access_control_policies, {}) : key => value
  }

  map_access_control_policies = merge(
    local.map_access_control_policies_internal,
    local.map_access_control_policies_external,
  )
}

######
### map_ftd_nat_policies
######
locals {
  map_ftd_nat_policies_internal = merge(

    # FTD NAT Policy - individual mode outputs
    { for key, resource in fmc_ftd_nat_policy.ftd_nat_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # FTD NAT Policy - data source
    { for key, data in data.fmc_ftd_nat_policy.ftd_nat_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )

  map_ftd_nat_policies_external = {
    for key, value in try(local.data.policies.ftd_nat_policies, {}) : key => value
  }

  map_ftd_nat_policies = merge(
    local.map_ftd_nat_policies_internal,
    local.map_ftd_nat_policies_external,
  )
}

######
### map_intrusion_policies
######
locals {
  map_intrusion_policies_internal = merge(

    # Intrusion Policy - individual mode outputs
    { for key, resource in fmc_intrusion_policy.intrusion_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Intrusion Policy L2 - individual mode outputs
    { for key, resource in fmc_intrusion_policy.intrusion_policy_l2 : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Intrusion Policy - data source
    { for key, data in data.fmc_intrusion_policy.intrusion_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  map_intrusion_policies_external = {
    for key, value in try(local.data.policies.intrusion_policies, {}) : key => value
  }

  map_intrusion_policies = merge(
    local.map_intrusion_policies_internal,
    local.map_intrusion_policies_external,
  )
}

######
### map_file_policies
######
locals {
  map_file_policies_internal = merge(

    # File Policy - individual mode outputs
    { for key, resource in fmc_file_policy.file_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # File Policy - data source
    { for key, data in data.fmc_file_policy.file_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  map_file_policies_external = {
    for key, value in try(local.data.policies.file_policies, {}) : key => value
  }

  map_file_policies = merge(
    local.map_file_policies_internal,
    local.map_file_policies_external,
  )
}

######
### map_network_analysis_policies
######

locals {
  map_network_analysis_policies_internal = merge(

    # Network Analysis Policy - individual mode outputs
    { for key, resource in fmc_network_analysis_policy.network_analysis_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Network Analysis Policy - data source
    { for key, data in data.fmc_network_analysis_policy.network_analysis_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  map_network_analysis_policies_external = {
    for key, value in try(local.data.policies.network_analysis_policies, {}) : key => value
  }

  map_network_analysis_policies = merge(
    local.map_network_analysis_policies_internal,
    local.map_network_analysis_policies_external,
  )
}

######
### map_prefilter_policies
######
locals {
  map_prefilter_policies_internal = merge(

    # Prefilter Policy - individual mode outputs
    { for key, resource in fmc_prefilter_policy.prefilter_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },

    # Prefilter Policy - data source
    { for key, data in data.fmc_prefilter_policy.prefilter_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type } },
  )

  map_prefilter_policies_external = {
    for key, value in try(local.data.policies.prefilter_policies, {}) : key => value
  }

  map_prefilter_policies = merge(
    local.map_prefilter_policies_internal,
    local.map_prefilter_policies_external,
  )
}

######
### map_health_policies
######
locals {
  map_health_policies_internal = merge(

    # Health Policy - individual mode outputs
    { for key, resource in fmc_health_policy.health_policy : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type, domain = resource.domain, name = resource.name } },

    # Health Policy - data source
    { for key, data in data.fmc_health_policy.health_policy : "${data.domain}:${data.name}" => { id = data.id, type = data.type, domain = data.domain, name = data.name } },
  )

  map_health_policies_external = {
    for key, value in try(local.data.policies.health_policies, {}) : key => value
  }

  map_health_policies = merge(
    local.map_health_policies_internal,
    local.map_health_policies_external,
  )
}
