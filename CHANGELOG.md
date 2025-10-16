## 0.0.6 (Unreleased)

!!!!
- (BREAKING CHANGE) Resources have names changed. Upgrading from any previous version will trigger re-create of all the resources.
It is suggested to:
- destroy current environment and re-apply it after upgrade
- OR remove state and import resources from FMC without destroying them
!!!!

- (BREAKING CHANGE) Unified name as `access_control_policy` under fmc.system.policy_assignment, fmc.domains.policies, existing.fmc.domain.policies, fmc.domains.devices.devices
- (BREAKING CHANGE) Unified name as `syslog_alert` and `snmp_alert` in Prefilter Policy and Prefilter Rules
- (BREAKING CHANGE) Moved `bfds` configuration to `vrfs` section in fmc.domains.devices.devices
- (BREAKING CHANGE) Physical, sub and etherchannel interface: Renamed multiple `ipv6` related attributes
- (BREAKING CHANGE) Access Control Policy: renamed `log_begin` and `log_end` to `log_connection_begin` and `log_connection_end` to align with Access Rules
- (BREAKING CHANGE) Access Control Policy and Access Rules: renamed `enable_syslog` to `send_syslog`
- (BREAKING CHANGE) BFD Template: Rename multiple fields
- (BREAKING CHANGE) Renamed existing.fmc.domains.objects.[standard_acl, extended_acl] to standard_access_lists and extended_access_lists to align with names used in fmc.objects
- (Enh) Add support for switch between bulk and individual operations for subset of objects (see: fmc.module_configuration)
- (Enh) Add support for `application filters` and `tunnel zones`

## 0.0.5

- (BREAKING CHANGE) Rename `after_destroy_policy` to `after_destroy_access_policy`
- (Change) Update FMC Terraform provider to 2.0.0-rc7
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
