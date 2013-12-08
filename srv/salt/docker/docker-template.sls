{{container_name}}-checkout:
  git.latest:
    - name: https://github.com/mingfang/docker-{{container_name}}.git
    - target: /docker-{{container_name}}
    - force_checkout: True

{{container_name}}-built:
  dockercmd.built:
    - name: {{container_name}}
    - dockerfile: /docker-{{container_name}}
    - watch:
      - git: {{container_name}}-checkout

{{container_name}}-run:
  dockercmd.running:
    - name: {{container_name}}1
    - image: {{container_name}}
    - ports: {{container_ports | default(None)}}
    - reload: {{ pillar.get('reload', False) }}
    - watch:
      - dockercmd: {{container_name}}-built