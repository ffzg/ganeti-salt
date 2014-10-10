# /etc/resolv.conf configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Configure forward dns servers
#
# TODO(lblasc@znode.net):
# - remove hardcoded values
#

# Resolver configuration file.
/etc/resolv.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - source: salt://resolv/resolv.conf
    - template: jinja
    - defaults:
        nameservers: ['193.198.212.8','193.198.213.8', '8.8.8.8']
        searchpath: 'gnt.ffzg.hr. net.ffzg.hr. ffzg.hr.'
        options: 'ndots:2'
