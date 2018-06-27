# LAMP install
yes | sudo apt-get install wget build-essential apache2 php apache2-mod-php7.0 php-gd libgd-dev sendmail unzip

# Create users for Nagios
sudo useradd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagios,nagcmd www-data

# Retrieve Nagios core
yes | sudo wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.0.tar.gz
sudo tar -xzf nagios*.tar.gz

# Install Nagios
yes | sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd
yes | sudo make all
yes | sudo make install
yes | sudo make isntall-commandmode
yes | sudo make install-init
yes | sudo make install-config
yes | sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf

# Copy eventhandler
sudo cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
sudo chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers

# Retrieve Nagios plugins
cd ~
yes | sudo wget https://nagios-plugins.org/download/nagios-plugins-2.1.2.tar.gz
sudo tar -xzf nagios-plugins*.tar.gz
cd nagios-plugin-2.1.2/

# Install Nagios plugins
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios --with-openssl
yes | sudo make
yes | sudo make install

# Edit nagios.cfg
sudo sed -i -e 's/#cfg_dir=usr/local/nagios/etc/servers/cfg_dir=usr/local/nagios/etc/servers/g' /usr/local/nagios/etc/nagios.cfg

# Create folder for Nagios servers
sudo mkdir -p /usr/local/nagios/etc/servers

# Apache modules
sudo a2enmod rewrite
sudo a2enmod cgi

# Setup password for NagiosAdmin
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
nagios

# Enable Nagios virtualhost
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled

# Fix to start Nagios
sudo cp /etc/init.d/skeleton /etc/init.d/nagios
echo 'DESC="Nagios"
NAME=nagios
DAEMON=/usr/local/nagios/bin/$NAME
DAEMON_ARGS="-d /usr/local/nagios/etc/nagios.cfg"
PIDFILE=/usr/local/nagios/var/$NAME.lock' >> /etc/init.d/nagios

sudo chmod +x /etc/init.d/nagios

echo '[Unit]
Description=Nagios
BindTo=network.target

[Install] 
WantedBy=multi-usr.target

[Service]
User=nagios
Group=nagios
Type=simple
ExecStart=/usr/local/nagios/bin/nagios /usr/local/nagios/etc/nagios.cfg' > /etc/systemd/system/nagios.service

sudo systemctl restart apache2
sudo systemctl enable /etc/systemd/system/nagios.service
sudo systemctl start nagios
sudo systemctl restart nagios
