module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"

  yaml_files = ["fmc.yaml", "existing.yaml"]
}
