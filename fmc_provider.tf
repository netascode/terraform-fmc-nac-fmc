###
# PROVIDER
###
locals {
  envs = fileexists(".env") ? { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) } : null
}

provider "fmc" {
  fmc_username             = try(local.fmc.username, local.envs["FMC_USERNAME"], var.FMC_USERNAME)
  fmc_password             = try(local.fmc.password, local.envs["FMC_PASSWORD"], var.FMC_PASSWORD)
  fmc_host                 = try(local.fmc.hostname, local.envs["FMC_HOSTNAME"])
  fmc_insecure_skip_verify = try(local.fmc.skip_ssl_verify, local.defaults.fmc.skip_ssl_verify, true)
}
