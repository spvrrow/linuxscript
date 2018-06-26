install_nagios:
  pkg.installed:
    - pkgs:
      - nagios-nrpe-server
      - nagios-plugins


copy server file:
   file.managed:
      - name: /etc/nagios/nrpe.cfg
      - source: salt://nrpe.cfg
