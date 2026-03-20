output "default_values" {
  description = "All default values."
  value       = local.defaults
}

output "model" {
  description = "Full model."
  value       = local.model
}

output "objects" {
  description = "All objects."
  value = {
    "hosts"    = local.map_hosts,
    "networks" = local.map_networks,
    "ranges"   = local.map_ranges,
    "fqdns"    = local.map_fqdns,
    "network_groups" = merge(
      local.map_network_group_objects,  ## TODO: Rename to map_network_groups
      local.map_network_groups_external ## TODO: Those two would need to be merged earlier, as merged version will be needed for reference in other objects (e.g. access rules)
    )
  }
}
