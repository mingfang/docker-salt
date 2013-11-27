salt-python-apt:
  pkg.installed:
    - name: python-apt

salt_repo:
    pkgrepo.managed:
      - repo: 'deb http://ppa.launchpad.net/saltstack/salt/ubuntu precise main'
      - file: '/etc/apt/sources.list.d/salt.list'
      - keyid: 0E27C0A6
      - keyserver: keyserver.ubuntu.com
      - require_in:
          - pkg: salt-minion
      - require:
        - pkg: python-apt

/etc/salt/minion:
  file.managed:
    - source: salt://minion/minion
    - user: root
    - group: root
    - template: jinja
    - context:
      master_ip: {{ pillar['master']['master_ip'] }}
    - require:
      - pkg: salt-minion

salt-minion:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: munin-node
    - watch:
      - file: /etc/salt/minion
      - pkg: salt-minion
