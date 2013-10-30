# NTP client configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Configure NTP client
#
# TODO(lblasc@znode.net):
# - remove hardcoded values
#

ntp:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/ntp.conf
  file.managed:
    - name: /etc/ntp.conf
    - source: salt://ntp/ntp.conf
    - mode: 644
    - template: jinja
    - defaults:
          servers: ['zg1.ntp.carnet.hr',
                  'zg2.ntp.carnet.hr',
                  'os.ntp.carnet.hr',
                  'ri.ntp.carnet.hr']
    - require:
      - pkg: ntp
