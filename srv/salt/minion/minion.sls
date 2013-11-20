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
    - require:
      - pkg: salt-minion

salt-minion:
  pkg.installed:
    - version: 0.17.2-1precise
  service.running:
    - watch:
      - file: /etc/salt/minion
      - pkg: salt-minion
