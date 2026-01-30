##########################################################
###    SITE TO SITE (S2S)
##########################################################
locals {
  data_vpn_s2s = {
    for item in flatten([
      for domain in local.data_existing : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          name   = vpn_s2s.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_vpn_s2s = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          domain           = domain.name
          name             = vpn_s2s.name
          network_topology = vpn_s2s.network_topology
          route_based      = vpn_s2s.route_based
          ikev1            = try(vpn_s2s.ikev1, local.defaults.vpns.site_to_site.ikev1, null)
          ikev2            = try(vpn_s2s.ikev2, local.defaults.vpns.site_to_site.ikev2, null)
        } if !contains(try(keys(local.data_vpn_s2s), {}), "${domain.name}:${vpn_s2s.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_vpn_s2s" "vpn_s2s" {
  for_each = local.data_vpn_s2s

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_vpn_s2s" "vpn_s2s" {
  for_each = local.resource_vpn_s2s

  domain           = each.value.domain
  name             = each.value.name
  network_topology = each.value.network_topology
  route_based      = each.value.route_based
  ikev1            = each.value.ikev1
  ikev2            = each.value.ikev2
}

##########################################################
###    SITE TO SITE (S2S) ENDPOINTS
##########################################################
locals {
  resource_vpn_s2s_endpoints = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          domain       = domain.name
          vpn_s2s_name = vpn_s2s.name
          vpn_s2s_id   = try(fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id, data.fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id)
          items = { for endpoint in vpn_s2s.endpoints : (endpoint.name) => {
            extranet_device             = endpoint.extranet_device
            peer_type                   = endpoint.peer_type
            allow_incoming_ikev2_routes = try(endpoint.allow_incoming_ikev2_routes, local.defaults.fmc.domains.vpns.site_to_site.endpoints.allow_incoming_ikev2_routes, null)
            backup_interface_id = try(endpoint.backup_interface_logical_name, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_interfaces_by_logical_names["${domain_path}:${endpoint.name}:${endpoint.backup_interface_logical_name}"].id
              if contains(keys(local.map_interfaces_by_logical_names), "${domain_path}:${endpoint.name}:${endpoint.backup_interface_logical_name}")
            })[0] : null
            backup_interface_public_ip_address = try(endpoint.backup_interface_public_ip_address, null)
            backup_local_identity_type         = try(endpoint.backup_local_identity_type, null)
            backup_local_identity_string       = try(endpoint.backup_local_identity_string, null)
            connection_type                    = try(endpoint.connection_type, local.defaults.fmc.domains.vpns.site_to_site.endpoints.connection_type, null)
            device_id = endpoint.extranet_device == false ? (
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_devices["${domain_path}:${endpoint.name}"].id
                if contains(keys(local.map_devices), "${domain_path}:${endpoint.name}")
              })[0]
            ) : null
            extranet_dynamic_ip = try(endpoint.extranet_dynamic_ip, null)
            extranet_ip_address = try(join(",", endpoint.extranet_ip_addresses), null)
            interface_id = try(endpoint.interface_logical_name, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_interfaces_by_logical_names["${domain_path}:${endpoint.name}:${endpoint.interface_logical_name}"].id
              if contains(keys(local.map_interfaces_by_logical_names), "${domain_path}:${endpoint.name}:${endpoint.interface_logical_name}")
            })[0] : null
            interface_ipv6_address      = try(endpoint.interface_ipv6_address, null)
            interface_public_ip_address = try(endpoint.interface_public_ip_address, null)
            local_identity_type         = try(endpoint.local_identity_type, null)
            local_identity_string       = try(endpoint.local_identity_string, null)
            nat_exemption               = try(endpoint.nat_exemption, null)
            nat_exemption_inside_interface_id = try(endpoint.nat_exemption_inside_interface, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${endpoint.nat_exemption_inside_interface}"].id
              if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${endpoint.nat_exemption_inside_interface}")
            })[0] : null
            nat_traversal = try(endpoint.nat_traversal, local.defaults.fmc.domains.vpns.site_to_site.endpoints.nat_traversal, null)
            override_remote_vpn_filter_access_list_id = try(endpoint.override_remote_vpn_filter_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${endpoint.override_remote_vpn_filter_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${endpoint.override_remote_vpn_filter_access_list}")
            })[0] : null
            protected_networks = [for protected_network in try(endpoint.protected_networks, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${protected_network}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${protected_network}")
              })[0]
            }]
            protected_networks_access_list_id = try(endpoint.protected_networks_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${endpoint.protected_networks_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${endpoint.protected_networks_access_list}")
            })[0] : null
            reverse_route_injection                  = try(endpoint.reverse_route_injection, local.defaults.fmc.domains.vpns.site_to_site.endpoints.reverse_route_injection, null)
            send_virtual_tunnel_interface_ip_to_peer = try(endpoint.send_virtual_tunnel_interface_ip_to_peer, null)
            send_tunnel_interface_ip_to_peer         = try(endpoint.send_tunnel_interface_ip_to_peer, null)
            vpn_filter_access_list_id = try(endpoint.vpn_filter_access_list, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_extended_access_lists["${domain_path}:${endpoint.vpn_filter_access_list}"].id
              if contains(keys(local.map_extended_access_lists), "${domain_path}:${endpoint.vpn_filter_access_list}")
            })[0] : null
          } }
        } if contains(keys(vpn_s2s), "endpoints")
      ]
    ]) : "${item.domain}:${item.vpn_s2s_name}" => item
  }
}

resource "fmc_vpn_s2s_endpoints" "vpn_s2s_endpoints" {
  for_each = local.resource_vpn_s2s_endpoints

  domain     = each.value.domain
  vpn_s2s_id = each.value.vpn_s2s_id
  items      = each.value.items

  depends_on = [
    fmc_vpn_s2s_ike_settings.vpn_s2s_ike_settings,
  ]
}

