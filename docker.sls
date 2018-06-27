python-pip:
  pkg.installed

docker-py:
  pip.installed:
    - require:
      - pkg: python-pip

docker-repository:
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
