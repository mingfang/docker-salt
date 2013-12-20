{% set container_name = 'ipython' %}
{% set container_ports = ['49888:8888'] %}
{% set container_volumes = ['/docker-ipython/:/ipython'] %}
{% include 'docker/docker-template.sls' %}