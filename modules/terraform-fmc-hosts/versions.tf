terraform {
  required_version = ">=1.8.0"

  required_providers {
    fmc = {
      source  = "CiscoDevNet/fmc"
      version = "2.0.0-rc6"
    }
  }

}
