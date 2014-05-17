# Main ganeti configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Salted ganeti node configuration
# (http://docs.ganeti.org/ganeti/current/html/install.html)
#
# - manage hosts file (sutiable for small clusters)
# - setup node for drbd disk type
#
# TODO(lblasc@znode.net):
# - add ksm
# - setup node disks and lvm
# 

{% set gnt_domain = pillar['cluster'].net.gnt.domain %}

# Setup hostname as fqdn.
/etc/hostname:
  file.managed:
    - source: salt://ganeti/hostname
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - default:
      hostname: {{ grains['host'] }}.{{ gnt_domain }}

# Install drbd utils from wheezy backports
drbd8-utils:
  pkg.latest:
    - fromrepo: wheezy-backports

# Install backported kvm
# TODO: fix ffzg repo and use fromrepo instead hardcoded
# versions
kvmpkgs:
  pkg.installed:
    - pkgs:
      - libspice-server1: 0.12.4-0nocelt2~bpo70+1
      - libusb-1.0-0: 2:1.0.17-1~bpo70+1
      - libusbredirparser1: 0.6-2~bpo70+1
      - qemu-keymaps: 1.7.0+dfsg-2~bpo70+2
      - qemu-kvm: 1.7.0+dfsg-2~bpo70+2
      - qemu-system-common: 1.7.0+dfsg-2~bpo70+2
      - qemu-system-x86: 1.7.0+dfsg-2~bpo70+2
      - qemu-utils: 1.7.0+dfsg-2~bpo70+2
      - seabios: 1.7.3-3~bpo70+1

# Install ganeti specific version and related tools.
ganeti-extra:
  pkg.installed:
    - names:
      - ethtool
      - dump
      - kpartx
      - lvm2
    - require:
      - pkg: kvmpkgs

ganeti:
  pkg.latest:
    - fromrepo: wheezy-backports

  service.running:
    - name: ganeti
    - enable: True

  require:
    - pkg:
      - ganeti
      - ganeti-extra

# FIX (hardcoded major version) dependency problems
ganeti-htools-2.10:
  pkg.latest:
    - fromrepo: wheezy-backports
    - require:
      - pkg: ganeti

# Setup FFZG kernel & initrd symlinks for easier maintenance.
/boot/vmlinuz-3.10-kvmU:
  file.symlink:
    - target: /boot/vmlinuz-3.10.0-1-amd64

/boot/initrd.img-3.10-kvmU:
  file.symlink:
    - target: /boot/initrd.img-3.10.0-1-amd64

# Setup Debian kernel & initrd symlinks for easier maintenance.
/boot/vmlinuz-3.2-kvmU:
  file.symlink:
    - target: /boot/vmlinuz-3.2.0-4-amd64

/boot/initrd.img-3.2-kvmU:
  file.symlink:
    - target: /boot/initrd.img-3.2.0-4-amd64

