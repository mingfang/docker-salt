kibana-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-kibana.git
    - target: /docker-kibana
    - force_checkout: True

kibana-built:
  dockercmd.built:
    - name: kibana
    - dockerfile: /docker-kibana
    - watch:
      - git: kibana-checkout

kibana-run:
  dockercmd.running:
    - name: kibana1
    - image: kibana
    - ports: ['49082:80', '49021:49021']
    - watch:
      - dockercmd: kibana-built