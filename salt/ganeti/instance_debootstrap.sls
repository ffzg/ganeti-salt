# ganeti-instance-debootstrap configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Ganeti instance debootstrap configuration
#

# Install ganeti-instance-debootstrap
ganeti-instance-debootstrap:
  pkg.latest

snf-image:
  pkg.latest

# put your instance debootstrap file into
# ganeti/files/instance-debootstrap folder
/etc/ganeti/instance-debootstrap:
  file.recurse:
    - source: salt://ganeti/files/instance-debootstrap
    - include_empty: True
    - clean: True
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755
    - require:
      - pkg: ganeti-instance-debootstrap
    
# manage default ganeti-instance-debootstrap configuration
/etc/default/ganeti-instance-debootstrap:
  file.managed:
    - source: salt://ganeti/files/ganeti-instance-debootstrap
    - mode: 644
    - user: root
    - group: root
    - require:
      - pkg: ganeti-instance-debootstrap

/usr/share/debootstrap/scripts/trusty:
  file.symlink:
      - target: /usr/share/debootstrap/scripts/gutsy