##########################################################
###    SITE TO SITE (S2S) IKE SETTINGS
##########################################################
locals {
  resource_vpn_s2s_ike_settings = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          domain                                = domain.name
          vpn_s2s_name                          = vpn_s2s.name
          vpn_s2s_id                            = try(fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id, data.fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id)
          ikev1_authentication_type             = try(vpn_s2s.ike_settings.ikev1_authentication_type, null)
          ikev1_automatic_pre_shared_key_length = try(vpn_s2s.ike_settings.ikev1_automatic_pre_shared_key_length, null)
          ikev1_certificate_id = try(vpn_s2s.ike_settings.ikev1_certificate, null) != null ? (
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_certificate_enrollments["${domain_path}:${vpn_s2s.ike_settings.ikev1_certificate}"].id
              if contains(keys(local.map_certificate_enrollments), "${domain_path}:${vpn_s2s.ike_settings.ikev1_certificate}")
            })[0]
          ) : null
          ikev1_manual_pre_shared_key = try(vpn_s2s.ike_settings.ikev1_manual_pre_shared_key, null)
          ikev1_policies = [for ikev1_policy in try(vpn_s2s.ike_settings.ikev1_policies, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ikev1_policies["${domain_path}:${ikev1_policy}"].id
              if contains(keys(local.map_ikev1_policies), "${domain_path}:${ikev1_policy}")
            })[0]
            name = ikev1_policy
          }]
          ikev2_authentication_type             = try(vpn_s2s.ike_settings.ikev2_authentication_type, null)
          ikev2_automatic_pre_shared_key_length = try(vpn_s2s.ike_settings.ikev2_automatic_pre_shared_key_length, null)
          ikev2_certificate_id = try(vpn_s2s.ike_settings.ikev2_certificate, null) != null ? (
            values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_certificate_enrollments["${domain_path}:${vpn_s2s.ike_settings.ikev2_certificate}"].id
              if contains(keys(local.map_certificate_enrollments), "${domain_path}:${vpn_s2s.ike_settings.ikev2_certificate}")
            })[0]
          ) : null
          ikev2_enforce_hex_based_pre_shared_key = try(vpn_s2s.ike_settings.ikev2_enforce_hex_based_pre_shared_key, local.defaults.fmc.domains.vpns.site_to_site.ike_settings.ikev2_enforce_hex_based_pre_shared_key, null)
          ikev2_manual_pre_shared_key            = try(vpn_s2s.ike_settings.ikev2_manual_pre_shared_key, null)
          ikev2_policies = [for ikev2_policy in try(vpn_s2s.ike_settings.ikev2_policies, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ikev2_policies["${domain_path}:${ikev2_policy}"].id
              if contains(keys(local.map_ikev2_policies), "${domain_path}:${ikev2_policy}")
            })[0]
            name = ikev2_policy
          }]
        } if contains(keys(vpn_s2s), "ike_settings")
      ]
    ]) : "${item.domain}:${item.vpn_s2s_name}" => item
  }
}

resource "fmc_vpn_s2s_ike_settings" "vpn_s2s_ike_settings" {
  for_each = local.resource_vpn_s2s_ike_settings

  domain                                 = each.value.domain
  vpn_s2s_id                             = each.value.vpn_s2s_id
  ikev1_authentication_type              = each.value.ikev1_authentication_type
  ikev1_automatic_pre_shared_key_length  = each.value.ikev1_automatic_pre_shared_key_length
  ikev1_certificate_id                   = each.value.ikev1_certificate_id
  ikev1_manual_pre_shared_key            = each.value.ikev1_manual_pre_shared_key
  ikev1_policies                         = each.value.ikev1_policies
  ikev2_authentication_type              = each.value.ikev2_authentication_type
  ikev2_automatic_pre_shared_key_length  = each.value.ikev2_automatic_pre_shared_key_length
  ikev2_certificate_id                   = each.value.ikev2_certificate_id
  ikev2_enforce_hex_based_pre_shared_key = each.value.ikev2_enforce_hex_based_pre_shared_key
  ikev2_manual_pre_shared_key            = each.value.ikev2_manual_pre_shared_key
  ikev2_policies                         = each.value.ikev2_policies
}

##########################################################
###    SITE TO SITE (S2S) IPSEC SETTINGS
##########################################################
locals {
  resource_vpn_s2s_ipsec_settings = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          domain                 = domain.name
          vpn_s2s_name           = vpn_s2s.name
          vpn_s2s_id             = try(fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id, data.fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id)
          crypto_map_type        = try(vpn_s2s.ipsec_settings.crypto_map_type, null)
          do_not_fragment_policy = try(vpn_s2s.ipsec_settings.do_not_fragment_policy, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.do_not_fragment_policy, null)
          ikev1_ipsec_proposals = [for ikev1_ipsec_proposal in try(vpn_s2s.ipsec_settings.ikev1_ipsec_proposals, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ikev1_ipsec_proposals["${domain_path}:${ikev1_ipsec_proposal}"].id
              if contains(keys(local.map_ikev1_ipsec_proposals), "${domain_path}:${ikev1_ipsec_proposal}")
            })[0]
            name = ikev1_ipsec_proposal
          }]
          ikev2_ipsec_proposals = [for ikev2_ipsec_proposal in try(vpn_s2s.ipsec_settings.ikev2_ipsec_proposals, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ikev2_ipsec_proposals["${domain_path}:${ikev2_ipsec_proposal}"].id
              if contains(keys(local.map_ikev2_ipsec_proposals), "${domain_path}:${ikev2_ipsec_proposal}")
            })[0]
            name = ikev2_ipsec_proposal
          }]
          ikev2_mode                                = try(vpn_s2s.ipsec_settings.ikev2_mode, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.ikev2_mode, null)
          lifetime_duration                         = try(vpn_s2s.ipsec_settings.lifetime_duration, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.lifetime_duration, null)
          lifetime_size                             = try(vpn_s2s.ipsec_settings.lifetime_size, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.lifetime_size, null)
          perfect_forward_secrecy                   = try(vpn_s2s.ipsec_settings.perfect_forward_secrecy, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.perfect_forward_secrecy, null)
          perfect_forward_secrecy_modulus_group     = try(vpn_s2s.ipsec_settings.perfect_forward_secrecy_modulus_group, null)
          reverse_route_injection                   = try(vpn_s2s.ipsec_settings.reverse_route_injection, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.reverse_route_injection, null)
          security_association_strength_enforcement = try(vpn_s2s.ipsec_settings.security_association_strength_enforcement, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.security_association_strength_enforcement, null)
          tfc                                       = try(vpn_s2s.ipsec_settings.tfc, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.tfc, null)
          tfc_burst_bytes                           = try(vpn_s2s.ipsec_settings.tfc_burst_bytes, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.tfc_burst_bytes, null)
          tfc_payload_bytes                         = try(vpn_s2s.ipsec_settings.tfc_payload_bytes, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.tfc_payload_bytes, null)
          tfc_timeout                               = try(vpn_s2s.ipsec_settings.tfc_timeout, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.tfc_timeout, null)
          validate_incoming_icmp_error_messages     = try(vpn_s2s.ipsec_settings.validate_incoming_icmp_error_messages, local.defaults.fmc.domains.vpns.site_to_site.ipsec_settings.validate_incoming_icmp_error_messages, null)
        } if contains(keys(vpn_s2s), "ipsec_settings")
      ]
    ]) : "${item.domain}:${item.vpn_s2s_name}" => item
  }
}

