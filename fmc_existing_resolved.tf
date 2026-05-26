locals {
  resolved_variable_sets = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_variable_sets :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_snmp_alerts = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_snmp_alerts :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

  resolved_syslog_alerts = {
    for domain_name, domain_paths in local.related_domains :
    domain_name => merge([
      for dp in reverse(domain_paths) : {
        for key, obj in local.map_syslog_alerts :
        substr(key, length(dp) + 1, -1) => obj
        if startswith(key, "${dp}:")
      }
    ]...)
  }

}