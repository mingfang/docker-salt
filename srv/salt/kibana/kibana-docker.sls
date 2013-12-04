{% set container_name = 'kibana' %}
{% set container_ports = ['49082:80', '49021:49021'] %}
{% include 'docker/docker-template.sls' %}