#Runs Docker service

/etc/default/docker:
  file.managed:
    - source: salt://docker/docker

docker:
  service.running:
    - require:
      - pkg: lxc-docker
    - watch:
      - file: /etc/default/docker
