###
# SMART LICENSE
###
resource "fmc_smart_license" "license" {
  count = can(local.model.fmc.smart_license) ? 1 : 0

  # Mandatory
  registration_type = try(local.model.fmc.smart_license.registration_type, null)

  # Optional
  token  = try(local.model.fmc.smart_license.token, null)
  retain = try(local.model.fmc.smart_license.retain, local.defaults.fmc.smart_license.retain, null)
  force  = try(local.model.fmc.smart_license.force, local.defaults.fmc.smart_license.force, null)
}
