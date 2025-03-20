module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">=0.0.1"

  yaml_directories = ["data"]
}
