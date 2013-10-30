# Postfix configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Configure postfix to use local smart host for relaying.
#
# TODO(lblasc@znode.net):
# - remove hardcoded stuff
# - use relay server in local network
#
include:
  - apt_sources

postfix:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: postfix
    - watch:
      - file: /etc/postfix/main.cf

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/main.cf
    - template: jinja
    - defaults:
      hostname: {{ grains['host'] }}
    - require:
      - pkg: postfix

root:
  alias:
    - present
    - target: gnt-admin@ffzg.hr
