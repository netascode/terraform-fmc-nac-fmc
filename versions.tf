terraform {
  required_version = ">=1.5.7"

  required_providers {
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "2.0.0-beta1"
    }
    utils = {
      source  = "netascode/utils"
      version = ">=0.2.5"
    }
    local = {
      source  = "hashicorp/local"
      version = ">=2.3.0"
    }
  }
}