resource "fmc_vpn_s2s_ipsec_settings" "vpn_s2s_ipsec_settings" {
  for_each = local.resource_vpn_s2s_ipsec_settings

  domain                                    = each.value.domain
  vpn_s2s_id                                = each.value.vpn_s2s_id
  crypto_map_type                           = each.value.crypto_map_type
  do_not_fragment_policy                    = each.value.do_not_fragment_policy
  ikev1_ipsec_proposals                     = each.value.ikev1_ipsec_proposals
  ikev2_ipsec_proposals                     = each.value.ikev2_ipsec_proposals
  ikev2_mode                                = each.value.ikev2_mode
  lifetime_duration                         = each.value.lifetime_duration
  lifetime_size                             = each.value.lifetime_size
  perfect_forward_secrecy                   = each.value.perfect_forward_secrecy
  perfect_forward_secrecy_modulus_group     = each.value.perfect_forward_secrecy_modulus_group
  reverse_route_injection                   = each.value.reverse_route_injection
  security_association_strength_enforcement = each.value.security_association_strength_enforcement
  tfc                                       = each.value.tfc
  tfc_burst_bytes                           = each.value.tfc_burst_bytes
  tfc_payload_bytes                         = each.value.tfc_payload_bytes
  tfc_timeout                               = each.value.tfc_timeout
  validate_incoming_icmp_error_messages     = each.value.validate_incoming_icmp_error_messages
}

##########################################################
###    SITE TO SITE (S2S) ADVANCED SETTINGS
##########################################################
locals {
  resource_vpn_s2s_advanced_settings = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_s2s in try(domain.vpns.site_to_site, {}) : {
          domain                                                              = domain.name
          vpn_s2s_name                                                        = vpn_s2s.name
          vpn_s2s_id                                                          = try(fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id, data.fmc_vpn_s2s.vpn_s2s["${domain.name}:${vpn_s2s.name}"].id)
          ike_keepalive                                                       = try(vpn_s2s.advanced_settings.ike_keepalive, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_keepalive, null)
          ike_keepalive_threshold                                             = try(vpn_s2s.advanced_settings.ike_keepalive_threshold, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_keepalive_threshold, null)
          ike_keepalive_retry_interval                                        = try(vpn_s2s.advanced_settings.ike_keepalive_retry_interval, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_keepalive_retry_interval, null)
          ike_identity_sent_to_peers                                          = try(vpn_s2s.advanced_settings.ike_identity_sent_to_peers, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_identity_sent_to_peers, null)
          ike_peer_identity_validation                                        = try(vpn_s2s.advanced_settings.ike_peer_identity_validation, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_peer_identity_validation, null)
          ike_aggressive_mode                                                 = try(vpn_s2s.advanced_settings.ike_aggressive_mode, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_aggressive_mode, null)
          ike_notification_on_tunnel_disconnect                               = try(vpn_s2s.advanced_settings.ike_notification_on_tunnel_disconnect, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ike_notification_on_tunnel_disconnect, null)
          ikev2_cookie_challenge                                              = try(vpn_s2s.advanced_settings.ikev2_cookie_challenge, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ikev2_cookie_challenge, null)
          ikev2_threshold_to_challenge_incoming_cookies                       = try(vpn_s2s.advanced_settings.ikev2_threshold_to_challenge_incoming_cookies, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ikev2_threshold_to_challenge_incoming_cookies, null)
          ikev2_number_of_sas_allowed_in_negotiation                          = try(vpn_s2s.advanced_settings.ikev2_number_of_sas_allowed_in_negotiation, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ikev2_number_of_sas_allowed_in_negotiation, null)
          ikev2_maximum_number_of_sas_allowed                                 = try(vpn_s2s.advanced_settings.ikev2_maximum_number_of_sas_allowed, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ikev2_maximum_number_of_sas_allowed, null)
          ipsec_fragmentation_before_encryption                               = try(vpn_s2s.advanced_settings.ipsec_fragmentation_before_encryption, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ipsec_fragmentation_before_encryption, null)
          ipsec_path_maximum_transmission_unit_aging_reset_interval           = try(vpn_s2s.advanced_settings.ipsec_path_maximum_transmission_unit_aging_reset_interval, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.ipsec_path_maximum_transmission_unit_aging_reset_interval, null)
          spoke_to_spoke_connectivity_through_hub                             = try(vpn_s2s.advanced_settings.spoke_to_spoke_connectivity_through_hub, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.spoke_to_spoke_connectivity_through_hub, null)
          nat_keepalive_message_traversal                                     = try(vpn_s2s.advanced_settings.nat_keepalive_message_traversal_interval, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.nat_keepalive_message_traversal_interval, null) != null ? true : null
          nat_keepalive_message_traversal_interval                            = try(vpn_s2s.advanced_settings.nat_keepalive_message_traversal_interval, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.nat_keepalive_message_traversal_interval, null)
          vpn_idle_timeout                                                    = try(vpn_s2s.advanced_settings.vpn_idle_timeout_value, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.vpn_idle_timeout_value, null) != null ? true : null
          vpn_idle_timeout_value                                              = try(vpn_s2s.advanced_settings.vpn_idle_timeout_value, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.vpn_idle_timeout_value, null)
          sgt_propagation_over_virtual_tunnel_interface                       = try(vpn_s2s.advanced_settings.sgt_propagation_over_virtual_tunnel_interface, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.sgt_propagation_over_virtual_tunnel_interface, null)
          bypass_access_control_policy_for_decrypted_traffic                  = try(vpn_s2s.advanced_settings.bypass_access_control_policy_for_decrypted_traffic, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.bypass_access_control_policy_for_decrypted_traffic, null)
          cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel = try(vpn_s2s.advanced_settings.cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel, null)
          cert_use_ou_to_determine_tunnel                                     = try(vpn_s2s.advanced_settings.cert_use_ou_to_determine_tunnel, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.cert_use_ou_to_determine_tunnel, null)
          cert_use_ike_identity_to_determine_tunnel                           = try(vpn_s2s.advanced_settings.cert_use_ike_identity_to_determine_tunnel, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.cert_use_ike_identity_to_determine_tunnel, null)
          cert_use_peer_ip_address_to_determine_tunnel                        = try(vpn_s2s.advanced_settings.cert_use_peer_ip_address_to_determine_tunnel, local.defaults.fmc.domains.vpns.site_to_site.advanced_settings.cert_use_peer_ip_address_to_determine_tunnel, null)
        } if contains(keys(vpn_s2s), "advanced_settings")
      ]
    ]) : "${item.domain}:${item.vpn_s2s_name}" => item
  }
}

