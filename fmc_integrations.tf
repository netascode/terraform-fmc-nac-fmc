##########################################################
###    REALM AD LDAP
##########################################################
locals {
  data_realm_ad_ldap = {
    for item in flatten([
      for domain in local.data_existing : [
        for realm_ad_ldap in try(domain.integrations.ad_ldap_realms, {}) : {
          name   = realm_ad_ldap.name
          domain = domain.name
        }
      ]
    ]) : "${item.domain}:${item.name}" => item
  }

  resource_realm_ad_ldap = {
    for item in flatten([
      for domain in local.domains : [
        for realm_ad_ldap in try(domain.integrations.ad_ldap_realms, []) : {
          domain             = domain.name
          name               = realm_ad_ldap.name
          realm_type         = realm_ad_ldap.realm_type
          base_dn            = realm_ad_ldap.base_dn
          group_dn           = realm_ad_ldap.group_dn
          directory_username = realm_ad_ldap.directory_username
          directory_password = realm_ad_ldap.directory_password
          directory_servers = [for server in realm_ad_ldap.directory_servers : {
            hostname            = server.hostname
            port                = server.port
            encryption_protocol = server.encryption_protocol
            ca_certificate_id = try(server.ca_certificate, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_trusted_certificate_authorities["${domain_path}:${server.ca_certificate}"].id
              if contains(keys(local.map_trusted_certificate_authorities), "${domain_path}:${server.ca_certificate}")
            })[0] : null
            interface_group_id = try(server.interface_group, null) != null ? values({
              for domain_path in local.related_domains[domain.name] :
              domain_path => local.map_interface_groups["${domain_path}:${server.interface_group}"].id
              if contains(keys(local.map_interface_groups), "${domain_path}:${server.interface_group}")
            })[0] : null
            use_routing_to_select_interface = try(server.use_routing_to_select_interface, local.defaults.fmc.domains.integrations.ad_ldap_realms.directory_servers.use_routing_to_select_interface, null)
          }]
          ad_join_username                        = try(realm_ad_ldap.ad_join_username, null)
          ad_join_password                        = try(realm_ad_ldap.ad_join_password, null)
          ad_primary_domain                       = try(realm_ad_ldap.ad_primary_domain, null)
          description                             = try(realm_ad_ldap.description, null)
          enabled                                 = try(realm_ad_ldap.enabled, local.defaults.fmc.domains.integrations.ad_ldap_realms.enabled, null)
          excluded_groups                         = try(realm_ad_ldap.excluded_groups, null)
          excluded_users                          = try(realm_ad_ldap.excluded_users, null)
          group_attribute                         = try(realm_ad_ldap.group_attribute, local.defaults.fmc.domains.integrations.ad_ldap_realms.group_attribute, null)
          included_groups                         = try(realm_ad_ldap.included_groups, null)
          included_users                          = try(realm_ad_ldap.included_users, null)
          timeout_captive_portal_users            = try(realm_ad_ldap.timeout_captive_portal_users, local.defaults.fmc.domains.integrations.ad_ldap_realms.timeout_captive_portal_users, null)
          timeout_failed_captive_portal_users     = try(realm_ad_ldap.timeout_failed_captive_portal_users, local.defaults.fmc.domains.integrations.ad_ldap_realms.timeout_failed_captive_portal_users, null)
          timeout_guest_captive_portal_users      = try(realm_ad_ldap.timeout_guest_captive_portal_users, local.defaults.fmc.domains.integrations.ad_ldap_realms.timeout_guest_captive_portal_users, null)
          timeout_ise_and_passive_indentity_users = try(realm_ad_ldap.timeout_ise_and_passive_indentity_users, local.defaults.fmc.domains.integrations.ad_ldap_realms.timeout_ise_and_passive_indentity_users, null)
          timeout_terminal_server_agent_users     = try(realm_ad_ldap.timeout_terminal_server_agent_users, local.defaults.fmc.domains.integrations.ad_ldap_realms.timeout_terminal_server_agent_users, null)
          update_hour                             = try(realm_ad_ldap.update_hour, local.defaults.fmc.domains.integrations.ad_ldap_realms.update_hour, null)
          update_interval                         = try(realm_ad_ldap.update_interval, local.defaults.fmc.domains.integrations.ad_ldap_realms.update_interval, null)
        } if !contains(try(keys(local.data_realm_ad_ldap), []), "${domain.name}:${realm_ad_ldap.name}")
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_realm_ad_ldap" "realm_ad_ldap" {
  for_each = local.data_realm_ad_ldap

  name   = each.value.name
  domain = each.value.domain
}

resource "fmc_realm_ad_ldap" "realm_ad_ldap" {
  for_each = local.resource_realm_ad_ldap

  domain                                  = each.value.domain
  name                                    = each.value.name
  realm_type                              = each.value.realm_type
  base_dn                                 = each.value.base_dn
  group_dn                                = each.value.group_dn
  directory_username                      = each.value.directory_username
  directory_password                      = each.value.directory_password
  directory_servers                       = each.value.directory_servers
  ad_join_username                        = each.value.ad_join_username
  ad_join_password                        = each.value.ad_join_password
  ad_primary_domain                       = each.value.ad_primary_domain
  description                             = each.value.description
  enabled                                 = each.value.enabled
  excluded_groups                         = each.value.excluded_groups
  excluded_users                          = each.value.excluded_users
  group_attribute                         = each.value.group_attribute
  included_groups                         = each.value.included_groups
  included_users                          = each.value.included_users
  timeout_captive_portal_users            = each.value.timeout_captive_portal_users
  timeout_failed_captive_portal_users     = each.value.timeout_failed_captive_portal_users
  timeout_guest_captive_portal_users      = each.value.timeout_guest_captive_portal_users
  timeout_ise_and_passive_indentity_users = each.value.timeout_ise_and_passive_indentity_users
  timeout_terminal_server_agent_users     = each.value.timeout_terminal_server_agent_users
  update_hour                             = each.value.update_hour
  update_interval                         = each.value.update_interval
}
