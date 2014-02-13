# Main network configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Salted network node configuration
#
# TODO(lblasc@znode.net):
# - write real salt network confing for debian (=hard work)
# 

# For now manage the interfaces file
network_interfaces:
  pkg.installed:
    - names:
      - iproute
      - bridge-utils
      - vlan
      - ebtables
      - ifenslave-2.6

  file.managed:
    - source: salt://network/interfaces
    - name: /etc/network/interfaces
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: network_interfaces

