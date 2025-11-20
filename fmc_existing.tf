#############################################################
# Terraform data representation of objects that already exist on FMC
# for which we do not have corresponding resource definitions.
##########################################################


##########################################################
###    VARIABLE SETS
##########################################################
locals {
  data_variable_set = {
    for item in flatten([
      for domain in local.data_existing : [
        for variable_set in try(domain.objects.variable_sets, {}) : {
          name   = variable_set.name
          domain = domain.name
        } if length(try(domain.objects.variable_sets, [])) > 0
      ]
    ]) : "${item.domain}:${item.name}" => item
  }
}

data "fmc_variable_set" "variable_set" {
  for_each = local.data_variable_set

  name   = each.value.name
  domain = each.value.domain
}

##########################################################
###    SNMP ALERTS
##########################################################
locals {
  data_snmp_alerts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for snmp in try(domain.policies.alerts.snmps, {}) : snmp.name => {}
      }
    } if length(try(domain.policies.alerts.snmps, [])) > 0
  }
}

data "fmc_snmp_alerts" "snmp_alerts" {
  for_each = local.data_snmp_alerts

  items  = each.value.items
  domain = each.key
}

##########################################################
###    SYSLOG ALERTS
##########################################################
locals {
  data_syslog_alerts = {
    for domain in local.data_existing : domain.name => {
      items = {
        for syslog in try(domain.policies.alerts.syslogs, {}) : syslog.name => {}
      }
    } if length(try(domain.policies.alerts.syslogs, [])) > 0
  }
}

data "fmc_syslog_alerts" "syslog_alerts" {
  for_each = local.data_syslog_alerts

  items  = each.value.items
  domain = each.key
}

##########################################################
###    FILE TYPES
##########################################################
locals {
  data_file_types = {
    for domain in local.data_existing : domain.name => {
      items = {
        for file_type in try(domain.objects.file_types, {}) : file_type.name => {}
      }
    } if length(try(domain.objects.file_types, [])) > 0
  }
}

data "fmc_file_types" "file_types" {
  for_each = local.data_file_types

  items  = each.value.items
  domain = each.key
}

##########################################################
###    FILE CATEGORIES
##########################################################
locals {
  data_file_categories = {
    for domain in local.data_existing : domain.name => {
      items = {
        for file_category in try(domain.objects.file_categories, {}) : file_category.name => {}
      }
    } if length(try(domain.objects.file_categories, [])) > 0
  }
}

data "fmc_file_categories" "file_categories" {
  for_each = local.data_file_categories

  items  = each.value.items
  domain = each.key
}

##########################################################
###    APPLICATIONS & APPLICATION FILTERS
##########################################################
locals {
  data_applications = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application in try(domain.objects.applications, {}) : application.name => {}
      }
    } if length(try(domain.objects.applications, [])) > 0
  }
}

data "fmc_applications" "applications" {
  for_each = local.data_applications

  items  = each.value.items
  domain = each.key
}

locals {
  data_application_business_relevances = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_business_relevance in try(domain.objects.application_filter_conditions.business_relevances, {}) : application_business_relevance.name => {}
      }
    } if length(try(domain.objects.application_filter_conditions.business_relevances, [])) > 0
  }
}

data "fmc_application_business_relevances" "application_business_relevances" {
  for_each = local.data_application_business_relevances

  items  = each.value.items
  domain = each.key
}

locals {
  data_application_categories = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_category in try(domain.objects.application_filter_conditions.categories, {}) : application_category.name => {}
      }
    } if length(try(domain.objects.application_filter_conditions.categories, [])) > 0
  }
}

data "fmc_application_categories" "application_categories" {
  for_each = local.data_application_categories

  items  = each.value.items
  domain = each.key
}

locals {
  data_application_risks = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_risk in try(domain.objects.application_filter_conditions.risks, {}) : application_risk.name => {}
      }
    } if length(try(domain.objects.application_filter_conditions.risks, [])) > 0
  }
}

data "fmc_application_risks" "application_risks" {
  for_each = local.data_application_risks

  items  = each.value.items
  domain = each.key
}

locals {
  data_application_tags = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_tag in try(domain.objects.application_filter_conditions.tags, {}) : application_tag.name => {}
      }
    } if length(try(domain.objects.application_filter_conditions.tags, [])) > 0
  }
}

data "fmc_application_tags" "application_tags" {
  for_each = local.data_application_tags

  items  = each.value.items
  domain = each.key
}

locals {
  data_application_types = {
    for domain in local.data_existing : domain.name => {
      items = {
        for application_type in try(domain.objects.application_filter_conditions.types, {}) : application_type.name => {}
      }
    } if length(try(domain.objects.application_filter_conditions.types, [])) > 0
  }
}

data "fmc_application_types" "application_types" {
  for_each = local.data_application_types

  items  = each.value.items
  domain = each.key
}

##########################################################
###    ENDPOINT DEVICE TYPES
##########################################################
locals {
  data_endpoint_device_types = {
    for domain in local.data_existing : domain.name => {
      items = {
        for endpoint_device_type in try(domain.objects.endpoint_device_types, []) : endpoint_device_type.name => {}
      }
    } if length(try(domain.objects.endpoint_device_types, [])) > 0
  }

}

data "fmc_endpoint_device_types" "endpoint_device_types" {
  for_each = local.data_endpoint_device_types

  items  = each.value.items
  domain = each.key
}