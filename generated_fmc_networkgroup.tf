locals {
  map_res_networkgroups = {
    MyNetworkGroup1 = {
      id   = fmc_network_group_objects.MyNetworkGroup1.id
      type = fmc_network_group_objects.MyNetworkGroup1.type
    },
  }
}
resource "fmc_network_group_objects" "MyNetworkGroup1" {
  # Mandatory
  name = "MyNetworkGroup1"
  # Optional
  description = " "
  dynamic "objects" {
    for_each = { for netgrp in local.res_networkgroups[0].objects :
      netgrp => netgrp if contains(keys(local.map_networkobjects), netgrp)
    }
    content {
      id   = local.map_networkobjects[objects.value].id
      type = local.map_networkobjects[objects.value].type
    }
  }
  dynamic "literals" {
    for_each = try(local.res_networkgroups[0].literals, {})
    content {
      value = literals.value
      type  = can(regex("/", literals.value)) ? "Network" : "Host"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
