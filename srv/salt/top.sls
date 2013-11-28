base:
  'master-minion':
    - docker.docker-sock
    - git.git
    - kibana.kibana-docker
    - graphite.graphite-docker

  #Common for all minions except the master minion
  '* and not master-minion':
    - match: compound
    - minion.minion
    - munin.munin-node
    - docker.docker
    - docker.docker-service
    - git.git

  #Minecraft
#  'minecraft':
#    - minecraft.minecraft-docker