resource "fmc_vpn_s2s_advanced_settings" "vpn_s2s_advanced_settings" {
  for_each = local.resource_vpn_s2s_advanced_settings

  domain                                                              = each.value.domain
  vpn_s2s_id                                                          = each.value.vpn_s2s_id
  ike_keepalive                                                       = each.value.ike_keepalive
  ike_keepalive_threshold                                             = each.value.ike_keepalive_threshold
  ike_keepalive_retry_interval                                        = each.value.ike_keepalive_retry_interval
  ike_identity_sent_to_peers                                          = each.value.ike_identity_sent_to_peers
  ike_peer_identity_validation                                        = each.value.ike_peer_identity_validation
  ike_aggressive_mode                                                 = each.value.ike_aggressive_mode
  ike_notification_on_tunnel_disconnect                               = each.value.ike_notification_on_tunnel_disconnect
  ikev2_cookie_challenge                                              = each.value.ikev2_cookie_challenge
  ikev2_threshold_to_challenge_incoming_cookies                       = each.value.ikev2_threshold_to_challenge_incoming_cookies
  ikev2_number_of_sas_allowed_in_negotiation                          = each.value.ikev2_number_of_sas_allowed_in_negotiation
  ikev2_maximum_number_of_sas_allowed                                 = each.value.ikev2_maximum_number_of_sas_allowed
  ipsec_fragmentation_before_encryption                               = each.value.ipsec_fragmentation_before_encryption
  ipsec_path_maximum_transmission_unit_aging_reset_interval           = each.value.ipsec_path_maximum_transmission_unit_aging_reset_interval
  spoke_to_spoke_connectivity_through_hub                             = each.value.spoke_to_spoke_connectivity_through_hub
  nat_keepalive_message_traversal                                     = each.value.nat_keepalive_message_traversal
  nat_keepalive_message_traversal_interval                            = each.value.nat_keepalive_message_traversal_interval
  vpn_idle_timeout                                                    = each.value.vpn_idle_timeout
  vpn_idle_timeout_value                                              = each.value.vpn_idle_timeout_value
  sgt_propagation_over_virtual_tunnel_interface                       = each.value.sgt_propagation_over_virtual_tunnel_interface
  bypass_access_control_policy_for_decrypted_traffic                  = each.value.bypass_access_control_policy_for_decrypted_traffic
  cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel = each.value.cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel
  cert_use_ou_to_determine_tunnel                                     = each.value.cert_use_ou_to_determine_tunnel
  cert_use_ike_identity_to_determine_tunnel                           = each.value.cert_use_ike_identity_to_determine_tunnel
  cert_use_peer_ip_address_to_determine_tunnel                        = each.value.cert_use_peer_ip_address_to_determine_tunnel
}

##########################################################
###    REMOTE ACCESS (RA)
##########################################################
locals {
  data_vpn_ra = {
    for item in flatten([
      for domain in local.data_existing : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          name   = vpn_ra.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_vpn_ra = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain               = domain.name
          name                 = vpn_ra.name
          description          = try(vpn_ra.description, null)
          protocol_ssl         = try(vpn_ra.protocol_ssl, local.defaults.vpns.remote_access.protocol_ssl, null)
          protocol_ipsec_ikev2 = try(vpn_ra.protocol_ipsec_ikev2, local.defaults.vpns.remote_access.protocol_ipsec_ikev2, null)
          local_realm_id = try(vpn_ra.local_realm, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_realm_local["${domain_path}:${vpn_ra.local_realm}"].id
            if contains(keys(local.map_realm_local), "${domain_path}:${vpn_ra.local_realm}")
          })[0] : null
          access_interfaces = [for access_interface in try(vpn_ra.access_interfaces, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${access_interface.name}"].id
              if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${access_interface.name}")
            })[0]
            protocol_ssl         = try(access_interface.protocol_ssl, null)
            protocol_ipsec_ikev2 = try(access_interface.protocol_ipsec_ikev2, null)
            protocol_ssl_dtls    = try(access_interface.protocol_ssl_dtls, null)
            interface_specific_certificate_id = try(access_interface.interface_specific_certificate, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_certificate_enrollments["${domain_path}:${access_interface.interface_specific_certificate}"].id
              if contains(keys(local.map_certificate_enrollments), "${domain_path}:${access_interface.interface_specific_certificate}")
            })[0] : null
          }]
          allow_users_to_select_connection_profile = try(vpn_ra.allow_users_to_select_connection_profile, local.defaults.fmc.domains.vpns.remote_access.allow_users_to_select_connection_profile, null)
          web_access_port                          = try(vpn_ra.web_access_port, local.defaults.fmc.domains.vpns.remote_access.web_access_port, null)
          dtls_port                                = try(vpn_ra.dtls_port, local.defaults.fmc.domains.vpns.remote_access.dtls_port, null)
          ssl_global_identity_certificate_id = try(vpn_ra.ssl_global_identity_certificate, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_certificate_enrollments["${domain_path}:${vpn_ra.ssl_global_identity_certificate}"].id
            if contains(keys(local.map_certificate_enrollments), "${domain_path}:${vpn_ra.ssl_global_identity_certificate}")
          })[0] : null
          ipsec_ikev2_identity_certificate_id = try(vpn_ra.ipsec_ikev2_identity_certificate, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_certificate_enrollments["${domain_path}:${vpn_ra.ipsec_ikev2_identity_certificate}"].id
            if contains(keys(local.map_certificate_enrollments), "${domain_path}:${vpn_ra.ipsec_ikev2_identity_certificate}")
          })[0] : null
          service_access_object_id = try(vpn_ra.service_access, null) != null ? values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_service_accesses["${domain_path}:${vpn_ra.service_access}"].id
            if contains(keys(local.map_service_accesses), "${domain_path}:${vpn_ra.service_access}")
          })[0] : null
          bypass_access_control_policy_for_decrypted_traffic = try(vpn_ra.bypass_access_control_policy_for_decrypted_traffic, local.defaults.fmc.domains.vpns.remote_access.bypass_access_control_policy_for_decrypted_traffic, null)
          secure_client_images = [for secure_client_image in try(vpn_ra.secure_client_images, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_images["${domain_path}:${secure_client_image.name}"].id
              if contains(keys(local.map_secure_client_images), "${domain_path}:${secure_client_image.name}")
            })[0]
            operating_system = secure_client_image.operating_system
          }]
          group_policies = [for group_policy in try(vpn_ra.group_policies, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_group_policies["${domain_path}:${group_policy}"].id
              if contains(keys(local.map_group_policies), "${domain_path}:${group_policy}")
            })[0]
          }]
          ikev2_policies = [for ikev2_policy in try(vpn_ra.ipsec_ikev2_policies, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_ikev2_policies["${domain_path}:${ikev2_policy}"].id
              if contains(keys(local.map_ikev2_policies), "${domain_path}:${ikev2_policy}")
            })[0]
          }]
        } if !contains(try(keys(local.data_vpn_ra), {}), "${domain.name}:${vpn_ra.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_vpn_ra" "vpn_ra" {
  for_each = local.data_vpn_ra

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_vpn_ra" "vpn_ra" {
  for_each = local.resource_vpn_ra

  domain                                             = each.value.domain
  name                                               = each.value.name
  description                                        = each.value.description
  protocol_ssl                                       = each.value.protocol_ssl
  protocol_ipsec_ikev2                               = each.value.protocol_ipsec_ikev2
  local_realm_id                                     = each.value.local_realm_id
  access_interfaces                                  = each.value.access_interfaces
  allow_users_to_select_connection_profile           = each.value.allow_users_to_select_connection_profile
  web_access_port                                    = each.value.web_access_port
  dtls_port                                          = each.value.dtls_port
  ssl_global_identity_certificate_id                 = each.value.ssl_global_identity_certificate_id
  ipsec_ikev2_identity_certificate_id                = each.value.ipsec_ikev2_identity_certificate_id
  service_access_object_id                           = each.value.service_access_object_id
  bypass_access_control_policy_for_decrypted_traffic = each.value.bypass_access_control_policy_for_decrypted_traffic
  secure_client_images                               = each.value.secure_client_images
  group_policies                                     = each.value.group_policies
  ikev2_policies                                     = each.value.ikev2_policies
}

##########################################################
###    REMOTE ACCESS (RA) SECURE CLIENT CUSTOMIZATIONS
##########################################################
locals {
  resource_vpn_ra_secure_client_customization = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain      = domain.name
          vpn_ra_name = vpn_ra.name
          vpn_ra_id   = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          gui_and_text_messages = [for gui_and_text_message in try(vpn_ra.secure_client_customizations.gui_and_text_messages, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${gui_and_text_message}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${gui_and_text_message}")
            })[0]
          }]
          icons_and_images = [for icon_and_image in try(vpn_ra.secure_client_customizations.icons_and_images, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${icon_and_image}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${icon_and_image}")
            })[0]
          }]
          scripts = [for script in try(vpn_ra.secure_client_customizations.scripts, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${script}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${script}")
            })[0]
          }]
          binaries = [for binary in try(vpn_ra.secure_client_customizations.binaries, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${binary}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${binary}")
            })[0]
          }]
          custom_installer_transforms = [for custom_installer_transform in try(vpn_ra.secure_client_customizations.custom_installer_transforms, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${custom_installer_transform}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${custom_installer_transform}")
            })[0]
          }]
          localized_installer_transforms = [for localized_installer_transform in try(vpn_ra.secure_client_customizations.localized_installer_transforms, []) : {
            id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_secure_client_customizations["${domain_path}:${localized_installer_transform}"].id
              if contains(keys(local.map_secure_client_customizations), "${domain_path}:${localized_installer_transform}")
            })[0]
          }]
        } if contains(keys(vpn_ra), "secure_client_customizations")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_secure_client_customization" "vpn_ra_secure_client_customization" {
  for_each = local.resource_vpn_ra_secure_client_customization

  domain                         = each.value.domain
  vpn_ra_id                      = each.value.vpn_ra_id
  gui_and_text_messages          = each.value.gui_and_text_messages
  icons_and_images               = each.value.icons_and_images
  scripts                        = each.value.scripts
  binaries                       = each.value.binaries
  custom_installer_transforms    = each.value.custom_installer_transforms
  localized_installer_transforms = each.value.localized_installer_transforms
}

