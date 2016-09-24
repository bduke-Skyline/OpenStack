#!/bin/bash
#
# Unattended/SemiAutomatted OpenStack Installer
# 
# OpenStack MITAKA for Ubuntu 14.04lts
#
#

#Basic environment setting terminal commands
rabbitmqctl add_user openstack RABBIT_PASS
rabbitmqctl set_permissions openstack ".*" ".*" ".*"
