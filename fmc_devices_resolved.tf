# Pre-resolution maps
# Each `resolved_*` is keyed: domain.name -> { object_name -> { id, type } } with
# the parent-domain entry winning on collision (matches the prior concat()[0] behavior).
# The underlying source maps live in fmc_*_maps.tf.
locals {
  resolved_resource_profiles = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_resource_profiles :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_devices = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_devices :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }
}
