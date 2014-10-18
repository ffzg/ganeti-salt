# Ganeti optimizations
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Ganeti optimizations
#

# Install ffzg kernel.
linux-image-3.10.0-4-amd64:
  pkg.latest

# Install wheezy kernel.
linux-image-3.2.0-4-amd64:
  pkg.latest

# Install ffzg-firmware.
ffzg-firmware:
  pkg.latest

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
        - kvm_intel

# kvm nasted virtualization support
/etc/modprobe.d/kvm_nested.conf:
  file.managed:
    - source: salt://ganeti/files/kvm_nested.conf
    - user: root
    - group: root
    - mode: 644

# Newer kernels don't need irqbalance.
irqbalance:
  pkg:
    - purged

# Kvm tuning for ganeti,
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

# Disable ipv6 autoconfiguration
net.ipv6.conf.all.autoconf:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

# No need for ipv6 forwarding.
net.ipv6.conf.default.forwarding:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf

net.ipv6.conf.all.forwarding:
  sysctl.present:
    - value: 0
    - config: /etc/sysctl.d/ganeti.conf


# Use lower sysctl swappines.
vm.swappines:
  sysctl.present:
    - value: 0
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
    - value: 1
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

# Set grup parameters
grub-common:
  pkg:
    - installed

  file.managed:
    - source: salt://ganeti/grub
    - name: /etc/default/grub
    - user: root
    - group: root
    - mode: 444

  cmd.wait:
    - name: /usr/sbin/update-grub
    - watch:
      - file: grub-common

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
    - template: jinja
    - require:
      - pkg: sysfsutils
