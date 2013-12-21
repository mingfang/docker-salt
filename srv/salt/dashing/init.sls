{% set container_name = 'dashing' %}
{% set container_ports = ['49303:3030'] %}
{% include 'docker/docker-template.sls' %}