#creates docker.sock symlink to control Docker daemon

/var/run/docker.sock:
  file.symlink:
    - target: /hrv/docker.sock