##########################################################
###    REMOTE ACCESS (RA) ADDRESS ASSIGNMENT POLICIES
##########################################################
locals {
  resource_vpn_ra_address_assignment_policy = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain                                    = domain.name
          vpn_ra_name                               = vpn_ra.name
          vpn_ra_id                                 = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          ipv4_use_authorization_server             = try(vpn_ra.address_assignment_policy.ipv4_use_authorization_server, local.defaults.fmc.domains.vpns.remote_access.address_assignment_policy.ipv4_use_authorization_server, null)
          ipv4_use_internal_address_pool            = try(vpn_ra.address_assignment_policy.ipv4_use_internal_address_pool, local.defaults.fmc.domains.vpns.remote_access.address_assignment_policy.ipv4_use_internal_address_pool, null)
          ipv4_internal_address_pool_reuse_interval = try(vpn_ra.address_assignment_policy.ipv4_internal_address_pool_reuse_interval, local.defaults.fmc.domains.vpns.remote_access.address_assignment_policy.ipv4_internal_address_pool_reuse_interval, null)
          ipv6_use_authorization_server             = try(vpn_ra.address_assignment_policy.ipv6_use_authorization_server, local.defaults.fmc.domains.vpns.remote_access.address_assignment_policy.ipv6_use_authorization_server, null)
          ipv6_use_internal_address_pool            = try(vpn_ra.address_assignment_policy.ipv6_use_internal_address_pool, local.defaults.fmc.domains.vpns.remote_access.address_assignment_policy.ipv6_use_internal_address_pool, null)
        } if contains(keys(vpn_ra), "address_assignment_policy")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_address_assignment_policy" "vpn_ra_address_assignment_policy" {
  for_each = local.resource_vpn_ra_address_assignment_policy

  domain                                    = each.value.domain
  vpn_ra_id                                 = each.value.vpn_ra_id
  ipv4_use_authorization_server             = each.value.ipv4_use_authorization_server
  ipv4_use_internal_address_pool            = each.value.ipv4_use_internal_address_pool
  ipv4_internal_address_pool_reuse_interval = each.value.ipv4_internal_address_pool_reuse_interval
  ipv6_use_authorization_server             = each.value.ipv6_use_authorization_server
  ipv6_use_internal_address_pool            = each.value.ipv6_use_internal_address_pool
}

