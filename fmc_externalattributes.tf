###
# DYNAMIC OBJECTS
###
locals {
  res_dynamicobjects = flatten([
    for domains in local.domain : [
      for object in try(domains.dynamicobject, []) : object if !contains(local.data_dynamicobjects, object.name)
    ]
  ])
}

resource "fmc_dynamic_objects" "dynamicobject" {
  for_each = { for dynobj in local.res_dynamicobjects : dynobj.name => dynobj }

  # Mandatory
  name        = each.value.name
  object_type = try(each.value.object_type, local.defaults.fmc.domain.dynamicobject.object_type)

  # Optional
  description = try(each.value.description, local.defaults.fmc.domain.host.description, null)
}

###
# SGT
###
locals {
  res_sgts = flatten([
    for domains in local.domain : [
      for object in try(domains.sgt, []) : object if !contains(local.data_sgts, object.name)
    ]
  ])
}

resource "fmc_sgt_objects" "sgt" {
  for_each = { for sgt in local.res_sgts : sgt.name => sgt }

  # Mandatory
  name = each.value.name
  tag  = each.value.tag

  # Optional
  type        = "SecurityGroupTag"
  description = try(each.value.description, local.defaults.fmc.domain.sgt.description, null)
}
