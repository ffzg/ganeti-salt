# GRUB
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# GRUB setup
#

grub-common:
  pkg:
    - installed

  file.managed:
    - source: salt://grub/files/grub
    - name: /etc/default/grub
    - user: root
    - group: root
    - mode: 444

  cmd.wait:
    - name: /usr/sbin/update-grub
    - watch:
      - file: grub-common
