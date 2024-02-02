module "ise" {
  source  = "netascode/nac-fmc/fmc"
  version = ">= 0.1.0"

  yaml_files = ["host.yaml"]
}