##########################################################
###    REMOTE ACCESS (RA) CONNECTION PROFILES
##########################################################
locals {
  resource_vpn_ra_connection_profiles = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain      = domain.name
          vpn_ra_name = vpn_ra.name
          vpn_ra_id   = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          items = { for connection_profile in vpn_ra.connection_profiles : (connection_profile.name) => {
            group_policy_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_group_policies["${domain_path}:${connection_profile.group_policy}"].id
              if contains(keys(local.map_group_policies), "${domain_path}:${connection_profile.group_policy}")
            })[0]
            ipv4_address_pools = [for ipv4_address_pool in try(connection_profile.ipv4_address_pools, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv4_address_pools["${domain_path}:${ipv4_address_pool}"].id
                if contains(keys(local.map_ipv4_address_pools), "${domain_path}:${ipv4_address_pool}")
              })[0]
            }]
            ipv6_address_pools = [for ipv6_address_pool in try(connection_profile.ipv6_address_pools, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ipv6_address_pools["${domain_path}:${ipv6_address_pool}"].id
                if contains(keys(local.map_ipv6_address_pools), "${domain_path}:${ipv6_address_pool}")
              })[0]
            }]
            dhcp_servers = [for dhcp_server in try(connection_profile.dhcp_servers, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_hosts["${domain_path}:${dhcp_server}"].id
                if contains(keys(local.map_hosts), "${domain_path}:${dhcp_server}")
              })[0]
            }]
            authentication_method                   = connection_profile.authentication_method
            multiple_certificate_authentication     = try(connection_profile.multiple_certificate_authentication, null)
            primary_authentication_server_use_local = try(connection_profile.primary_authentication.server, null) == "LOCAL" ? true : null
            primary_authentication_server_id = try(connection_profile.primary_authentication.server, null) != null && try(connection_profile.primary_authentication.server, null) != "LOCAL" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.primary_authentication.server}"].id
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.primary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.primary_authentication.server}"].id
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.primary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_single_sign_on_servers["${domain_path}:${connection_profile.primary_authentication.server}"].id
                if contains(keys(local.map_single_sign_on_servers), "${domain_path}:${connection_profile.primary_authentication.server}")
            })[0]) : null
            primary_authentication_server_type = try(connection_profile.primary_authentication.server, null) != null && try(connection_profile.primary_authentication.server, null) != "LOCAL" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.primary_authentication.server}"].type
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.primary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.primary_authentication.server}"].type
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.primary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_single_sign_on_servers["${domain_path}:${connection_profile.primary_authentication.server}"].type
                if contains(keys(local.map_single_sign_on_servers), "${domain_path}:${connection_profile.primary_authentication.server}")
            })[0]) : null
            primary_authentication_fallback_to_local                                     = try(connection_profile.primary_authentication.fallback_to_local, null)
            primary_authentication_prefill_username_from_certificate                     = try(connection_profile.primary_authentication.prefill_username_from_certificate_map_primary_field, connection_profile.primary_authentication.prefill_username_from_certificate_map_secondary_field, connection_profile.primary_authentication.prefill_username_from_certificate_map_entire_dn, null) != null ? true : null
            primary_authentication_prefill_username_from_certificate_map_primary_field   = try(connection_profile.primary_authentication.prefill_username_from_certificate_map_primary_field, null)
            primary_authentication_prefill_username_from_certificate_map_secondary_field = try(connection_profile.primary_authentication.prefill_username_from_certificate_map_secondary_field, null)
            primary_authentication_prefill_username_from_certificate_map_entire_dn       = try(connection_profile.primary_authentication.prefill_username_from_certificate_map_primary_field, connection_profile.primary_authentication.prefill_username_from_certificate_map_secondary_field, null) != null ? false : try(connection_profile.primary_authentication.prefill_username_from_certificate_map_entire_dn, null)
            primary_authentication_hide_username_in_login_window                         = try(connection_profile.primary_authentication.hide_username_in_login_window, null)
            secondary_authentication                                                     = try(connection_profile.secondary_authentication, null) != null ? true : null
            secondary_authentication_server_use_local                                    = try(connection_profile.secondary_authentication.server, null) == "LOCAL" ? true : null
            secondary_authentication_server_id = try(connection_profile.secondary_authentication.server, null) != null && try(connection_profile.secondary_authentication.server, null) != "LOCAL" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.secondary_authentication.server}"].id
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.secondary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.secondary_authentication.server}"].id
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.secondary_authentication.server}")
            })[0]) : null
            secondary_authentication_server_type = try(connection_profile.secondary_authentication.server, null) != null && try(connection_profile.secondary_authentication.server, null) != "LOCAL" ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.secondary_authentication.server}"].type
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.secondary_authentication.server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.secondary_authentication.server}"].type
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.secondary_authentication.server}")
            })[0]) : null
            secondary_authentication_fallback_to_local                                   = try(connection_profile.secondary_authentication.fallback_to_local, null)
            secondary_authentication_prompt_for_username                                 = try(connection_profile.secondary_authentication.prompt_for_username, null)
            secondary_authentication_use_primary_authentication_username                 = try(connection_profile.secondary_authentication.use_primary_authentication_username, null)
            secondary_authentication_use_secondary_authentication_username_for_reporting = try(connection_profile.secondary_authentication.use_secondary_authentication_username_for_reporting, null)
            saml_and_certificate_username_must_match                                     = try(connection_profile.saml_and_certificate_username_must_match, null)
            saml_use_external_browser                                                    = try(connection_profile.saml_use_external_browser, null)
            authorization_server_id = try(connection_profile.authorization_server, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.authorization_server}"].id
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.authorization_server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.authorization_server}"].id
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.authorization_server}")
            })[0]) : null
            authorization_server_type = try(connection_profile.authorization_server, null) != null ? try(
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.authorization_server}"].type
                if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.authorization_server}")
              })[0],
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_realm_ad_ldap["${domain_path}:${connection_profile.authorization_server}"].type
                if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${connection_profile.authorization_server}")
            })[0]) : null
            allow_connection_only_if_user_exists_in_authorization_database = try(connection_profile.allow_connection_only_if_user_exists_in_authorization_database, null)
            accounting_server_id = try(connection_profile.accounting_server, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.accounting_server}"].id
              if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.accounting_server}")
            })[0] : null
            accounting_server_type = try(connection_profile.accounting_server, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_radius_server_groups["${domain_path}:${connection_profile.accounting_server}"].type
              if contains(keys(local.map_radius_server_groups), "${domain_path}:${connection_profile.accounting_server}")
            })[0] : null
            strip_realm_from_username                                    = try(connection_profile.strip_realm_from_username, null)
            strip_group_from_username                                    = try(connection_profile.strip_group_from_username, null)
            password_management                                          = try(connection_profile.password_management_notify_user_on_password_expiry_day, connection_profile.password_management_advance_password_expiration_notification, null) != null ? true : null
            password_management_notify_user_on_password_expiry_day       = try(connection_profile.password_management_notify_user_on_password_expiry_day, null)
            password_management_advance_password_expiration_notification = try(connection_profile.password_management_advance_password_expiration_notification, null)
            alias_names = [for alias_name in try(connection_profile.alias_names, []) : {
              name    = alias_name.name
              enabled = alias_name.enabled
            }]
            alias_urls = [for alias_url in try(connection_profile.alias_urls, []) : {
              url_object_id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_urls["${domain_path}:${alias_url.url_object}"].id
                if contains(keys(local.map_urls), "${domain_path}:${alias_url.url_object}")
              })[0]
              enabled = alias_url.enabled
            }]
          } }
        } if contains(keys(vpn_ra), "connection_profiles")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_connection_profiles" "vpn_ra_connection_profiles" {
  for_each = local.resource_vpn_ra_connection_profiles

  domain    = each.value.domain
  vpn_ra_id = each.value.vpn_ra_id
  items     = each.value.items
}

