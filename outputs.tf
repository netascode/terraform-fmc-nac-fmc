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
    "hosts"          = local.map_hosts_internal,
    "networks"       = local.map_networks_internal,
    "ranges"         = local.map_ranges_internal,
    "fqdns"          = local.map_fqdns_internal,
    "network_groups" = local.map_network_group_objects, ## TODO: Rename to map_network_groups / Unify naming
  }
}
