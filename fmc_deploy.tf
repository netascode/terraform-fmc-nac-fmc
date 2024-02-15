###
# DEPLOY
###
locals {
  deploy_template = {
    accessrules       = local.res_accessrules,
    ftdmanualnatrules = local.res_ftdmanualnatrules,
    networkgroups     = local.res_networkgroups
  }
}

resource "local_file" "deploy" {
  count = var.deploy_support ? 1 : 0
  content = replace(
    templatefile("${path.module}/fmc_tpl_deploy.tftpl", local.deploy_template),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "${path.module}/generated_fmc_deploy.tf"
}
