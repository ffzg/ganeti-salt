# Logstash forwarder
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Logstash forwareder for collecting logs for elasticsearch
#
{% set node_arch = salt['grains.get']('cpuarch', '') %}
{% set install_dir = '/srv/logstash-forwarder' %}

{{ install_dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: 700

{{ install_dir }}/logstash-forwarder:
  file.managed:
    {% if node_arch == 'x86_64' %}
    - source:  salt://logstash-forwarder/logstash-forwarder.amd64
    {% else %}
    - source:  salt://logstash-forwarder/logstash-forwarder.i386
    {% endif %}
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: {{ install_dir }}

{{ install_dir }}/logstash-forwarder.init:
  file.managed:
    - source: salt://logstash-forwarder/logstash-forwarder.init
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: {{ install_dir }}
      - file: {{ install_dir }}/logstash-forwarder

{{ install_dir }}/logstash-forwarder.crt:
  file.managed:
    - source: salt://logstash-forwarder/logstash-forwarder.crt
    - user: root
    - group: root
    - mode: 744
    - require:
      - file: {{ install_dir }}

{{ install_dir }}/logstash-forwarder.key:
  file.managed:
    - source: salt://logstash-forwarder/logstash-forwarder.key
    - user: root
    - group: root
    - mode: 700
    - require:
      - file: {{ install_dir }}

{{ install_dir }}/logs.json:
  file.managed:
    - source: salt://logstash-forwarder/logs.json
    - user: root
    - group: root
    - mode: 744
    - require:
      - file: {{ install_dir }}

logstash-forwarder:
  file:
    - symlink
    - name: /etc/init.d/logstash-forwarder
    - target: {{ install_dir }}/logstash-forwarder.init
    - require:
      - file: {{ install_dir }}/logstash-forwarder.init

  service:
    - running
    - enable: True
    - require:
      - file: logstash-forwarder
    - watch:
      - file: {{ install_dir }}/logstash-forwarder.crt
      - file: {{ install_dir }}/logstash-forwarder.key
      - file: {{ install_dir }}/logs.json
