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

# Setup eth* optimizations (bigger txqueuelen and disable some hardware
# offloads). Number of bonding interfaces is not defined so udev rule
# is used for setting per interface optimizations.
/etc/udev/rules.d/75-eth-optimization.rules:
    file.managed:
      - source: salt://network/75-eth-optimization.rules
      - user: root
      - group: root
      - mode: 655
      - require:
        - pkg: network_interfaces
