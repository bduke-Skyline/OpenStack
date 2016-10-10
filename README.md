# OpenStack-mitaka (All-in-one node using single NIC) for Ubuntu 14.04LTS
Bash script to install openstack-Mitaka in ubuntu 14.04LTS

>Download the script using the below command:
>>sudo -i

>>git clone https://github.com/bduke-Skyline/OpenStack.git

>>cd OpenStack/

>Script Usage: bash install.bash --ip_address [Your server Ip] --interface_name [interface name]

>Example: bash install.bash --ip_address 10.0.0.3 --interface_name eth0

IMPORTANT:
  - Use this script in the fresh ubuntu 14.04LTS machine.
  - create a seperate 3GB HDD to be used by Cinder-Block Level Storage
  - create 3 seperate 512MB HDD to be used by Swift-Object Level Storage
  - Must have static IP configured.
  - This script use same NIC/IP for Management/External/VM Data networks.
  - Make sure that the IP you have given must have internet connectivity.
  - The interface name must be the NIC name of above mentioned IP.


