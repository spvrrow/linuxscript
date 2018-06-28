copy docker file:
    file.managed:
      - name: /srv/docker/docker-compose.yml
      - source: salt://docker-compose.yml
      - mode: 777

run docker:
     cmd.run:
      - cwd: /srv/docker/
      - name: docker-compose up -d
