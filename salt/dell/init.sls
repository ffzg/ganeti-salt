# Dell configurations
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Specific Dell hardware packages and configurations.
#
include:
  - apt_sources

{% for node in pillar['nodes'] %}
# Find the current node.
{% if node == grains['host'] %}
# Check if node uses Dell hardware.
{% if pillar.nodes[node].dell %}

# Install dell omsa.
dell_packages:
  pkg.installed:
    - names:
      - srvadmin-base
      - srvadmin-omacore
      - srvadmin-omcommon
    - require:
      - cmd: apt_sources_dell

# Install dellLCD.sh script and cron entry.
/usr/local/bin/dellLCD.sh:
  file.managed:
    - source: salt://dell/dellLCD.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - pkg: dell_packages

  cron.present:
    - user: root
    - minute: "*/5"
    - require:
      - file: /usr/local/bin/dellLCD.sh 
      - pkg: dell_packages

{% endif %}
{% endif %}
{% endfor %}

