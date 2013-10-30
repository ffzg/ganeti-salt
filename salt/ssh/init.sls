# OpenSSH configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Configure OpenSSH daemon
#
# TODO(lblasc@znode.net):
# - remove hardcoded values
# - more strict
# - cached ldap/kerberos auth
#
include:
  - apt_sources

openssh-server:
  pkg:
    - latest
  file:
    - managed
    - name: /etc/ssh/sshd_config
    - template: jinja
    - user: root
    - group: root
    - mode: 440
    - source: salt://ssh/sshd_config
    - require:
      - pkg: openssh-server
  service:
    - running
    - enable: True
    - name: ssh
    - watch:
      - pkg: openssh-server
      - file: openssh-server
