#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#
#Setup Partitions to be used by Swift Storage Node
mkfs.xfs /dev/vdc
mkfs.xfs /dev/vdd

mkdir -p /srv/node/vdc
mkdir -p /srv/node/vdd

#Swift Controller comments
source admin-openrc
openstack user create --domain default --password SWIFT_PASS swift
openstack role add --project service --user swift admin

openstack service create --name swift --description "OpenStack Object Storage service" object-store
openstack endpoint create --region RegionOne object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne object-store admin http://controller:8080/v1

