<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco FMC Module

A Terraform module to configure Cisco FMC.

## Usage

This module supports an inventory driven approach, where a complete FMC configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Optional

The default number of supported Access Rules and Manual Nat Rules is 30. To change it, please visit to [templates](/templates): 

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
  name: MyFMC1
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
  version = ">= 0.1.0"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_fmc"></a> [fmc](#requirement\_fmc) | 1.4.8 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 0.2.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deploy_support"></a> [deploy\_support](#input\_deploy\_support) | Enables support for FTD deployments | `bool` | `true` | no |
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | `map(any)` | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | <pre>[<br>  "data"<br>]</pre> | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Resources

| Name | Type |
|------|------|
| [fmc_access_policies.accesspolicy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_policies) | resource |
| [fmc_access_policies_category.accesspolicy_category](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_policies_category) | resource |
| [fmc_access_rules.access_rule_0](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_1](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_10](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_11](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_12](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_13](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_14](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_15](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_16](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_17](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_18](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_19](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_2](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_20](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_21](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_22](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_23](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_24](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_25](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_26](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_27](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_28](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_29](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_3](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_4](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_5](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_6](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_7](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_8](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_access_rules.access_rule_9](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/access_rules) | resource |
| [fmc_device_cluster.cluster](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/device_cluster) | resource |
| [fmc_device_physical_interfaces.physical_interface](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/device_physical_interfaces) | resource |
| [fmc_device_subinterfaces.sub_interfaces](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/device_subinterfaces) | resource |
| [fmc_devices.device](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/devices) | resource |
| [fmc_dynamic_objects.dynamicobject](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/dynamic_objects) | resource |
| [fmc_fqdn_objects.fqdn](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/fqdn_objects) | resource |
| [fmc_ftd_autonat_rules.ftdautonatrule](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_autonat_rules) | resource |
| [fmc_ftd_deploy.ftd](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_deploy) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_0](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_1](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_10](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_11](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_12](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_13](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_14](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_15](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_16](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_17](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_18](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_19](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_2](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_20](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_21](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_22](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_23](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_24](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_25](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_26](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_27](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_28](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_29](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_3](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_4](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_5](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_6](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_7](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_8](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_manualnat_rules.manualnat_rules_9](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_manualnat_rules) | resource |
| [fmc_ftd_nat_policies.ftdnatpolicy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ftd_nat_policies) | resource |
| [fmc_host_objects.host](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/host_objects) | resource |
| [fmc_icmpv4_objects.icmpv4](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/icmpv4_objects) | resource |
| [fmc_ips_policies.ips_policy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/ips_policies) | resource |
| [fmc_network_group_objects.networkgroup_l1](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_group_objects) | resource |
| [fmc_network_group_objects.networkgroup_l2](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_group_objects) | resource |
| [fmc_network_group_objects.networkgroup_l3](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_group_objects) | resource |
| [fmc_network_group_objects.networkgroup_l4](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_group_objects) | resource |
| [fmc_network_group_objects.networkgroup_l5](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_group_objects) | resource |
| [fmc_network_objects.network](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/network_objects) | resource |
| [fmc_policy_devices_assignments.policy_assignment](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/policy_devices_assignments) | resource |
| [fmc_port_group_objects.portgroup](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/port_group_objects) | resource |
| [fmc_port_objects.port](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/port_objects) | resource |
| [fmc_prefilter_policy.prefilterpolicy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/prefilter_policy) | resource |
| [fmc_range_objects.range](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/range_objects) | resource |
| [fmc_security_zone.securityzone](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/security_zone) | resource |
| [fmc_sgt_objects.sgt](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/sgt_objects) | resource |
| [fmc_smart_license.license](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/smart_license) | resource |
| [fmc_staticIPv4_route.ipv4staticroute](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/staticIPv4_route) | resource |
| [fmc_url_object_group.urlgroup](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/url_object_group) | resource |
| [fmc_url_objects.url](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/resources/url_objects) | resource |
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [fmc_access_policies.accesspolicy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/access_policies) | data source |
| [fmc_device_cluster.cluster](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/device_cluster) | data source |
| [fmc_device_physical_interfaces.physical_interface](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/device_physical_interfaces) | data source |
| [fmc_device_subinterfaces.sub_interfaces](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/device_subinterfaces) | data source |
| [fmc_devices.device](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/devices) | data source |
| [fmc_dynamic_objects.dynamicobject](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/dynamic_objects) | data source |
| [fmc_file_policies.file_policy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/file_policies) | data source |
| [fmc_ftd_nat_policies.ftdnatpolicy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/ftd_nat_policies) | data source |
| [fmc_host_objects.host](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/host_objects) | data source |
| [fmc_ips_policies.ips_policy](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/ips_policies) | data source |
| [fmc_network_group_objects.networkgroup](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/network_group_objects) | data source |
| [fmc_network_objects.network](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/network_objects) | data source |
| [fmc_port_group_objects.portgroup](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/port_group_objects) | data source |
| [fmc_port_objects.port](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/port_objects) | data source |
| [fmc_security_zones.securityzone](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/security_zones) | data source |
| [fmc_sgt_objects.sgt](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/sgt_objects) | data source |
| [fmc_syslog_alerts.syslogalert](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/syslog_alerts) | data source |
| [fmc_url_objects.url](https://registry.terraform.io/providers/CiscoDevNet/fmc/1.4.8/docs/data-sources/url_objects) | data source |
| [utils_yaml_merge.defaults](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
| [utils_yaml_merge.model](https://registry.terraform.io/providers/netascode/utils/latest/docs/data-sources/yaml_merge) | data source |
## Modules

No modules.
<!-- END_TF_DOCS -->