{% set container_name = 'graphite' %}
{% set container_ports = ['49185:80', '49186:8080', '49003:2003'] %}
{% include 'docker/docker-template.sls' %}