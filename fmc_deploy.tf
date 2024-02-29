###
# DEPLOY
###
locals {
  res_deploy = flatten([
    for domains in local.domains : [
      for object in try(domains.devices, []) : {
        device                = object.name
        deploy_ignore_warning = try(object.deploy_ignore_warning, local.defaults.fmc.domains.devices.deploy_ignore_warning, null)
        deploy_force          = try(object.deploy_force, local.defaults.fmc.domains.devices.deploy_force, null)
      } if try(object.deploy, false)
    ]
  ])

  deploy_template = {
    accessrules       = local.res_accessrules,
    ftdmanualnatrules = local.res_ftdmanualnatrules,
    networkgroups     = local.res_networkgroups
  }
}

resource "local_file" "deploy" {
  count = var.deploy_support ? 1 : 0
  content = replace(
    templatefile("${path.module}/templates/fmc_tpl_deploy.tftpl", local.deploy_template),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "${path.module}/generated_fmc_deploy.tf"
}
