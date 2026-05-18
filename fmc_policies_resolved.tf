# Pre-resolution maps
# Each `resolved_*` is keyed: domain.name -> { object_name -> { id, type } } with
# the parent-domain entry winning on collision (matches the prior concat()[0] behavior).
# The underlying source maps live in fmc_*_maps.tf.
locals {
  resolved_file_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_file_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_intrusion_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_intrusion_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_prefilter_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_prefilter_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_access_control_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_access_control_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_health_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_health_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ftd_nat_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ftd_nat_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ftd_platform_settings = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ftd_platform_settings :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }
}