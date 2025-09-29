##########################################################
###    Content of the file:
##########################################################
#
###
#  Principles
####
# FMC uses references based on ID, which means that any object used in the configuration needs to be created first/or exists on FMC
# It implies the condition that resources need to be created/modified in the correct order
# Module uses a new terraform provider for FMC
# Module is built for multidomain support
# Module is built for easy bulk operations support
#
###  
#  Local variables
###
# local.fmc           => map of FMC configuration loaded from YAML file
# local.domains       => map of domain configuration 
# local.data_existing => map of existing objects configuration loaded from YAML file (should reflect builtin/read-only objects like SSH, HTTP etc.)
#
###
# Dictionary
###
# 
# Interfaces:
# resource naming convention: physical_interface, sub_interface, etherchannel_interface
# name - represents GigabitEthernet0/1, Port-Channel10, TenGigabitEthernet0/1.10
# logical_name - represents inside, outsida, dmz etc.
# ether_channel_id - is taken automaticaly from interface name - Port-Channel10 and eq 10
# sub_interface_id - is taken automaticaly from interface name - TenGigabitEthernet0/1.10 and eq 10
# interface_name - (in sub_interface) represents physical interface and is taken automaticaly from interface name - TenGigabitEthernet0/1.10 and eq TenGigabitEthernet0/1
#
# Netmask:
# netmask - represents: subnet mask, network mask, network subnet, network prefix: 255.255.255.0 or 24
#
# Network:
# prefix - represents network with prefix: 10.0.0.0/24 or IP address with prefix 10.0.0.1/24
#
#
##########################################################
###    Example of created local variables
##########################################################

#  + data_hosts = {
#      + Global = {
#          + items = {
#              + Host_1 = {}
#            }
#        }
#    }
##########################################################

locals {
  fmc           = try(local.model.fmc, {})
  domains       = try(local.fmc.domains, [])
  data_existing = try(local.model.existing.fmc.domains, {})
}
