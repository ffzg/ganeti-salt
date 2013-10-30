# Ganeti instance users configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Add 30 users for ganeti instances.
# See: http://docs.ganeti.org/ganeti/current/html/security.html#kvm-security
#
# TODO(lblasc@znode.net):
# - get rid off hardcoded values
#

# Add ganeti instance users.
{% for usr in range(30) %}
gnt{{ usr }}:
  group:
    - present
    - gid: {{ [usr, 2000]|sum }}

  user:
    - present
    - fullname: Ganneti Instance User{{ usr }}
    - shell: /bin/false
    - home: /srv/ganeti
    - uid: {{ [usr, 2000]|sum }}
    - gid: {{ [usr, 2000]|sum }}
    - require:
      - group: gnt{{ usr }}

{% endfor %}
