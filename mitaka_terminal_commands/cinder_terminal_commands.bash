#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#
#Setup LVM drive to be used by Cinder
pvcreate /dev/vdb
vgcreate cinder-volumes /dev/vdb

#Cinder Controller comments
source admin-openrc
openstack user create --domain default --password CINDER_PASS cinder
openstack role add --project service --user cinder admin

openstack service create --name cinder --description "OpenStack Block Storage service" volume
openstack endpoint create --region RegionOne volume public http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume internal http://controller:8776/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne volume admin http://controller:8776/v1/%\(tenant_id\)s

openstack service create --name cinderv2 --description "OpenStack Block Storage service" volumev2
openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(tenant_id\)s
openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(tenant_id\)s


su -s /bin/sh -c "cinder-manage db sync" cinder
service cinder-scheduler restart
service cinder-api restart
rm -f /var/lib/cinder/cinder.sqlite

#verify
source admin-openrc
openstack volume list


