brandhub-checkout:
  git.latest:
    - name: https://pulsepoint-readonly:7leJt8vXtgIf@github.com/pulsepointinc/brandhub-docker.git
    - target: /brandhub-docker
    - force_checkout: True

brandhub-kill:
  cmd.wait:
    - name: docker kill brandhub
    - watch:
      - git: brandhub-checkout

brandhub-rm:
  cmd.wait:
    - name: docker rm brandhub
    - watch:
      - cmd: brandhub-kill

brandhub-build:
  cmd.run:
    - name: docker build -t brandhub .
    - cwd: /brandhub-docker
    - timeout: 120
    - unless: docker images | grep brandhub

brandhub-run:
  cmd.run:
    - name: docker run -d -p 49022:22 -p 49800:80 -p 49801:6081 -name brandhub brandhub
    - unless: docker ps -a|grep brandhub
