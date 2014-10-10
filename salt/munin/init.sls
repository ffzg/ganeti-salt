munin-node:
  pkg.latest:
    - fromrepo: wheezy-backports

  service:
    - running
    - enable: True
    - watch:
      - pkg: munin-node
      - file: /etc/munin/munin-node.conf

  file.managed:
    - name: /etc/munin/munin-node.conf
    - source: salt://munin/munin-node.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: munin-node

rm /etc/munin/plugins/if_err_br*:
    cmd.wait:
      - watch:
        - pkg: munin-node

rm /etc/munin/plugins/if_br*:
    cmd.wait:
      - watch:
        - pkg: munin-node

rm /etc/munin/plugins/if_err_tap*:
    cmd.wait:
      - watch:
        - pkg: munin-node

rm /etc/munin/plugins/if_tap*:
    cmd.wait:
      - watch:
        - pkg: munin-node

rm /etc/munin/plugins/ip_*:
    cmd.wait:
      - watch:
        - pkg: munin-node

rm /etc/munin/plugins/tap_*:
    cmd.wait:
      - watch:
        - pkg: munin-node
