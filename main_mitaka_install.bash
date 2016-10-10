#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#


#
#Install the all openstack packages at once!
#Install the MariaDB and create the appropriate Databases;
#

bash dbinstall.bash
bash mitaka_package_install.bash


#
#Backup the default files that comes with package installation.
#

#backup default memcached files
cp /etc/memcached.conf /etc/memcached.conf-bkp

#backup default keystone files
cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf-bkp
cp /etc/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini-bkp 

#backup default apache files
cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf-bkp
#cp /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf-bkp

#backup default glance files
cp /etc/glance/glance-api.conf /etc/glance/glance-api.conf-bkp 
cp /etc/glance/glance-registry.conf /etc/glance/glance-registry.conf-bkp

#backup default nova files
cp /etc/nova/nova.conf /etc/nova/nova.conf-bkp
cp /etc/nova/nova-compute.conf /etc/nova/nova-compute.conf-bkp

#backup default neutron files
cp /etc/neutron/neutron.conf /etc/neutron/neutron.conf-bkp
cp /etc/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini-bkp
cp /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.ini-bkp
cp /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini-bkp
cp /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini-bkp
cp /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini-bkp

#backup default cinder files
cp /etc/cinder/cinder.conf /etc/cinder/cinder.conf-bkp

#backup default horizon files 
cp /etc/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py-bkp

#backup default heat files
cp /etc/heat/heat.conf /etc/heat.conf-bkp

#backup default rsync files
cp /etc/rsyncd.conf /etc/rsyncd.conf-bkp

#backup default swift files
#No swift config files are installed during installation
#
#Copy the pre-configured openstack configuration file 
#into the appropriate directories 
#

#Copy pre-configured mysql-openstack files
cp ./mitaka_configuration/mysql/conf.d/openstack.cnf /etc/mysql/conf.d/openstack.cnf
service mysql restart

#copy memcache files
cp ./mitaka_configuration/memcached.conf /etc/memcached.conf
service memcached restart

#copy pre-configured keystone files
cp ./mitaka_configuration/keystone/keystone.conf /etc/keystone/keystone.conf
#cp ./mitaka_configuration/keystone/keystone-paste.ini /etc/keystone/keystone-paste.ini
#service keystone stop 

#copy pre-configured apache files
cp ./mitaka_configuration/apache2/apache2.conf /etc/apache2/apache2.conf
cp ./mitaka_configuration/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf
#ln -s /etc/apache2/sites-available/wsgi-keystone.conf /etc/apache2/sites-enabled
#service apache2 restart 

#copy pre-configured glance files
cp ./mitaka_configuration/glance/glance-api.conf /etc/glance/glance-api.conf
cp ./mitaka_configuration/glance/glance-registry.conf /etc/glance/glance-registry.conf

#copy pre-configured nova files
cp ./mitaka_configuration/nova/nova.conf /etc/nova/nova.conf
cp ./mitaka_configuration/nova/nova-compute.conf /etc/nova/nova-compute.conf

#copy pre-configured neutron files
cp ./mitaka_configuration/neutron/neutron.conf /etc/neutron/neutron.conf
cp ./mitaka_configuration/neutron/metadata_agent.ini /etc/neutron/metadata_agent.ini
cp ./mitaka_configuration/neutron/l3_agent.ini /etc/neutron/l3_agent.ini
cp ./mitaka_configuration/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.ini
cp ./mitaka_configuration/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.ini
cp ./mitaka_configuration/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.ini

#copy pre-configured cinder files
cp ./mitaka_configuration/cinder/cinder.conf /etc/cinder/cinder.conf

#copy pre-configured horizon files 
cp ./mitaka_configuration/openstack-dashboard/local_settings.py /etc/openstack-dashboard/local_settings.py
cp ./mitaka_configuration/logo-splash.png /usr/share/openstack-dashboard/openstack_dashboard/static/dashboard/img/logo-splash.png
service apache2 restart 

#copy pre-configured heat files
cp ./mitaka_configuration/heat/heat.conf /etc/heat/heat.conf

#copy pre-configured swift controller files
mkdir /etc/swift/
cp ./mitaka_configuration/swift/proxy-server.conf /etc/swift/proxy-server.conf

#copy pre-configured swift storage files
cp ./mitaka_configuration/swift/rsyncd.conf /etc/rsyncd.conf
cp ./mitaka_configuration/swift/account-server.conf /etc/swift/account-server.conf
cp ./mitaka_configuration/swift/container-server.conf /etc/swift/container-server.conf
cp ./mitaka_configuration/swift/object-server.conf /etc/swift/object-server.conf

#
#Run the terminal commands 
#sourcing environment is important but not before keystone
#

#run basic environment setup commands
bash mitaka_terminal_commands/basic_terminal_commands.bash

#run keystone environment set commands
bash mitaka_terminal_commands/keystone_terminal_commands.bash

source admin-openrc

#run glance environment set commands
bash mitaka_terminal_commands/glance_terminal_commands.bash

#run nova environment set commands
bash mitaka_terminal_commands/nova_terminal_commands.bash

#run neutron environment set commands
bash mitaka_terminal_commands/neutron_terminal_commands.bash

#run cinder environment set commands
bash mitaka_terminal_commands/cinder_terminal_commands.bash

#run heat environment set commands
bash mitaka_terminal_commands/heat_terminal_commands.bash

#run swift environment set commands
bash mitaka_terminal_commands/swift_terminal_commands.bash
#
#Restore git clone default IP file in case of re-running
#
mv mitaka_configuration mitaka_configuration_executed
cp -r mitaka_configuration_bkp mitaka_configuration


#Branding Skyline
#echo "Installation successful :-)"












