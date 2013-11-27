brandhub-checkout:
  git.latest:
    - name: https://pulsepoint-readonly:7leJt8vXtgIf@github.com/pulsepointinc/brandhub-docker.git
    - rev: master
    - target: /brandhub-docker
    - force_checkout: True

brandhub-built:
  dockercmd.built:
    - name: brandhub
    - dockerfile: /brandhub-docker
    - watch:
      - git: brandhub-checkout

brandhub-run:
  dockercmd.running:
    - name: brandhub1
    - image: brandhub
    - ports: ['49022:22', '49800:80', '49801:6081']
    - watch:
      - dockercmd: brandhub-built
