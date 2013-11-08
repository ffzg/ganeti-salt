# Generic configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Salt top.sls file
#

base:
  '*':
    - apt_sources
    - acpi
    - firewall
    - ssh
    - network
    - packages
    - postfix
    - users
    - ntp
    - resolv
    - dell

  '*.gnt.ffzg.hr':
    - users.gnt
    - ganeti
