## 0.0.5 (Unreleased)

- (BREAKING CHANGE) Rename `after_destroy_policy` to `after_destroy_access_policy`
- (Fix) Module fails, if no input is provided
- (Fix) NAT Policy is not assigned to existing devices
- (Fix) Variable Sets are not assigned correctly to Access Control Policy Rules
- (Enh) Add support for Health Policy
- (Enh) Add support for FTD Platform Settings

## 0.0.4

- (Change) Update FMC Terraform provider to 2.0.0-rc6
- (Fix) Fix problem with passing data model through `model` variable
- (Enh) Add `applications` support for Access Control Policy rules

## 0.0.3

- (Change) Update FMC Terraform provider to 2.0.0-rc3
- (Change) Use Terraform functions to merge YAML content instead of data sources
- (Fix) Update BGP to reflect changes in the Terraform provider
- (Fix) Update multiple fields definitions
- (Fix) Update Security Zones definition
- (Enh) Add support for cdFMC (cloud-delivered FMC)
- (Enh) Add support for ipv4_address_pools
- (Enh) Add support for ipv6_address_pools
- (Enh) Add support for ipv6_static_routes
- (Enh) Add support for ise_sgts and device_types
- (Enh) Add support for network_analysis_policy

## 0.0.2

- Fix of README
- Fix to existing objects yaml read
- Fix of defaults - removing keys 'Global' in domains and vrfs
- adding support for application filters

## 0.0.1

- Initial release
