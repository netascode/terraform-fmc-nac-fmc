######
### map_variable_sets
######
locals {
  map_variable_sets_internal = merge(

    # Variable Sets - data sources
    { for key, resource in data.fmc_variable_set.variable_set : "${resource.domain}:${resource.name}" => { id = resource.id, type = resource.type } },
  )

  map_variable_sets_external = {
    for key, value in try(local.data.objects.variable_sets, {}) : key => value
  }

  map_variable_sets = merge(
    local.map_variable_sets_internal,
    local.map_variable_sets_external,
  )
}

######
### map_snmp_alerts
######
locals {
  map_snmp_alerts_internal = merge(

    # SNMP Alerts - data sources
    merge([
      for domain, snmp_alerts in data.fmc_snmp_alerts.snmp_alerts : {
        for snmp_name, snmp_values in snmp_alerts.items : "${domain}:${snmp_name}" => { id = snmp_values.id, type = snmp_values.type }
      }
    ]...),
  )

  map_snmp_alerts_external = {
    for key, value in try(local.data.policies.snmp_alerts, {}) : key => value
  }

  map_snmp_alerts = merge(
    local.map_snmp_alerts_internal,
    local.map_snmp_alerts_external,
  )
}

######
### map_syslog_alerts
######
locals {
  map_syslog_alerts_internal = merge(

    # Syslog Alerts - data sources
    merge([
      for domain, syslog_alerts in data.fmc_syslog_alerts.syslog_alerts : {
        for syslog_name, syslog_values in syslog_alerts.items : "${domain}:${syslog_name}" => { id = syslog_values.id, type = syslog_values.type }
      }
    ]...),
  )

  map_syslog_alerts_external = {
    for key, value in try(local.data.policies.syslog_alerts, {}) : key => value
  }

  map_syslog_alerts = merge(
    local.map_syslog_alerts_internal,
    local.map_syslog_alerts_external,
  )
}

######
### map_file_types
######
locals {
  map_file_types_internal = merge(

    # File Types - data sources
    merge([
      for domain, file_types in data.fmc_file_types.file_types : {
        for file_type_name, file_type_values in file_types.items : "${domain}:${file_type_name}" => { id = file_type_values.id, type = file_type_values.type }
      }
    ]...),
  )

  map_file_types_external = {
    for key, value in try(local.data.objects.file_types, {}) : key => value
  }

  map_file_types = merge(
    local.map_file_types_internal,
    local.map_file_types_external,
  )
}

######
### map_file_categories
######
locals {
  map_file_categories_internal = merge(

    # File Categories - data sources
    merge([
      for domain, file_categories in data.fmc_file_categories.file_categories : {
        for file_category_name, file_category_values in file_categories.items : "${domain}:${file_category_name}" => { id = file_category_values.id, type = file_category_values.type }
      }
    ]...),
  )

  map_file_categories_external = {
    for key, value in try(local.data.objects.file_categories, {}) : key => value
  }

  map_file_categories = merge(
    local.map_file_categories_internal,
    local.map_file_categories_external,
  )
}

######
### map_applications
######
locals {
  map_applications_internal = merge(

    # Applications - data sources
    merge([
      for domain, applications in data.fmc_applications.applications : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_applications_external = {
    for key, value in try(local.data.objects.applications, {}) : key => value
  }

  map_applications = merge(
    local.map_applications_internal,
    local.map_applications_external,
  )
}

######
### map_application_business_relevances
######
locals {
  map_application_business_relevances_internal = merge(

    # Application Business Relevances - data sources
    merge([
      for domain, applications in data.fmc_application_business_relevances.application_business_relevances : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_application_business_relevances_external = {
    for key, value in try(local.data.objects.application_business_relevances, {}) : key => value
  }

  map_application_business_relevances = merge(
    local.map_application_business_relevances_internal,
    local.map_application_business_relevances_external,
  )
}

######
### map_application_categories
######
locals {
  map_application_categories_internal = merge(

    # Application Categories - data sources
    merge([
      for domain, applications in data.fmc_application_categories.application_categories : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_application_categories_external = {
    for key, value in try(local.data.objects.application_categories, {}) : key => value
  }

  map_application_categories = merge(
    local.map_application_categories_internal,
    local.map_application_categories_external,
  )
}

######
### map_application_risks
######
locals {
  map_application_risks_internal = merge(

    # Application Risks - data sources
    merge([
      for domain, applications in data.fmc_application_risks.application_risks : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_application_risks_external = {
    for key, value in try(local.data.objects.application_risks, {}) : key => value
  }

  map_application_risks = merge(
    local.map_application_risks_internal,
    local.map_application_risks_external,
  )
}

######
### map_application_tags
######
locals {
  map_application_tags_internal = merge(

    # Application Tags - data sources
    merge([
      for domain, applications in data.fmc_application_tags.application_tags : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_application_tags_external = {
    for key, value in try(local.data.objects.application_tags, {}) : key => value
  }

  map_application_tags = merge(
    local.map_application_tags_internal,
    local.map_application_tags_external,
  )
}

######
### map_application_types
######
locals {
  map_application_types_internal = merge(

    # Application Types - data sources
    merge([
      for domain, application_types in data.fmc_application_types.application_types : {
        for application_type_name, application_type_values in application_types.items : "${domain}:${application_type_name}" => { id = application_type_values.id, type = application_type_values.type }
      }
    ]...),
  )

  map_application_types_external = {
    for key, value in try(local.data.objects.application_types, {}) : key => value
  }

  map_application_types = merge(
    local.map_application_types_internal,
    local.map_application_types_external,
  )
}

######
### map_endpoint_device_types
######
locals {
  map_endpoint_device_types_internal = merge(

    # Endpoint Device Types - data sources
    merge([
      for domain, applications in data.fmc_endpoint_device_types.endpoint_device_types : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_endpoint_device_types_external = {
    for key, value in try(local.data.objects.endpoint_device_types, {}) : key => value
  }

  map_endpoint_device_types = merge(
    local.map_endpoint_device_types_internal,
    local.map_endpoint_device_types_external,
  )
}

######
### map_countries
######
locals {
  map_countries_internal = merge(

    # Countries - data sources
    merge([
      for domain, applications in data.fmc_countries.countries : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_countries_external = {
    for key, value in try(local.data.objects.countries, {}) : key => value
  }

  map_countries = merge(
    local.map_countries_internal,
    local.map_countries_external,
  )
}

######
### map_continents
######
locals {
  map_continents_internal = merge(

    # Continents - data sources
    merge([
      for domain, applications in data.fmc_continents.continents : {
        for application_name, application_values in applications.items : "${domain}:${application_name}" => { id = application_values.id, type = application_values.type }
      }
    ]...),
  )

  map_continents_external = {
    for key, value in try(local.data.objects.continents, {}) : key => value
  }

  map_continents = merge(
    local.map_continents_internal,
    local.map_continents_external,
  )
}
