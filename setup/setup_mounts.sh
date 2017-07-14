#! /bin/bash
#Preinstall priming script for AWS installs.

#This script assumes you are logged into an Amazon AWS instance with at least one ephemeral volume present (in this case '/dev/xvdb')
#For example, this will work with instance types: m3.xlarge
#You may need to customize this code for your specific instance type

#Unmount the current /mnt mount point that is attached to /dev/xvdb by default
#sudo umount /mnt

#Mount ephemeral storage
#sudo mkfs /dev/xvdb #Don't do this if starting with an existing snapshot
sudo mount /dev/xvdb /workspace

#Make ephemeral storage mounts persistent
#See http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html for guidance on setting up fstab records for AWS
echo -e "LABEL=cloudimg-rootfs / ext4 defaults,discard 0 0\n/dev/xvdb /workspace ext4 defaults,nofail 0 2" | sudo tee /etc/fstab

#change permissions on required drives
sudo chown -R ubuntu:ubuntu /workspace

