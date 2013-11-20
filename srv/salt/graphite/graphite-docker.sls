graphite-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-graphite.git
    - target: /docker-graphite
    - force_checkout: True

graphite-kill:
  cmd.wait:
    - name: docker kill graphite
    - watch:
      - git: graphite-checkout

graphite-rm:
  cmd.wait:
    - name: docker rm graphite
    - watch:
      - cmd: graphite-kill

graphite-build:
  cmd.run:
    - name: docker build -t graphite .
    - cwd: /docker-graphite
    - timeout: 120
    - unless: docker images | grep graphite

graphite-run:
  cmd.run:
    - name: docker run -d -p 49880:80 -p 49003:2003 -name graphite graphite
    - unless: docker ps -a|grep graphite