##########################################################
###    REMOTE ACCESS (RA) CERTIFICATE MAPS
##########################################################
locals {
  resource_vpn_ra_certificate_map = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain                                         = domain.name
          vpn_ra_name                                    = vpn_ra.name
          vpn_ra_id                                      = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          use_alias_url                                  = try(vpn_ra.certificate_map.use_alias_url, null)
          use_certificate_to_connection_profile_mappings = try(vpn_ra.certificate_map.certificate_to_connection_profile_mappings, null) != null ? true : null
          certificate_to_connection_profile_mappings = [for mapping in try(vpn_ra.certificate_map.certificate_to_connection_profile_mappings, []) : {
            certificate_map_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_certificate_maps["${domain_path}:${mapping.certificate_map}"].id
              if contains(keys(local.map_certificate_maps), "${domain_path}:${mapping.certificate_map}")
            })[0]
            connection_profile_id = fmc_vpn_ra_connection_profiles.vpn_ra_connection_profiles["${domain.name}:${vpn_ra.name}"].items[mapping.connection_profile].id
          }]
        } if contains(keys(vpn_ra), "certificate_map")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_certificate_map" "vpn_ra_certificate_map" {
  for_each = local.resource_vpn_ra_certificate_map

  domain                                         = each.value.domain
  vpn_ra_id                                      = each.value.vpn_ra_id
  use_alias_url                                  = each.value.use_alias_url
  use_certificate_to_connection_profile_mappings = each.value.use_certificate_to_connection_profile_mappings
  certificate_to_connection_profile_mappings     = each.value.certificate_to_connection_profile_mappings
}

##########################################################
###    REMOTE ACCESS (RA) LDAP ATTRIBUTE MAPS
##########################################################
locals {
  resource_vpn_ra_ldap_attribute_map = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain      = domain.name
          vpn_ra_name = vpn_ra.name
          vpn_ra_id   = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          realms = [for realm in try(vpn_ra.ldap_attribute_maps, []) : {
            realm_ad_ldap_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_realm_ad_ldap["${domain_path}:${realm.ad_ldap_realm}"].id
              if contains(keys(local.map_realm_ad_ldap), "${domain_path}:${realm.ad_ldap_realm}")
            })[0]
            attribute_maps = [for attribute_map in try(realm.attribute_maps, []) : {
              ldap_attribute_name  = attribute_map.ldap_attribute_name
              cisco_attribute_name = attribute_map.cisco_attribute_name
              value_maps = [for value_map in try(attribute_map.value_maps, []) : {
                ldap_attribute_value  = value_map.ldap_attribute_value
                cisco_attribute_value = value_map.cisco_attribute_value
              }]
            }]
          }]
        } if contains(keys(vpn_ra), "ldap_attribute_maps")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_ldap_attribute_map" "vpn_ra_ldap_attribute_map" {
  for_each = local.resource_vpn_ra_ldap_attribute_map

  domain    = each.value.domain
  vpn_ra_id = each.value.vpn_ra_id
  realms    = each.value.realms
}

##########################################################
###    REMOTE ACCESS (RA) LOAD BALANCING
##########################################################
locals {
  resource_vpn_ra_load_balancing = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain             = domain.name
          vpn_ra_name        = vpn_ra.name
          vpn_ra_id          = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          enabled            = true
          ipv4_group_address = vpn_ra.load_balancing.ipv4_group_address
          ipv6_group_address = try(vpn_ra.load_balancing.ipv6_group_address, null)
          interface_id = values({
            for domain_path in local.related_domains[domain.name] :
            domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${vpn_ra.load_balancing.interface}"].id
            if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${vpn_ra.load_balancing.interface}")
          })[0]
          port                                    = try(vpn_ra.load_balancing.port, local.defaults.fmc.domains.vpns.remote_access.load_balancing.port, null)
          ipsec                                   = try(vpn_ra.load_balancing.ipsec_encryption_key, null) != null ? true : false
          ipsec_encryption_key                    = try(vpn_ra.load_balancing.ipsec_encryption_key, null)
          send_fqdn_to_peer_devices_instead_of_ip = try(vpn_ra.load_balancing.send_fqdn_to_peer_devices_instead_of_ip, local.defaults.fmc.domains.vpns.remote_access.load_balancing.send_fqdn_to_peer_devices_instead_of_ip, null)
          ikev2_redirect_phase                    = try(vpn_ra.load_balancing.ikev2_redirect_phase, local.defaults.fmc.domains.vpns.remote_access.load_balancing.ikev2_redirect_phase, null)
        } if contains(keys(vpn_ra), "load_balancing")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_load_balancing" "vpn_ra_load_balancing" {
  for_each = local.resource_vpn_ra_load_balancing

  domain                                  = each.value.domain
  vpn_ra_id                               = each.value.vpn_ra_id
  enabled                                 = each.value.enabled
  ipv4_group_address                      = each.value.ipv4_group_address
  ipv6_group_address                      = each.value.ipv6_group_address
  interface_id                            = each.value.interface_id
  port                                    = each.value.port
  ipsec                                   = each.value.ipsec
  ipsec_encryption_key                    = each.value.ipsec_encryption_key
  send_fqdn_to_peer_devices_instead_of_ip = each.value.send_fqdn_to_peer_devices_instead_of_ip
  ikev2_redirect_phase                    = each.value.ikev2_redirect_phase
}

##########################################################
###    REMOTE ACCESS (RA) CRYPTO MAPS
##########################################################
locals {
  resource_vpn_ra_ipsec_crypto_map = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : [
          for ipsec_crypto_map in try(vpn_ra.ipsec_crypto_maps, []) : {
            domain      = domain.name
            vpn_ra_name = vpn_ra.name
            vpn_ra_id   = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
            interface   = ipsec_crypto_map.interface
            interface_id = values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_security_zones_and_interface_groups["${domain_path}:${ipsec_crypto_map.interface}"].id
              if contains(keys(local.map_security_zones_and_interface_groups), "${domain_path}:${ipsec_crypto_map.interface}")
            })[0]
            ikev2_ipsec_proposals = [for proposal in try(ipsec_crypto_map.ikev2_ipsec_proposals, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_ikev2_ipsec_proposals["${domain_path}:${proposal}"].id
                if contains(keys(local.map_ikev2_ipsec_proposals), "${domain_path}:${proposal}")
              })[0]
            }]
            reverse_route_injection               = try(ipsec_crypto_map.reverse_route_injection, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.reverse_route_injection, null)
            client_services                       = try(ipsec_crypto_map.client_services_port, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.client_services_port, null) != null ? true : null
            client_services_port                  = try(ipsec_crypto_map.client_services_port, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.client_services_port, null)
            perfect_forward_secrecy               = try(ipsec_crypto_map.perfect_forward_secrecy_modulus_group, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.perfect_forward_secrecy_modulus_group, null) != null ? true : false
            perfect_forward_secrecy_modulus_group = try(ipsec_crypto_map.perfect_forward_secrecy_modulus_group, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.perfect_forward_secrecy_modulus_group, null)
            lifetime_duration                     = try(ipsec_crypto_map.lifetime_duration, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.lifetime_duration, null)
            lifetime_size                         = try(ipsec_crypto_map.lifetime_size, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.lifetime_size, null)
            validate_incoming_icmp_error_messages = try(ipsec_crypto_map.validate_incoming_icmp_error_messages, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.validate_incoming_icmp_error_messages, null)
            do_not_fragment_policy                = try(ipsec_crypto_map.do_not_fragment_policy, local.defaults.fmc.domains.vpns.remote_access.ipsec_crypto_maps.do_not_fragment_policy, null)
            tfc                                   = try(ipsec_crypto_map.tfc_burst_bytes, ipsec_crypto_map.tfc_payload_bytes, ipsec_crypto_map.tfc_timeout, null) != null ? true : false
            tfc_burst_bytes                       = try(ipsec_crypto_map.tfc_burst_bytes, null)
            tfc_payload_bytes                     = try(ipsec_crypto_map.tfc_payload_bytes, null)
            tfc_timeout                           = try(ipsec_crypto_map.tfc_timeout, null)
          }
        ]
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}:${item.interface}" => item
  }
}

