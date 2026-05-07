locals {
  yaml_strings_directories = flatten([
    for dir in var.yaml_directories : [
      # Make sure the file that might have been produced in previous runs is not included in the input
      for file in fileset(".", "${dir}/*.{yml,yaml}") : file(file) if abspath(file) != abspath(var.write_objects_file)
    ]
  ])
  yaml_strings_files = [
    # Make sure the file that might have been produced in previous runs is not included in the input
    for file in var.yaml_files : file(file) if abspath(file) != abspath(var.write_objects_file)
  ]
  model_strings   = length(keys(var.model)) != 0 ? [yamlencode(var.model)] : []
  model_string    = provider::utils::yaml_merge(concat(local.yaml_strings_directories, local.yaml_strings_files, local.model_strings))
  model           = yamldecode(local.model_string)
  user_defaults   = { "defaults" : try(local.model["defaults"], {}) }
  defaults_string = provider::utils::yaml_merge([file("${path.module}/defaults/defaults.yaml"), yamlencode(local.user_defaults)])
  defaults        = yamldecode(local.defaults_string)["defaults"]
}

resource "terraform_data" "validation" {
  lifecycle {
    precondition {
      condition     = length(var.yaml_directories) != 0 || length(var.yaml_files) != 0 || length(keys(var.model)) != 0
      error_message = "Either `yaml_directories`,`yaml_files` or a non-empty `model` value must be provided."
    }
  }
}

resource "local_sensitive_file" "defaults" {
  count    = var.write_default_values_file != "" ? 1 : 0
  content  = local.defaults_string
  filename = var.write_default_values_file
}

