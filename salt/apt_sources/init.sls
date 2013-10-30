# APT sources configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# APT sources configuration file for: main debian repos (including
# backports), ffzg, saltstack and dell omsa.
#
# saltscack repo
apt_sources_salt:
  cmd.run:
    - name: wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
    - unless: apt-key list | grep 'Joe Healy'
    - require:
      - file: /etc/apt/sources.list
      - file: /etc/apt/sources.list.d/saltstack.list

apt_sources_ffzg:
  cmd.run:
    - name: wget -q -O- "http://deb.ffzg.hr/debian/lblask.gpg.key" | apt-key add -
    - unless: apt-key list | grep 'Luka Blaskovic'
    - require:
      - file: /etc/apt/sources.list
      - file: /etc/apt/sources.list.d/ffzg.list

apt_sources_dell:
  cmd.run:
    - name: gpg --keyserver pool.sks-keyservers.net --recv-key 1285491434D8786F; gpg -a --export 1285491434D8786F | apt-key add -
    - unless: apt-key list | grep 'Dell Inc., PGRE 2012'
    - require:
      - file: /etc/apt/sources.list
      - file: /etc/apt/sources.list.d/linux.dell.com.sources.list

/etc/apt/sources.list:
  file.managed:
    - source: salt://apt_sources/sources.list

/etc/apt/sources.list.d/saltstack.list:
  file.managed:
    - source: salt://apt_sources/saltstack.list

/etc/apt/sources.list.d/ffzg.list:
  file.managed:
    - source: salt://apt_sources/ffzg.list

/etc/apt/sources.list.d/linux.dell.com.sources.list:
  file.managed:
    - source: salt://apt_sources/linux.dell.com.sources.list
