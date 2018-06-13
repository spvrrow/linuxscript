#!/bin/bash


#Opvragen van variabelen
IP="$(ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')"
devicename="$(hostname -s)"

#install nagios
sudo apt-get install nagios-nrpe-server nagios-plugins

#copy config file from nagios server
sudo scp azureuser@10.0.0.4:/home/azureuser/nrpe.cfg azureuser@$IP:/etc/nagios/nrpe.cfg

#Building of script
sudo touch /etc/nagios/"${devicename}".cfg

sudo chmod 777 /etc/nagios/"${devicename}".cfg

sudo echo “ # Ubuntu Host configuration file
define host {
        use                          linux-server
        host_name                    $devicename
        alias                        Ubuntu Host
        address                      $IP
        register                     1
}

define service {
      host_name                       $devicename
      service_description             PING
      check_command                   check_ping!100.0,20%!500.0,60%
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}

define service {
      host_name                       $devicename
      service_description             Check Users
      check_command           check_local_users!20!50
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}

define service {
      host_name                       $devicename
      service_description             Local Disk
      check_command                   check_local_disk!20%!10%!/
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}

define service {
      host_name                       $devicename
      service_description             Check SSH
      check_command                   check_ssh
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
}

define service {
      host_name                       $devicename
      service_description             Total Process
      check_command                   check_local_procs!250!400!RSZDT
      max_check_attempts              2
      check_interval                  2
      retry_interval                  2
      check_period                    24x7
      check_freshness                 1
      contact_groups                  admins
      notification_interval           2
      notification_period             24x7
      notifications_enabled           1
      register                        1
} “ >> /etc/nagios/"${devicename}".cfg

#copy config file to server
sudo scp azureuser@$IP:/etc/nagios/$devicename.cfg azureuser@10.0.0.4:/usr/local/nagios/etc/servers/$devicename.cfg 


#restart service
sudo service nagios-nrpe-server restart
