#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#
#Setup Keystone to be used for Swift Controller
source admin-openrc
openstack user create --domain default --password SWIFT_PASS swift
openstack role add --project service --user swift admin

openstack service create --name swift --description "OpenStack Object Storage service" object-store
openstack endpoint create --region RegionOne object-store public http://controller:8080/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne object-store internal http://controller:8080/v1/AUTH_%\(tenant_id\)s
openstack endpoint create --region RegionOne object-store admin http://controller:8080/v1

#End of Setup for Swift Controller

#Setup Partitions to be used by Swift Storage Node
mkfs.xfs /dev/vdc
mkfs.xfs /dev/vdd
mkfs.xfs /dev/vde

mkdir -p /srv/node/vdc
mkdir -p /srv/node/vdd
mkdir -p /srv/node/vde

#sed /etc/fstab file
sed -i "$ a /dev/vdc /srv/node/vdc xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" /etc/fstab
sed -i "$ a /dev/vdd /srv/node/vdd xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" /etc/fstab
sed -i "$ a /dev/vde /srv/node/vde xfs noatime,nodiratime,nobarrier,logbufs=8 0 2" /etc/fstab

#mount the storage devices
mount /srv/node/vdc
mount /srv/node/vdd
mount /srv/node/vde

#sed /etc/default/rsync
sed -i "s/RSYNC_ENABLE=false/RSYNC_ENABLE=true/" /etc/default/rsync

#Restart rsync used by Swift Storage Node
service rsync restart

#Ownership
chown -R swift:swift /srv/node

#Create recon directory
mkdir -p /var/cache/swift
chown -R root:swift /var/cache/swift
chmod -R 775 /var/cache/swift
#End of Swift Storage Node setup

#Swift Rings
#Swift Account Ring Setup
swift-ring-builder account.builder create 10 3 1
swift-ring-builder account.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6002 --device vdc --weight 100
swift-ring-builder account.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6002 --device vdd --weight 100
swift-ring-builder account.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6002 --device vde --weight 100
swift-ring-builder account.builder
swift-ring-builder account.builder rebalance
swift-ring-builder account.builder

#Swift Container Ring setup
swift-ring-builder container.builder create 10 3 1
swift-ring-builder container.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6001 --device vdc --weight 100
swift-ring-builder container.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6001 --device vdd --weight 100
swift-ring-builder container.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6001 --device vde --weight 100
swift-ring-builder container.builder
swift-ring-builder container.builder rebalance
swift-ring-builder container.builder

#Swift Object Ring setup
swift-ring-builder object.builder create 10 3 1
swift-ring-builder object.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6000 --device vdc --weight 100
swift-ring-builder object.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6000 --device vdd --weight 100
swift-ring-builder object.builder add --region 1 --zone 1 --ip 10.0.0.3 --port 6000 --device vde --weight 100
swift-ring-builder object.builder
swift-ring-builder object.builder rebalance
swift-ring-builder object.builder

#Change Ownership
chown -R root:swift /etc/swift

#restart Swift services
service memcached restart
service swift-proxy restart
swift-init all start
