###
# SMART LICENSE
###
resource "fmc_smart_license" "license" {
  count = can(local.model.fmc.smartlicense) ? 1 : 0

  # Mandatory
  registration_type = try(local.model.fmc.smartlicense.registration_type, null)

  # Optional
  token  = try(local.model.fmc.smartlicense.token, null)
  retain = try(local.model.fmc.smartlicense.retain, local.defaults.fmc.smartlicense.retain, null)
  force  = try(local.model.fmc.force, local.defaults.fmc.smartlicense.force, null)
}
