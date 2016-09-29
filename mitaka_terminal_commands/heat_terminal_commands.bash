#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#
#Heat Controller comments
source admin-openrc
openstack user create --domain default --password HEAT_PASS heat
openstack role add --project service --user heat admin

openstack service create --name heat --description "OpenStack Orchestration service" orchestration
openstack endpoint create --region RegionOne orchestration public http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration internal http://controller:8004/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne orchestration admin http://controller:8004/v1/%\(tenant_id\)s

openstack service create --name heat-fn --description "OpenStack Orchestration service" cloudformation
openstack endpoint create --region RegionOne cloudformation public http://controller:8000/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne cloudformation internal http://controller:8000/v1/%\(tenant_id\)s
openstack endpoint create --region RegionOne cloudformation admin http://controller:8000/v1/%\(tenant_id\)s

openstack domain create --description "Stack projects and users" heat
openstack user create --domain heat --password HEAT_DOMAIN_PASS heat_domain_admin
openstack role add --domain heat --user-domain heat --user heat_domain_admin admin

openstack role create heat_stack_owner
openstack role add --project demo --user demo heat_stack_owner
openstack role create heat_stack_user

