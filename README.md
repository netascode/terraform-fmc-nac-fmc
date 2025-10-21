<!-- BEGIN_TF_DOCS -->
# Terraform Network-as-Code Cisco FMC Module

A Terraform module to configure Cisco FMC.

## Usage

This module supports an inventory driven approach, where a complete FMC configuration or parts of it are either modeled in one or more YAML files or natively using Terraform variables.

## Examples

Configuring a Network-group Object using YAML:

#### `data/existing.nac.yaml`

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

#### `data/fmc.nac.yaml`

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.3.0 |
| <a name="requirement_utils"></a> [utils](#requirement\_utils) | >= 1.0.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_manage_deployment"></a> [manage\_deployment](#input\_manage\_deployment) | Enables support for FTD deployments | `bool` | `true` | no |
| <a name="input_model"></a> [model](#input\_model) | As an alternative to YAML files, a native Terraform data structure can be provided as well. | <pre>object({<br/>    fmc = optional(object({<br/>      name    = optional(string)<br/>      system  = optional(map(any))<br/>      domains = optional(list(any), [])<br/>    }), {})<br/>    defaults = optional(map(any), {})<br/>    existing = optional(map(any), {})<br/>  })</pre> | `{}` | no |
| <a name="input_write_default_values_file"></a> [write\_default\_values\_file](#input\_write\_default\_values\_file) | Write all default values to a YAML file. Value is a path pointing to the file to be created. | `string` | `""` | no |
| <a name="input_yaml_directories"></a> [yaml\_directories](#input\_yaml\_directories) | List of paths to YAML directories. | `list(string)` | `[]` | no |
| <a name="input_yaml_files"></a> [yaml\_files](#input\_yaml\_files) | List of paths to YAML files. | `list(string)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_values"></a> [default\_values](#output\_default\_values) | All default values. |
| <a name="output_model"></a> [model](#output\_model) | Full model. |
## Resources

| Name | Type |
|------|------|
| fmc_access_control_policy.access_control_policy | resource |
| fmc_application_filter.application_filter | resource |
| fmc_application_filters.application_filters | resource |
| fmc_bfd_template.bfd_template | resource |
| fmc_device.device | resource |
| fmc_device_bfd.device_bfd | resource |
| fmc_device_bgp.device_bgp | resource |
| fmc_device_bgp_general_settings.device_bgp_general_settings | resource |
| fmc_device_cluster.device_cluster | resource |
| fmc_device_deploy.device_deploy | resource |
| fmc_device_etherchannel_interface.device_etherchannel_interface | resource |
| fmc_device_ha_pair.device_ha_pair | resource |
| fmc_device_ha_pair_monitoring.device_ha_pair_monitoring | resource |
| fmc_device_ipv4_static_route.device_ipv4_static_route | resource |
| fmc_device_ipv6_static_route.device_ipv6_static_route | resource |
| fmc_device_physical_interface.device_physical_interface | resource |
| fmc_device_subinterface.device_subinterface | resource |
| fmc_device_vrf.device_vrf | resource |
| fmc_device_vrf_ipv4_static_route.device_vrf_ipv4_static_route | resource |
| fmc_device_vrf_ipv6_static_route.device_vrf_ipv6_static_route | resource |
| fmc_dynamic_objects.dynamic_objects | resource |
| fmc_extended_access_list.extended_access_list | resource |
| fmc_file_policy.file_policy | resource |
| fmc_fqdn.fqdn | resource |
| fmc_fqdns.fqdns | resource |
| fmc_ftd_nat_policy.ftd_nat_policy | resource |
| fmc_ftd_platform_settings.ftd_platform_settings | resource |
| fmc_ftd_platform_settings_banner.ftd_platform_settings_banner | resource |
| fmc_ftd_platform_settings_http_access.ftd_platform_settings_http_access | resource |
| fmc_ftd_platform_settings_icmp_access.ftd_platform_settings_icmp_access | resource |
| fmc_ftd_platform_settings_snmp.ftd_platform_settings_snmp | resource |
| fmc_ftd_platform_settings_ssh_access.ftd_platform_settings_ssh_access | resource |
| fmc_ftd_platform_settings_syslog_email_setup.ftd_platform_settings_syslog_email_setup | resource |
| fmc_ftd_platform_settings_syslog_event_list.ftd_platform_settings_syslog_event_list | resource |
| fmc_ftd_platform_settings_syslog_logging_destination.ftd_platform_settings_syslog_logging_destination | resource |
| fmc_ftd_platform_settings_syslog_logging_setup.ftd_platform_settings_syslog_logging_setup | resource |
| fmc_ftd_platform_settings_syslog_rate_limit.ftd_platform_settings_syslog_rate_limit | resource |
| fmc_ftd_platform_settings_syslog_servers.ftd_platform_settings_syslog_servers | resource |
| fmc_ftd_platform_settings_syslog_settings.ftd_platform_settings_syslog_settings | resource |
| fmc_ftd_platform_settings_syslog_settings_syslog_id.ftd_platform_settings_syslog_settings_syslog_id | resource |
| fmc_ftd_platform_settings_time_synchronization.ftd_platform_settings_time_synchronization | resource |
| fmc_health_policy.health_policy | resource |
| fmc_host.host | resource |
| fmc_hosts.hosts | resource |
| fmc_icmpv4.icmpv4 | resource |
| fmc_icmpv4s.icmpv4s | resource |
| fmc_intrusion_policy.intrusion_policy | resource |
| fmc_intrusion_policy.intrusion_policy_l2 | resource |
| fmc_ipv4_address_pool.ipv4_address_pool | resource |
| fmc_ipv4_address_pools.ipv4_address_pools | resource |
| fmc_ipv6_address_pool.ipv6_address_pool | resource |
| fmc_ipv6_address_pools.ipv6_address_pools | resource |
| fmc_network.network | resource |
| fmc_network_analysis_policy.network_analysis_policy | resource |
| fmc_network_groups.network_groups | resource |
| fmc_networks.networks | resource |
| fmc_policy_assignment.access_control_policy | resource |
| fmc_policy_assignment.ftd_nat_policy | resource |
| fmc_policy_assignment.ftd_platform_settings | resource |
| fmc_policy_assignment.health_policy | resource |
| fmc_port.port | resource |
| fmc_port_group.port_group | resource |
| fmc_port_groups.port_groups | resource |
| fmc_ports.ports | resource |
| fmc_prefilter_policy.prefilter_policy | resource |
| fmc_range.range | resource |
| fmc_ranges.ranges | resource |
| fmc_security_zone.security_zone | resource |
| fmc_security_zones.security_zones | resource |
| fmc_sgt.sgt | resource |
| fmc_sgts.sgts | resource |
| fmc_smart_license.smart_license | resource |
| fmc_standard_access_list.standard_access_list | resource |
| fmc_time_range.time_range | resource |
| fmc_time_ranges.time_ranges | resource |
| fmc_tunnel_zone.tunnel_zone | resource |
| fmc_tunnel_zones.tunnel_zones | resource |
| fmc_url.url | resource |
| fmc_url_group.url_group | resource |
| fmc_url_groups.url_groups | resource |
| fmc_urls.urls | resource |
| fmc_vlan_tag.vlan_tag | resource |
| fmc_vlan_tag_group.vlan_tag_group | resource |
| fmc_vlan_tag_groups.vlan_tag_groups | resource |
| fmc_vlan_tags.vlan_tags | resource |
| [local_sensitive_file.defaults](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [terraform_data.validation](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| fmc_access_control_policy.access_control_policy | data source |
| fmc_application_business_relevances.application_business_relevances | data source |
| fmc_application_categories.application_categories | data source |
| fmc_application_filters.application_filters | data source |
| fmc_application_risks.application_risks | data source |
| fmc_application_tags.application_tags | data source |
| fmc_application_types.application_types | data source |
| fmc_applications.applications | data source |
| fmc_bfd_template.bfd_template | data source |
| fmc_device.device | data source |
| fmc_device_bfd.device_bfd | data source |
| fmc_device_bgp_general_settings.device_bgp_general_settings | data source |
| fmc_device_cluster.device_cluster | data source |
| fmc_device_etherchannel_interface.device_etherchannel_interface | data source |
| fmc_device_ha_pair.device_ha_pair | data source |
| fmc_device_physical_interface.device_physical_interface | data source |
| fmc_device_subinterface.device_subinterface | data source |
| fmc_device_vrf.device_vrf | data source |
| fmc_dynamic_objects.dynamic_objects | data source |
| fmc_endpoint_device_types.endpoint_device_types | data source |
| fmc_extended_access_list.extended_access_list | data source |
| fmc_file_categories.file_categories | data source |
| fmc_file_policy.file_policy | data source |
| fmc_file_types.file_types | data source |
| fmc_fqdns.fqdns | data source |
| fmc_ftd_nat_policy.ftd_nat_policy | data source |
| fmc_ftd_platform_settings.ftd_platform_settings | data source |
| fmc_health_policy.health_policy | data source |
| fmc_hosts.hosts | data source |
| fmc_icmpv4s.icmpv4s | data source |
| fmc_intrusion_policy.intrusion_policy | data source |
| fmc_ipv4_address_pools.ipv4_address_pools | data source |
| fmc_ipv6_address_pools.ipv6_address_pools | data source |
| fmc_ise_sgts.ise_sgts | data source |
| fmc_network_analysis_policy.network_analysis_policy | data source |
| fmc_network_groups.network_groups | data source |
| fmc_networks.networks | data source |
| fmc_port_groups.port_groups | data source |
| fmc_ports.ports | data source |
| fmc_prefilter_policy.prefilter_policy | data source |
| fmc_ranges.ranges | data source |
| fmc_security_zones.security_zones | data source |
| fmc_sgts.sgts | data source |
| fmc_snmp_alerts.snmp_alerts | data source |
| fmc_standard_access_list.standard_access_list | data source |
| fmc_syslog_alerts.syslog_alerts | data source |
| fmc_time_ranges.time_ranges | data source |
| fmc_tunnel_zones.tunnel_zones | data source |
| fmc_url_groups.url_groups | data source |
| fmc_urls.urls | data source |
| fmc_variable_set.variable_set | data source |
| fmc_vlan_tag_groups.vlan_tag_groups | data source |
| fmc_vlan_tags.vlan_tags | data source |
## Modules

No modules.
<!-- END_TF_DOCS -->