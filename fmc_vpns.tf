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
            allow_incoming_ikev2_routes = try(endpoint.allow_incoming_ikev2_routes, null)
            backup_interface_id = try(endpoint.backup_interface_logical_name, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_interfaces_by_logical_names["${domain_path}:${endpoint.name}:${endpoint.backup_interface_logical_name}"].id
              if contains(keys(local.map_interfaces_by_logical_names), "${domain_path}:${endpoint.name}:${endpoint.backup_interface_logical_name}")
            })[0] : null
            backup_interface_public_ip_address = try(endpoint.backup_interface_public_ip_address, null)
            backup_local_identity_type         = try(endpoint.backup_local_identity_type, null)
            backup_local_identity_string       = try(endpoint.backup_local_identity_string, null)
            connection_type                    = try(endpoint.connection_type, null)
            device_id = endpoint.extranet_device == false ? (
              values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_devices["${domain_path}:${endpoint.name}"].id
                if contains(keys(local.map_devices), "${domain_path}:${endpoint.name}")
              })[0]
            ) : null
            extranet_dynamic_ip = try(endpoint.extranet_dynamic_ip, null)
            extranet_ip_address = try(endpoint.extranet_ip_address, null)
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
              domain_path => local.map_interfaces_by_logical_names["${domain_path}:${endpoint.name}:${endpoint.nat_exemption_inside_interface}"].id
              if contains(keys(local.map_interfaces_by_logical_names), "${domain_path}:${endpoint.name}:${endpoint.nat_exemption_inside_interface}")
            })[0] : null
            nat_traversal                     = try(endpoint.nat_traversal, null)
            override_remote_vpn_filter_acl_id = null ######## TODO
            protected_networks = [for protected_network in try(endpoint.protected_networks, []) : {
              id = values({
                for domain_path in local.related_domains[domain.name] :
                domain_path => local.map_network_objects["${domain_path}:${protected_network}"].id
                if contains(keys(local.map_network_objects), "${domain_path}:${protected_network}")
              })[0]
            }]
            protected_networks_acl_id        = null ######## TODO
            reverse_route_injection          = try(endpoint.reverse_route_injection, null)
            send_vti_ip_to_peer              = try(endpoint.send_vti_ip_to_peer, null)
            send_tunnel_interface_ip_to_peer = try(endpoint.send_tunnel_interface_ip_to_peer, null)
            vpn_filter_acl_id                = null ######## TODO
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
          ikev2_enforce_hex_based_pre_shared_key = try(vpn_s2s.ike_settings.ikev2_enforce_hex_based_pre_shared_key, null)
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
          do_not_fragment_policy = try(vpn_s2s.ipsec_settings.do_not_fragment_policy, null)
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
          ikev2_mode                                = try(vpn_s2s.ipsec_settings.ikev2_mode, null)
          lifetime_duration                         = try(vpn_s2s.ipsec_settings.lifetime_duration, null)
          lifetime_size                             = try(vpn_s2s.ipsec_settings.lifetime_size, null)
          perfect_forward_secrecy                   = try(vpn_s2s.ipsec_settings.perfect_forward_secrecy, null)
          perfect_forward_secrecy_modulus_group     = try(vpn_s2s.ipsec_settings.perfect_forward_secrecy_modulus_group, null)
          reverse_route_injection                   = try(vpn_s2s.ipsec_settings.reverse_route_injection, null)
          security_association_strength_enforcement = try(vpn_s2s.ipsec_settings.security_association_strength_enforcement, null)
          tfc                                       = try(vpn_s2s.ipsec_settings.tfc, null)
          tfc_burst_bytes                           = try(vpn_s2s.ipsec_settings.tfc_burst_bytes, null)
          tfc_payload_bytes                         = try(vpn_s2s.ipsec_settings.tfc_payload_bytes, null)
          tfc_timeout                               = try(vpn_s2s.ipsec_settings.tfc_timeout, null)
          validate_incoming_icmp_error_messages     = try(vpn_s2s.ipsec_settings.validate_incoming_icmp_error_messages, null)
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
          ike_keepalive                                                       = try(vpn_s2s.advanced_settings.ike_keepalive, null)
          ike_keepalive_threshold                                             = try(vpn_s2s.advanced_settings.ike_keepalive_threshold, null)
          ike_keepalive_retry_interval                                        = try(vpn_s2s.advanced_settings.ike_keepalive_retry_interval, null)
          ike_identity_sent_to_peers                                          = try(vpn_s2s.advanced_settings.ike_identity_sent_to_peers, null)
          ike_peer_identity_validation                                        = try(vpn_s2s.advanced_settings.ike_peer_identity_validation, null)
          ike_aggressive_mode                                                 = try(vpn_s2s.advanced_settings.ike_aggressive_mode, null)
          ike_notification_on_tunnel_disconnect                               = try(vpn_s2s.advanced_settings.ike_notification_on_tunnel_disconnect, null)
          ikev2_cookie_challenge                                              = try(vpn_s2s.advanced_settings.ikev2_cookie_challenge, null)
          ikev2_threshold_to_challenge_incoming_cookies                       = try(vpn_s2s.advanced_settings.ikev2_threshold_to_challenge_incoming_cookies, null)
          ikev2_number_of_sas_allowed_in_negotiation                          = try(vpn_s2s.advanced_settings.ikev2_number_of_sas_allowed_in_negotiation, null)
          ikev2_maximum_number_of_sas_allowed                                 = try(vpn_s2s.advanced_settings.ikev2_maximum_number_of_sas_allowed, null)
          ipsec_fragmentation_before_encryption                               = try(vpn_s2s.advanced_settings.ipsec_fragmentation_before_encryption, null)
          ipsec_path_maximum_transmission_unit_aging_reset_interval           = try(vpn_s2s.advanced_settings.ipsec_path_maximum_transmission_unit_aging_reset_interval, null)
          spoke_to_spoke_connectivity_through_hub                             = try(vpn_s2s.advanced_settings.spoke_to_spoke_connectivity_through_hub, null)
          nat_keepalive_message_traversal                                     = try(vpn_s2s.advanced_settings.nat_keepalive_message_traversal_interval, null) != null ? true : null
          nat_keepalive_message_traversal_interval                            = try(vpn_s2s.advanced_settings.nat_keepalive_message_traversal_interval, null)
          vpn_idle_timeout                                                    = try(vpn_s2s.advanced_settings.vpn_idle_timeout_value, null) != null ? true : null
          vpn_idle_timeout_value                                              = try(vpn_s2s.advanced_settings.vpn_idle_timeout_value, null)
          sgt_propagation_over_vti                                            = try(vpn_s2s.advanced_settings.sgt_propagation_over_vti, null)
          bypass_access_control_policy_for_decrypted_traffic                  = try(vpn_s2s.advanced_settings.bypass_access_control_policy_for_decrypted_traffic, null)
          cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel = try(vpn_s2s.advanced_settings.cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel, null)
          cert_use_ou_to_determine_tunnel                                     = try(vpn_s2s.advanced_settings.cert_use_ou_to_determine_tunnel, null)
          cert_use_ike_identity_to_determine_tunnel                           = try(vpn_s2s.advanced_settings.cert_use_ike_identity_to_determine_tunnel, null)
          cert_use_peer_ip_address_to_determine_tunnel                        = try(vpn_s2s.advanced_settings.cert_use_peer_ip_address_to_determine_tunnel, null)
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
  sgt_propagation_over_vti                                            = each.value.sgt_propagation_over_vti
  bypass_access_control_policy_for_decrypted_traffic                  = each.value.bypass_access_control_policy_for_decrypted_traffic
  cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel = each.value.cert_use_certificate_map_configured_in_endpoint_to_determine_tunnel
  cert_use_ou_to_determine_tunnel                                     = each.value.cert_use_ou_to_determine_tunnel
  cert_use_ike_identity_to_determine_tunnel                           = each.value.cert_use_ike_identity_to_determine_tunnel
  cert_use_peer_ip_address_to_determine_tunnel                        = each.value.cert_use_peer_ip_address_to_determine_tunnel
}
