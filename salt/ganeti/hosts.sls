# Hosts configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Manage /etc/hosts files (sutiable for small clusters) also
# configure proper resolution (hosts.conf)
#

# globals
{% set public_domain = pillar['cluster'].net.public.domain %}
{% set gnt_domain = pillar['cluster'].net.gnt.domain %}
{% set drbd_domain = pillar['cluster'].net.drbd.domain %}

# Add cluster master ip and hostname to /etc/hosts on all nodes.
{{ pillar.cluster['name'] }}:
  host.present:
    - ip: {{ pillar.cluster['master_ip'] }}
    - names:
      - cluster.{{ gnt_domain }}
      - cluster

# Add salt master ip and hostname to /etc/hosts on all nodes.
{{ pillar.saltmaster['name']}}.{{ gnt_domain }}:
  host.present:
    - ip: {{ pillar.saltmaster['ip'] }}

# Make sure all nodes have ips and hostnames of every cluster node
# network type (in /etc/hosts).
# Strick order ("ip" "node fqdn" "node hostname") is required for
# "gnt-node add" to properly work
# TODO: fix saltstack host module ordering
{% for node in pillar['nodes'] %}

# gnt network fqdn
{{ node }}.{{ gnt_domain }}:
  host.present:
    - ip: {{ pillar.nodes[node].gnt.address }}

# gnt network hostname
{{ node }}-gnt-hostname:
  host.present:
    - ip: {{ pillar.nodes[node].gnt.address }}
    - name: {{ node }}
    - require:
      - host: {{ node }}.{{ gnt_domain }}

# drbd network fqdn
{{ node }}.{{ drbd_domain }}:
  host.present:
    - ip: {{ pillar.nodes[node].drbd.address }}

{% endfor %}
