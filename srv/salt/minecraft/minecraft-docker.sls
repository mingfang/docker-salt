minecraft-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-minecraft.git
    - target: /docker-minecraft
    - force_checkout: True

minecraft-built:
  dockercmd.built:
    - name: minecraft
    - dockerfile: /docker-minecraft
    - watch:
      - git: minecraft-checkout

minecraft-run:
  dockercmd.running:
    - name: minecraft1
    - image: minecraft
    - ports: ['49565:49565']
    - watch:
      - dockercmd: minecraft-built