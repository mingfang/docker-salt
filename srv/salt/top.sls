base:
  'master-minion':
    - munin.munin-node
    - docker.docker
    - docker.docker-sock
    - git.git
    - brandhub.kibana-docker
    - graphite.graphite-docker

  '* and not master-minion':
    - match: compound
    - minion.minion
    - munin.munin-node
    - docker.docker
    - docker.docker-service
    - git.git

  'cloud3*':
    - brandhub.brandhub-docker

  'ubuntu':
    - brandhub.brandhub-docker

  'lga-bhub*.pulse.prod':
    - brandhub.brandhub-docker
