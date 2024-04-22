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
    templatefile("./fmc_access_rules.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_access_rules.tf"
}

###
# FTD MANUAL NAT RULE
###
resource "local_file" "ftdmanualnatrule" {
  content = replace(
    templatefile("./fmc_ftd_manual_nat_rulea.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_ftd_manual_nat_rules.tf"
}

###
# DEPLOY
###
resource "local_file" "deploy" {
  content = replace(
    templatefile("./fmc_deploy.tftpl", local.template_data),
    "/(?m)(?s)(^( )*[\r\n])/", ""
  )
  filename = "../fmc_deploy.tf"
}