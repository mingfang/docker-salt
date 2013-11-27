graphite-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-graphite.git
    - target: /docker-graphite
    - force_checkout: True

graphite-built:
  dockercmd.built:
    - name: graphite
    - dockerfile: /docker-graphite
    - watch:
      - git: graphite-checkout

graphite-run:
  dockercmd.running:
    - name: graphite1
    - image: graphite
    - ports: ['49185:80', '49186:8080', '49003:2003']
    - watch:
          - dockercmd: graphite-built
