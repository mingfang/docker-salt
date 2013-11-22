kibana-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-kibana.git
    - target: /kibana-docker
    - force_checkout: True

kibana-kill:
  cmd.wait:
    - name: docker kill kibana
    - watch:
      - git: kibana-checkout

kibana-rm:
  cmd.wait:
    - name: docker rm kibana
    - watch:
      - cmd: kibana-kill

kibana-build:
  cmd.wait:
    - name: docker build -t kibana .
    - cwd: /kibana-docker
    - timeout: 120
    - watch:
      - git: kibana-checkout

kibana-run:
  cmd.run:
    - name: docker run -d -p 49082:80 -p 49021:49021 -name kibana kibana
    - unless: docker ps -a|grep kibana
