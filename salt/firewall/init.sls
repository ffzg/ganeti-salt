# IPTables firewall configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
# Based on: https://github.com/bclermont/states/
#
# Description:
#
# TODO(lblasc@znode.net):
# - remove hardcoded values
#
include: 
  - apt_sources

# Install debconf-utils.
debconf-utils:
  pkg:
    - installed

# Setup iptables-persistent for ipv4 and ipv6.
iptables-persistent:
  debconf:
    - set
    - data:
{% for version in (4, 6) %}
        'iptables-persistent/autosave_v{{ version }}': {'type': 'boolean', 'value': 'false'}
{% endfor %}
    - require:
      - pkg: debconf-utils
  pkg:
    - installed
    - require:
      - debconf: iptables-persistent

# Manage ipv4 firewall.
iptables:
  file:
    - managed
    - name: /etc/iptables/rules.v4
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://firewall/iptables
    - require:
      - pkg: iptables-persistent
    - defaults:
      pub_if: br1001
  pkg:
    - installed
    - names:
      - iptables
  cmd:
    - wait
    - name: iptables-restore < /etc/iptables/rules.v4
    - stateful: False
    - watch:
      - file: iptables
