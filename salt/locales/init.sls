# Locales configuration
#
# Author: lblasc@znode.net (Luka Blaskovic)
#
# Description:
# Configure locales

locales:
  pkg:
    - installed

  cmd.wait:
    - name: /usr/sbin/locale-gen; /usr/sbin/update-locale

hr_HR.UTF-8:
  file.uncomment:
    - name: /etc/locale.gen
    - regex: hr_HR.UTF-8 UTF-8
    - char: '# '
    - require:
      - pkg: locales
    - watch_in:
      - cmd: locales

en_US.UTF-8:
  file.uncomment:
    - name: /etc/locale.gen
    - regex: en_US.UTF-8 UTF-8
    - char: '# '
    - require:
      - pkg: locales
    - watch_in:
      - cmd: locales

  locale:
    - system
    - require:
      - pkg: locales

