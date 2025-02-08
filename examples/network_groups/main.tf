module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = "2.0.0-beta0"

  yaml_files = ["fmc.yaml", "existing.yaml"]
}
