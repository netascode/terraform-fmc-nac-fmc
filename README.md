<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco FMC Module

A Terraform module to configure Cisco FMC.

## Usage

This module supports an inventory driven approach, where a complete FMC configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Examples

Configuring a Network-group Object using YAML:

#### `data/existing.yaml`

```yaml
---
existing:
  fmc:
    domains:
      - name: Global
  
        objects:
  
          networks:
            - name: any-ipv4
```

#### `data/fmc.yaml`

```yaml
---
fmc:
  domains:
    - name: Global

      objects:

        hosts:
          - name: MyHost1
            ip: 10.10.10.10
          - name: MyHost2
            ip: 20.20.20.20

        network_groups:
          - name: MyNetworkGroup1
            objects:
              - MyHost1
              - any-ipv4
          - name: MyNetworkGroup2
            objects:
              - MyNetworkGroup1
              - MyHost2
```

#### `main.tf`

```hcl
module "fmc" {
  source  = "netascode/nac-fmc/fmc"
  version = ">=0.0.1"

  yaml_directories = ["data"]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.7 |
| <a name="requirement_fmc"></a> [fmc](#requirement\_fmc) | 2.0.0-beta3 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >=2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >=0.2.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_manage_deployment"></a> [manage\_deployment](#input\_manage\_deployment) | Enables support for FTD deployments | `bool` | `true` | no |
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | <pre>[<br/>  "data"<br/>]</pre> | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_fmc"></a> [fmc](#provider\_fmc) | 2.0.0-beta3 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.2 |
| <a name="provider_utils"></a> [utils](#provider\_utils) | 0.2.6 |  
## Resources

| Name | Type |
|------|------|
| [fmc_access_control_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/access_control_policy) | resource |
| [fmc_application_filters.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/application_filters) | resource |
| [fmc_bfd_template.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/bfd_template) | resource |
| [fmc_device.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device) | resource |
| [fmc_device_bfd.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_bfd) | resource |
| [fmc_device_bgp.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_bgp) | resource |
| [fmc_device_bgp_general_settings.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_bgp_general_settings) | resource |
| [fmc_device_cluster.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_cluster) | resource |
| [fmc_device_deploy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_deploy) | resource |
| [fmc_device_etherchannel_interface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_etherchannel_interface) | resource |
| [fmc_device_ha_pair.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_ha_pair) | resource |
| [fmc_device_ha_pair_monitoring.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_ha_pair_monitoring) | resource |
| [fmc_device_ipv4_static_route.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_ipv4_static_route) | resource |
| [fmc_device_physical_interface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_physical_interface) | resource |
| [fmc_device_subinterface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_subinterface) | resource |
| [fmc_device_vrf.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_vrf) | resource |
| [fmc_device_vrf_ipv4_static_route.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/device_vrf_ipv4_static_route) | resource |
| [fmc_dynamic_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/dynamic_objects) | resource |
| [fmc_extended_acl.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/extended_acl) | resource |
| [fmc_file_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/file_policy) | resource |
| [fmc_fqdn_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/fqdn_objects) | resource |
| [fmc_ftd_nat_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/ftd_nat_policy) | resource |
| [fmc_hosts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/hosts) | resource |
| [fmc_icmpv4_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/icmpv4_objects) | resource |
| [fmc_intrusion_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/intrusion_policy) | resource |
| [fmc_ipv4_address_pools.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/ipv4_address_pools) | resource |
| [fmc_ipv6_address_pools.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/ipv6_address_pools) | resource |
| [fmc_network_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/network_groups) | resource |
| [fmc_networks.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/networks) | resource |
| [fmc_policy_assignment.access_control_policy](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/policy_assignment) | resource |
| [fmc_port_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/port_groups) | resource |
| [fmc_ports.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/ports) | resource |
| [fmc_prefilter_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/prefilter_policy) | resource |
| [fmc_ranges.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/ranges) | resource |
| [fmc_security_zones.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/security_zones) | resource |
| [fmc_sgts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/sgts) | resource |
| [fmc_smart_license.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/smart_license) | resource |
| [fmc_standard_acl.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/standard_acl) | resource |
| [fmc_time_ranges.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/time_ranges) | resource |
| [fmc_tunnel_zones.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/tunnel_zones) | resource |
| [fmc_url_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/url_groups) | resource |
| [fmc_urls.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/urls) | resource |
| [fmc_vlan_tag_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/vlan_tag_groups) | resource |
| [fmc_vlan_tags.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/resources/vlan_tags) | resource |
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [fmc_access_control_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/access_control_policy) | data source |
| [fmc_application_business_relevances.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_business_relevances) | data source |
| [fmc_application_categories.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_categories) | data source |
| [fmc_application_filters.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_filters) | data source |
| [fmc_application_risks.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_risks) | data source |
| [fmc_application_tags.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_tags) | data source |
| [fmc_application_types.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/application_types) | data source |
| [fmc_applications.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/applications) | data source |
| [fmc_bfd_template.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/bfd_template) | data source |
| [fmc_device.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device) | data source |
| [fmc_device_bfd.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_bfd) | data source |
| [fmc_device_bgp_general_settings.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_bgp_general_settings) | data source |
| [fmc_device_cluster.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_cluster) | data source |
| [fmc_device_etherchannel_interface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_etherchannel_interface) | data source |
| [fmc_device_ha_pair.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_ha_pair) | data source |
| [fmc_device_physical_interface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_physical_interface) | data source |
| [fmc_device_subinterface.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_subinterface) | data source |
| [fmc_device_vrf.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/device_vrf) | data source |
| [fmc_dynamic_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/dynamic_objects) | data source |
| [fmc_endpoint_device_types.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/endpoint_device_types) | data source |
| [fmc_extended_acl.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/extended_acl) | data source |
| [fmc_file_categories.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/file_categories) | data source |
| [fmc_file_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/file_policy) | data source |
| [fmc_file_types.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/file_types) | data source |
| [fmc_fqdn_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/fqdn_objects) | data source |
| [fmc_ftd_nat_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ftd_nat_policy) | data source |
| [fmc_hosts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/hosts) | data source |
| [fmc_icmpv4_objects.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/icmpv4_objects) | data source |
| [fmc_intrusion_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/intrusion_policy) | data source |
| [fmc_ipv4_address_pools.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ipv4_address_pools) | data source |
| [fmc_ipv6_address_pools.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ipv6_address_pools) | data source |
| [fmc_ise_sgts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ise_sgts) | data source |
| [fmc_networks.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/networks) | data source |
| [fmc_port_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/port_groups) | data source |
| [fmc_ports.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ports) | data source |
| [fmc_prefilter_policy.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/prefilter_policy) | data source |
| [fmc_ranges.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/ranges) | data source |
| [fmc_security_zones.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/security_zones) | data source |
| [fmc_sgts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/sgts) | data source |
| [fmc_snmp_alerts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/snmp_alerts) | data source |
| [fmc_standard_acl.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/standard_acl) | data source |
| [fmc_syslog_alerts.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/syslog_alerts) | data source |
| [fmc_time_ranges.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/time_ranges) | data source |
| [fmc_tunnel_zones.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/tunnel_zones) | data source |
| [fmc_url_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/url_groups) | data source |
| [fmc_urls.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/urls) | data source |
| [fmc_variable_set.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/variable_set) | data source |
| [fmc_vlan_tag_groups.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/vlan_tag_groups) | data source |
| [fmc_vlan_tags.module](https://registry.terraform.io/providers/CiscoDevNet/fmc/2.0.0-beta3/docs/data-sources/vlan_tags) | data source |
| [utils_yaml_merge.defaults](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
| [utils_yaml_merge.model](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
## Modules

No modules.
<!-- END_TF_DOCS -->