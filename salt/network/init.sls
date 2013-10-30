# Main network configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Salted network node configuration
#
# TODO(lblasc@znode.net):
# - support bonding interfaces per node
# - write real salt network confing for debian (=hard work)
# 
include:
  - apt_sources

# Manage the interfaces file (no debian network state).
network_interfaces:
  pkg.installed:
    - names:
      - bridge-utils
      - vlan
      - ebtables

  file.managed:
    - source: salt://network/interfaces
    - name: /etc/network/interfaces
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: network_interfaces

