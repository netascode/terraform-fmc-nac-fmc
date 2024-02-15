###
# URL
###
locals {
  res_urls = flatten([
    for domains in local.domain : [
      for object in try(domains.url, []) : object if !contains(local.data_urls, object.name)
    ]
  ])
}

resource "fmc_url_objects" "url" {
  for_each = { for url in local.res_urls : url.name => url }

  # Mandatory
  name = each.value.name
  url  = each.value.url

  # Optional
  description = try(each.value.description, local.defaults.fmc.domain.url.description, null)
}

###
# URL GROUPS
###
locals {
  res_urlgroups = flatten([
    for domains in local.domain : [
      for object in try(domains.urlgroup, []) : object
    ]
  ])
}

resource "fmc_url_object_group" "urlgroup" {
  for_each = { for urlgrp in local.res_urlgroups : urlgrp.name => urlgrp }

  # Mandatory
  name = each.value.name

  dynamic "objects" {
    for_each = { for obj in try(each.value.objects, {}) :
      obj => obj
    }
    content {
      id   = local.map_urls[objects.value].id
      type = local.map_urls[objects.value].type
    }
  }

  dynamic "literals" {
    for_each = { for obj in try(each.value.literals, {}) :
      obj => obj
    }
    content {
      url = literals.value
    }
  }

  # Optional
  description = try(each.value.description, local.defaults.fmc.domain.host.description, null)
}
