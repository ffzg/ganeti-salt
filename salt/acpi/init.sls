# ACPI configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Install acpi daemon
#
# TODO(lblasc@znode.net):
# - write apci service checks
#
include:
  - apt_sources

acpid:
  pkg:
    - installed
  require:
    - file: /etc/apt/sources.list

