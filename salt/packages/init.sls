# Packages configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Install additional packages
#
# TODO(lblasc@znode.net):
#
include:
  - apt_sources

extra_packages:
  pkg.installed:
    - names:
      - vim-nox
      - less
      - lsof
      - strace
      - htop
      - ssh-client
      - hdparm
      - netsniff-ng
      - dstat
      - sudo
      - curl

{% for node in pillar['nodes'] %}
# Find the current node.
{% if node == grains['host'] %}
# Check if node uses Dell hardware.
{% if pillar.nodes[node].dell %}
# Install dell omsa.
dell_packages:
  pkg.installed:
    - names:
      - srvadmin-base 
      - srvadmin-omacore
      - srvadmin-omcommon
{% endif %}
{% endif %}
{% endfor %}
