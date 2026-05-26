# Pre-resolution maps
# Each `resolved_*` is keyed: domain.name -> { object_name -> { id, type } } with
# the parent-domain entry winning on collision (matches the prior concat()[0] behavior).
# The underlying source maps live in fmc_*_maps.tf.
locals {
  resolved_network_objects = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_network_objects :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_network_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_network_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_network_objects_and_groups = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_network_groups[domain_name],
      local.resolved_network_objects[domain_name],
    )
  }

  # External network groups only (config-defined, no resource/data dependency).
  resolved_network_groups_external = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_network_groups_external :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  # Per-domain view of pre-existing FMC network groups (data source).
  resolved_data_network_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) :
      { for k, v in try(data.fmc_network_groups.network_groups[dp].items, {}) : k => { id = v.id, type = v.type } }
    ]...)
  }

  # Per-domain views of prior-level network group outputs (defined in fmc_objects.tf).
  resolved_prior_ng_objects_l1 = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.prior_ng_objects_l1 :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_prior_ng_objects_l2 = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.prior_ng_objects_l2 :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  # Composite candidate maps for network_group object membership lookup.
  # Source-priority via merge order (last wins): network_objects > data_ng > prior_ng > external.
  # Within each source, parent-domain entry wins (matches prior concat-of-related_domains[0] behavior).
  resolved_ng_members_l0 = {
    for d in keys(local.related_domains) : d => merge(
      local.resolved_network_groups_external[d],
      local.resolved_data_network_groups[d],
      local.resolved_network_objects[d],
    )
  }

  resolved_ng_members_l1 = {
    for d in keys(local.related_domains) : d => merge(
      local.resolved_network_groups_external[d],
      local.resolved_prior_ng_objects_l1[d],
      local.resolved_data_network_groups[d],
      local.resolved_network_objects[d],
    )
  }

  resolved_ng_members_l2 = {
    for d in keys(local.related_domains) : d => merge(
      local.resolved_network_groups_external[d],
      local.resolved_prior_ng_objects_l2[d],
      local.resolved_data_network_groups[d],
      local.resolved_network_objects[d],
    )
  }

  resolved_services = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_services :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_port_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_port_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_services_and_port_groups = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_port_groups[domain_name],
      local.resolved_services[domain_name],
    )
  }

  resolved_dynamic_objects = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_dynamic_objects :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_sgts = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_sgts :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_application_filters = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_application_filters :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_security_zones = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_security_zones :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_interface_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_interface_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_security_zones_and_interface_groups = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_interface_groups[domain_name],
      local.resolved_security_zones[domain_name],
    )
  }

  resolved_urls = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_urls :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_url_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_url_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_urls_and_url_groups = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_url_groups[domain_name],
      local.resolved_urls[domain_name],
    )
  }

  resolved_vlan_tags = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_vlan_tags :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_vlan_tag_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_vlan_tag_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_vlan_tags_and_groups = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_vlan_tag_groups[domain_name],
      local.resolved_vlan_tags[domain_name],
    )
  }

  resolved_time_ranges = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_time_ranges :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_tunnel_zones = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_tunnel_zones :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_geolocations = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_geolocation_sources :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_hosts = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_hosts :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ipv4_address_pools = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ipv4_address_pools :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ipv6_address_pools = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ipv6_address_pools :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_standard_access_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_standard_access_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_extended_access_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_extended_access_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_access_lists = {
    for domain_name in keys(local.related_domains) :
    domain_name => merge(
      local.resolved_standard_access_lists[domain_name],
      local.resolved_extended_access_lists[domain_name],
    )
  }

  resolved_ipv4_prefix_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ipv4_prefix_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ipv6_prefix_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ipv6_prefix_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_as_paths = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_as_paths :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_community_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_community_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_extended_community_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_extended_community_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_policy_lists = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_policy_lists :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_certificate_enrollments = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_certificate_enrollments :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_secure_client_profiles = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_secure_client_profiles :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_secure_client_custom_attributes = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_secure_client_custom_attributes :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ad_ldap_realms = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ad_ldap_realms :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_route_maps = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_route_maps :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_bfd_templates = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_bfd_templates :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_trusted_certificate_authorities = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_trusted_certificate_authorities :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ikev1_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ikev1_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ikev2_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ikev2_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ikev1_ipsec_proposals = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ikev1_ipsec_proposals :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_ikev2_ipsec_proposals = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_ikev2_ipsec_proposals :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_secure_client_images = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_secure_client_images :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_secure_client_customizations = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_secure_client_customizations :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_service_accesses = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_service_accesses :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_group_policies = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_group_policies :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_radius_server_groups = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_radius_server_groups :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_single_sign_on_servers = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_single_sign_on_servers :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_certificate_maps = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_certificate_maps :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_local_realms = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_local_realms :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }
}
