python-pip:
  pkg.installed

docker-compose:
    pip.installed:
      - force_reinstall: True
      - upgrade: True
      - no_cache_dir: True
      - require:
        - pkg: python-pip

docker_repository:
  pkgrepo.managed:
    - humanname: Docker
    - name: deb http://download.docker.com/linux/ubuntu xenial stable
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/ubuntu/gpg

docker-ce:
  pkg.installed:
    - require:
      - pkgrepo: docker_repository
