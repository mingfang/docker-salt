#Runs Docker service

docker:
  service.running:
    - require:
      - pkg: lxc-docker