resource "local_sensitive_file" "objects" {
  count    = var.write_objects_file != "" ? 1 : 0
  filename = var.write_objects_file
  content = yamlencode({
    "data" : {
      "fmc" : {
        "objects" : merge(
          length(local.map_hosts_internal) > 0 ? { "hosts" : local.map_hosts_internal } : {},
          length(local.map_networks_internal) > 0 ? { "networks" : local.map_networks_internal } : {},
          length(local.map_ranges_internal) > 0 ? { "ranges" : local.map_ranges_internal } : {},
          length(local.map_fqdns_internal) > 0 ? { "fqdns" : local.map_fqdns_internal } : {},
          length(local.map_network_groups_internal) > 0 ? { "network_groups" : local.map_network_groups_internal } : {},
          length(local.map_services_internal) > 0 ? { "services" : local.map_services_internal } : {},
          length(local.map_port_groups_internal) > 0 ? { "port_groups" : local.map_port_groups_internal } : {},
          length(local.map_dynamic_objects_internal) > 0 ? { "dynamic_objects" : local.map_dynamic_objects_internal } : {},
          length(local.map_urls_internal) > 0 ? { "urls" : local.map_urls_internal } : {},
          length(local.map_url_groups_internal) > 0 ? { "url_groups" : local.map_url_groups_internal } : {},
          length(local.map_vlan_tags_internal) > 0 ? { "vlan_tags" : local.map_vlan_tags_internal } : {},
          length(local.map_vlan_tag_groups_internal) > 0 ? { "vlan_tag_groups" : local.map_vlan_tag_groups_internal } : {},
          length(local.map_sgts_internal) > 0 ? { "sgts" : local.map_sgts_internal } : {},
          length(local.map_tunnel_zones_internal) > 0 ? { "tunnel_zones" : local.map_tunnel_zones_internal } : {},
          length(local.map_security_zones_internal) > 0 ? { "security_zones" : local.map_security_zones_internal } : {},
          length(local.map_interface_groups_internal) > 0 ? { "interface_groups" : local.map_interface_groups_internal } : {},
          length(local.map_application_filters_internal) > 0 ? { "application_filters" : local.map_application_filters_internal } : {},
          length(local.map_time_ranges_internal) > 0 ? { "time_ranges" : local.map_time_ranges_internal } : {},
          length(local.map_ipv4_address_pools_internal) > 0 ? { "ipv4_address_pools" : local.map_ipv4_address_pools_internal } : {},
          length(local.map_ipv6_address_pools_internal) > 0 ? { "ipv6_address_pools" : local.map_ipv6_address_pools_internal } : {},
          length(local.map_resource_profiles_internal) > 0 ? { "resource_profiles" : local.map_resource_profiles_internal } : {},
          length(local.map_as_paths_internal) > 0 ? { "as_paths" : local.map_as_paths_internal } : {},
          length(local.map_standard_access_lists_internal) > 0 ? { "standard_access_lists" : local.map_standard_access_lists_internal } : {},
          length(local.map_extended_access_lists_internal) > 0 ? { "extended_access_lists" : local.map_extended_access_lists_internal } : {},
          length(local.map_bfd_templates_internal) > 0 ? { "bfd_templates" : local.map_bfd_templates_internal } : {},
          length(local.map_certificate_enrollments_internal) > 0 ? { "certificate_enrollments" : local.map_certificate_enrollments_internal } : {},
          length(local.map_certificate_maps_internal) > 0 ? { "certificate_maps" : local.map_certificate_maps_internal } : {},
          length(local.map_community_lists_internal) > 0 ? { "community_lists" : local.map_community_lists_internal } : {},
          length(local.map_extended_community_lists_internal) > 0 ? { "extended_community_lists" : local.map_extended_community_lists_internal } : {},
          length(local.map_geolocation_sources_internal) > 0 ? { "geolocation_sources" : local.map_geolocation_sources_internal } : {},
          length(local.map_group_policies_internal) > 0 ? { "group_policies" : local.map_group_policies_internal } : {},
          length(local.map_ikev1_ipsec_proposals_internal) > 0 ? { "ikev1_ipsec_proposals" : local.map_ikev1_ipsec_proposals_internal } : {},
          length(local.map_ikev1_policies_internal) > 0 ? { "ikev1_policies" : local.map_ikev1_policies_internal } : {},
          length(local.map_ikev2_ipsec_proposals_internal) > 0 ? { "ikev2_ipsec_proposals" : local.map_ikev2_ipsec_proposals_internal } : {},
          length(local.map_ikev2_policies_internal) > 0 ? { "ikev2_policies" : local.map_ikev2_policies_internal } : {},
          length(local.map_ipv4_prefix_lists_internal) > 0 ? { "ipv4_prefix_lists" : local.map_ipv4_prefix_lists_internal } : {},
          length(local.map_ipv6_prefix_lists_internal) > 0 ? { "ipv6_prefix_lists" : local.map_ipv6_prefix_lists_internal } : {},
          length(local.map_policy_lists_internal) > 0 ? { "policy_lists" : local.map_policy_lists_internal } : {},
          length(local.map_radius_server_groups_internal) > 0 ? { "radius_server_groups" : local.map_radius_server_groups_internal } : {},
          length(local.map_route_maps_internal) > 0 ? { "route_maps" : local.map_route_maps_internal } : {},
          length(local.map_secure_client_custom_attributes_internal) > 0 ? { "secure_client_custom_attributes" : local.map_secure_client_custom_attributes_internal } : {},
          length(local.map_secure_client_customizations_internal) > 0 ? { "secure_client_customizations" : local.map_secure_client_customizations_internal } : {},
          length(local.map_secure_client_images_internal) > 0 ? { "secure_client_images" : local.map_secure_client_images_internal } : {},
          length(local.map_secure_client_profiles_internal) > 0 ? { "secure_client_profiles" : local.map_secure_client_profiles_internal } : {},
          length(local.map_service_accesses_internal) > 0 ? { "service_accesses" : local.map_service_accesses_internal } : {},
          length(local.map_single_sign_on_servers_internal) > 0 ? { "single_sign_on_servers" : local.map_single_sign_on_servers_internal } : {},
          length(local.map_trusted_certificate_authorities_internal) > 0 ? { "trusted_certificate_authorities" : local.map_trusted_certificate_authorities_internal } : {},
          length(local.map_variable_sets_internal) > 0 ? { "variable_sets" : local.map_variable_sets_internal } : {},
        ),
        "policies" : merge(
          length(local.map_access_control_policies_internal) > 0 ? { "access_control_policies" : local.map_access_control_policies_internal } : {},
          length(local.map_ftd_nat_policies_internal) > 0 ? { "ftd_nat_policies" : local.map_ftd_nat_policies_internal } : {},
          length(local.map_intrusion_policies_internal) > 0 ? { "intrusion_policies" : local.map_intrusion_policies_internal } : {},
          length(local.map_file_policies_internal) > 0 ? { "file_policies" : local.map_file_policies_internal } : {},
          length(local.map_network_analysis_policies_internal) > 0 ? { "network_analysis_policies" : local.map_network_analysis_policies_internal } : {},
          length(local.map_prefilter_policies_internal) > 0 ? { "prefilter_policies" : local.map_prefilter_policies_internal } : {},
          length(local.map_health_policies_internal) > 0 ? { "health_policies" : local.map_health_policies_internal } : {},
          length(local.map_snmp_alerts_internal) > 0 ? { "snmp_alerts" : local.map_snmp_alerts_internal } : {},
          length(local.map_syslog_alerts_internal) > 0 ? { "syslog_alerts" : local.map_syslog_alerts_internal } : {},
        ),
        "devices" : merge(
          length(local.map_devices_internal) > 0 ? { "devices" : local.map_devices_internal } : {}
        ),
        "integrations" : merge(
          length(local.map_ad_ldap_realms_internal) > 0 ? { "ad_ldap_realms" : local.map_ad_ldap_realms_internal } : {},
          length(local.map_local_realms_internal) > 0 ? { "local_realms" : local.map_local_realms_internal } : {},
        ),
        "vpns" : merge(
          length(local.map_vpn_ra_internal) > 0 ? { "remote_access" : local.map_vpn_ra_internal } : {},
        ),
      }
    }
  })
}
