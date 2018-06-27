# Remove comments in rsyslog.conf
sudo sed -i -e 's/#module(load="imudp")/module(load="imudp")/g' /etc/rsyslog.conf
sudo sed -i -e 's/#input(type="imudp" port="514")/input(type="imudp" port="514")/g' /etc/rsyslog.conf
sudo sed -i -e 's/#module(load="imtcp")/module(load="imtcp")/g' /etc/rsyslog.conf
sudo sed -i -e 's/#input(type="imtcp" port="514")/input(type="imtcp" port="514")/g' /etc/rsyslog.conf

# Create template for log files
sudo touch /etc/rsyslog.d/tmpl.conf

echo '$template TmplAuth,"/var/log/client_logs/%HOSTNAME%/%PROGRAMNAME%.log"
$template TmplMsg,"/var/log/client_logs/%HOSTNAME%/%PROGRAMNAME%.log"

authpriv.* ?TmplAuth
*.info;mail.none;authpriv.none;cron.none ?TmplMsg' > /etc/rsyslog.d/tmpl.conf

# Create folder for logs
sudo mkdir /var/log/client_logs
sudo chmod 777 /var/log/client_logs

# Restart service
sudo systemctl restart rsyslog
