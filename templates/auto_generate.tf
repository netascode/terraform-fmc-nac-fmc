locals {
  template_data = {
    number_of_rules = var.supported_number_of_rules
  }

}

###
# ACCESS RULE - AUTO GENERATE
###
resource "local_file" "access_rule" {
  content = replace(
    templatefile("./fmc_tpl_accessrule.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_access_rules.tf"
}

###
# FTD MANUAL NAT RULE
###
resource "local_file" "ftdmanualnatrule" {
  content = replace(
    templatefile("./fmc_tpl_ftdmanualnatrule.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_ftdmanualnatrule.tf"
}

###
# DEPLOY
###
resource "local_file" "deploy" {
  content = replace(
    templatefile("./fmc_tpl_deploy.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_deploy.tf"
}