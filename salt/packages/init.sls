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
      - atop
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
      - smartmontools
      - screen
      - iftop
      - nfs-common
      - ncurses-term

