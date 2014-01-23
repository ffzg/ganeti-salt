# Main ganeti configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Salted ganeti node configuration
# (http://docs.ganeti.org/ganeti/current/html/install.html)
#
# - manage hosts file (sutiable for small clusters)
# - install ganeti packages from local repo
# - setup node for drbd disk type
# - ganeti optimizations
#
# TODO(lblasc@znode.net):
# - add ksm
# - more modular (generic part + hypervisor)
# - setup node disks and lvm
# - enhance network part
#   - support bonding interfaces per node
#   - write real salt network confing for debian (=hard work)
# 
include:
  - apt_sources

# globals
{% set public_domain = pillar['cluster'].net.public.domain %}
{% set gnt_domain = pillar['cluster'].net.gnt.domain %}
{% set drbd_domain = pillar['cluster'].net.drbd.domain %}

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


# Add cluster master ip and hostname to /etc/hosts on all nodes.
{{ pillar.cluster['name'] }}:
  host.present:
    - ip: {{ pillar.cluster['master_ip'] }}
    - names:
      - cluster.{{ gnt_domain }}
      - cluster

# Add salt master ip and hostname to /etc/hosts on all nodes.
{{ pillar.saltmaster['name']}}.{{ gnt_domain }}:
  host.present:
    - ip: {{ pillar.saltmaster['ip'] }}

# Make sure all nodes have ips and hostnames of every cluster node
# network type (in /etc/hosts).
{% for node in pillar['nodes'] %}
# gnt hostnames
{{ node }}:
  host.present: 
    - ip: {{ pillar.nodes[node].gnt_ip }}
    - names:
      - {{ node }}.{{ gnt_domain }}
      {% if node == grains['host'] %}
      - {{ node }}
      {% endif %}

# drbd hostnames
{{ node }}.{{ drbd_domain }}:
  host.present:
    - ip: {{ pillar.nodes[node].drbd_ip }}

# public hostnames
{{ node }}.{{ public_domain }}:
  host.present:
    - ip: {{ pillar.nodes[node].public_ip }}
{% endfor %}

# Install ganeti2 specific version and related tools.
ganeti-extra:
  pkg.installed:
    - names:
      - ethtool
      - dump
      - kpartx
      - lvm2
      - qemu-kvm

ganeti2:
  pkg.installed:
    - version: 2.9.2-1~bpo70+ffzg+nocompress+2

  service.running:
    - name: ganeti
    - enable: True

  require:
    - cmd: apt_sources_ffzg
    - pkg:
        - ganeti2
        - ganeti-extra

ganeti-htools:
  pkg.installed:
    - version: 2.9.2-1~bpo70+ffzg+nocompress+2
    - require:
      - pkg: ganeti2

# Manage /etc/modules, setup/load drbd,
# tcp_highspeed congestion control algorithm and
# bridge module (because sysctrl will fail).
/etc/modules:
  file.managed:
    - source: salt://ganeti/modules
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
      modules:
        - drbd minor_count=255 usermode_helper=/bin/true
        - tcp_highspeed
        - bridge
    
# Setup kernel & initrd symlinks for easier maintenance.
/boot/vmlinuz-3.2-kvmU:
  file.symlink:
      - target: /boot/vmlinuz-3.2.0-4-amd64

/boot/initrd.img-3.2-kvmU:
  file.symlink:
      - target: /boot/initrd.img-3.2.0-4-amd64

# Optimization section

# Newer kernels don't need irqbalance.
irqbalance:
  pkg:
    - purged

# Kvm tuning for ganeti <2.7,
# use lowest node cpu flags.
kvm_tuning:
  cmd.run:
    - name: dpkg-divert --add --rename --divert /usr/bin/kvm.real /usr/bin/kvm
    - unless: dpkg-divert --list | grep /usr/bin/kvm.real
    - require:
      - pkg: ganeti-extra

  file.managed:
    - name: /usr/bin/kvm
    - source: salt://ganeti/kvm
    - user: root
    - group: root
    - mode: 755
    - require:
      - cmd: kvm_tuning

# Use lower sysctl swappines.
vm.swappines:
  sysctl.present:
    - value: 20
    - config: /etc/sysctl.d/ganeti.conf

# Enable rp_filter.
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/ganeti.conf

# Do not accept source routing.
net.ipv4.conf.default.accept_source_route:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

# Controls the system request debugging functionality of the kernel.
kernel.sysrq:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

# Controls whether core dumps will append the PID to the core filename
# (useful for debugging multi-threaded applications).
kernel.core_uses_pid:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/ganeti.conf

# Controls the use of TCP syncookies.
net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 1
    - config: /etc/sysctl.d/ganeti.conf

# Disable netfilter on bridges.
net.bridge.bridge-nf-call-ip6tables:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf
        
net.bridge.bridge-nf-call-iptables:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

net.bridge.bridge-nf-call-arptables:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

# Set maximum TCP window sizes to 12 megabytes.
net.core.rmem_max:
  sysctl.present:
    - value: 11960320
    - config: /etc/sysctl.d/ganeti.conf

net.core.wmem_max:
  sysctl.present:
    - value: 11960320
    - config: /etc/sysctl.d/ganeti.conf

# Set maximum network input buffer queue length.
net.core.netdev_max_backlog:
  sysctl.present:
    - value: 30000
    - config: /etc/sysctl.d/ganeti.conf

# set minimum, default, and maximum TCP buffer limits.
net.ipv4.tcp_rmem:
  sysctl.present:
    - value: 4096 524288 11960320
    - config: /etc/sysctl.d/ganeti.conf

net.ipv4.tcp_wmem:
  sysctl.present:
    - value: 4096 524288 11960320
    - config: /etc/sysctl.d/ganeti.conf

# Use the HSTCP TCP congestion control algorithm instead of the TCP Cubic algorithm.
net.ipv4.tcp_congestion_control:
  sysctl.present:
    - value: highspeed
    - config: /etc/sysctl.d/ganeti.conf

# Reduce water levels to start marketing background (and foreground)
# write back early. Reduces the chance of resource starvation.
vm.dirty_ratio:
  sysctl.present:
    - value: 10
    - config: /etc/sysctl.d/ganeti.conf

vm.dirty_background_ratio:
  sysctl.present:
    - value: 4
    - config: /etc/sysctl.d/ganeti.conf

# Setup ganeti sysfs optimizations.
sysfsutils:
  pkg:
    - installed

  service:
    - running
    - enable: True
    - watch:
      - file: /etc/sysfs.conf
      - pkg: sysfsutils

  file.managed:
    - source: salt://ganeti/sysfs
    - name: /etc/sysfs.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sysfsutils
