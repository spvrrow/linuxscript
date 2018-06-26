copy rsyslog.conf:
   file.managed:
      - name: /etc/rsyslog.conf
      - source: salt://rsyslog.conf
