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
  cmd.wait:
    - name: docker build -t graphite .
    - cwd: /docker-graphite
    - timeout: 120
    - watch:
      - git: graphite-checkout

graphite-run:
  cmd.run:
    - name: docker run -d -p 49185:80 -p 49186:8080 -p 49003:2003 -name graphite graphite
    - unless: docker ps -a|grep graphite
