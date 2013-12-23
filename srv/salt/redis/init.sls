{% set container_name = 'redis' %}
{% set container_ports = ['49988:8888', '49379:63790'] %}
{% include 'docker/docker-template.sls' %}