resource "fmc_vpn_ra_ipsec_crypto_map" "vpn_ra_ipsec_crypto_map" {
  for_each = local.resource_vpn_ra_ipsec_crypto_map

  domain                                = each.value.domain
  vpn_ra_id                             = each.value.vpn_ra_id
  interface_id                          = each.value.interface_id
  ikev2_ipsec_proposals                 = each.value.ikev2_ipsec_proposals
  reverse_route_injection               = each.value.reverse_route_injection
  client_services                       = each.value.client_services
  client_services_port                  = each.value.client_services_port
  perfect_forward_secrecy               = each.value.perfect_forward_secrecy
  perfect_forward_secrecy_modulus_group = each.value.perfect_forward_secrecy_modulus_group
  lifetime_duration                     = each.value.lifetime_duration
  lifetime_size                         = each.value.lifetime_size
  validate_incoming_icmp_error_messages = each.value.validate_incoming_icmp_error_messages
  do_not_fragment_policy                = each.value.do_not_fragment_policy
  tfc                                   = each.value.tfc
  tfc_burst_bytes                       = each.value.tfc_burst_bytes
  tfc_payload_bytes                     = each.value.tfc_payload_bytes
  tfc_timeout                           = each.value.tfc_timeout
}

##########################################################
###    REMOTE ACCESS (RA) IPSEC IKE PARAMETERS
##########################################################
locals {
  resource_vpn_ra_ipsec_ike_parameters = {
    for item in flatten([
      for domain in local.domains : [
        for vpn_ra in try(domain.vpns.remote_access, {}) : {
          domain                                                    = domain.name
          vpn_ra_name                                               = vpn_ra.name
          vpn_ra_id                                                 = try(fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id, data.fmc_vpn_ra.vpn_ra["${domain.name}:${vpn_ra.name}"].id)
          ikev2_identity_sent_to_peer                               = try(vpn_ra.ipsec_ike_parameters.ikev2_identity_sent_to_peer, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_identity_sent_to_peer, null)
          ikev2_notification_on_tunnel_disconnect                   = try(vpn_ra.ipsec_ike_parameters.ikev2_notification_on_tunnel_disconnect, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_notification_on_tunnel_disconnect, null)
          ikev2_do_not_reboot_until_all_sessions_are_terminated     = try(vpn_ra.ipsec_ike_parameters.ikev2_do_not_reboot_until_all_sessions_are_terminated, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_do_not_reboot_until_all_sessions_are_terminated, null)
          ikev2_cookie_challenge                                    = try(vpn_ra.ipsec_ike_parameters.ikev2_cookie_challenge, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_cookie_challenge, null)
          ikev2_threshold_to_challenge_incoming_cookies             = try(vpn_ra.ipsec_ike_parameters.ikev2_threshold_to_challenge_incoming_cookies, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_threshold_to_challenge_incoming_cookies, null)
          ikev2_number_of_sas_allowed_in_negotiation                = try(vpn_ra.ipsec_ike_parameters.ikev2_number_of_sas_allowed_in_negotiation, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_number_of_sas_allowed_in_negotiation, null)
          ikev2_maximum_number_of_sas_allowed                       = try(vpn_ra.ipsec_ike_parameters.ikev2_maximum_number_of_sas_allowed, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ikev2_maximum_number_of_sas_allowed, null)
          ipsec_path_maximum_transmission_unit_aging                = try(vpn_ra.ipsec_ike_parameters.ipsec_path_maximum_transmission_unit_aging_reset_interval, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ipsec_path_maximum_transmission_unit_aging_reset_interval, null) != null ? true : false
          ipsec_path_maximum_transmission_unit_aging_reset_interval = try(vpn_ra.ipsec_ike_parameters.ipsec_path_maximum_transmission_unit_aging_reset_interval, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.ipsec_path_maximum_transmission_unit_aging_reset_interval, null)
          nat_keepalive_message_traversal                           = try(vpn_ra.ipsec_ike_parameters.nat_keepalive_message_traversal_interval, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.nat_keepalive_message_traversal_interval, null) != null ? true : null
          nat_keepalive_message_traversal_interval                  = try(vpn_ra.ipsec_ike_parameters.nat_keepalive_message_traversal_interval, local.defaults.fmc.domains.vpns.remote_access.ipsec_ike_parameters.nat_keepalive_message_traversal_interval, null)
        } if contains(keys(vpn_ra), "ipsec_ike_parameters")
      ]
    ]) : "${item.domain}:${item.vpn_ra_name}" => item
  }
}

resource "fmc_vpn_ra_ipsec_ike_parameters" "vpn_ra_ipsec_ike_parameters" {
  for_each = local.resource_vpn_ra_ipsec_ike_parameters

  domain                                                    = each.value.domain
  vpn_ra_id                                                 = each.value.vpn_ra_id
  ikev2_identity_sent_to_peer                               = each.value.ikev2_identity_sent_to_peer
  ikev2_notification_on_tunnel_disconnect                   = each.value.ikev2_notification_on_tunnel_disconnect
  ikev2_do_not_reboot_until_all_sessions_are_terminated     = each.value.ikev2_do_not_reboot_until_all_sessions_are_terminated
  ikev2_cookie_challenge                                    = each.value.ikev2_cookie_challenge
  ikev2_threshold_to_challenge_incoming_cookies             = each.value.ikev2_threshold_to_challenge_incoming_cookies
  ikev2_number_of_sas_allowed_in_negotiation                = each.value.ikev2_number_of_sas_allowed_in_negotiation
  ikev2_maximum_number_of_sas_allowed                       = each.value.ikev2_maximum_number_of_sas_allowed
  ipsec_path_maximum_transmission_unit_aging                = each.value.ipsec_path_maximum_transmission_unit_aging
  ipsec_path_maximum_transmission_unit_aging_reset_interval = each.value.ipsec_path_maximum_transmission_unit_aging_reset_interval
  nat_keepalive_message_traversal                           = each.value.nat_keepalive_message_traversal
  nat_keepalive_message_traversal_interval                  = each.value.nat_keepalive_message_traversal_interval
}
