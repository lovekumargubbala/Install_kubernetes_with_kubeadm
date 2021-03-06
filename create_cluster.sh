#!/bin/bash

echo -e "\nChecking docker and ansible installations \n"

##############function to install Ansible######################
ansible_install(){
ansible --version >> /dev/null
if [ $? != 0 ];
then
yum install ansible -y
else 
echo -e "============Good Ansible is already installed===================\n"
fi
}

#####################Function to install Docker########################
docker_install(){
docker --version >> /dev/null
if [ $? != 0 ];
then
yum install docker -y
service docker enable
service docker start
else
echo -e "====================Docker already Installed====================\n"
fi
}
ansible_install
docker_install


echo "+------------------------------------------+"
printf "| Creating Kube cluster with Kubeadm in AWS |\n" "`date`"
echo "|                                          |"
printf "| Press any key to proceed Further |\n" "$@"
echo "+------------------------------------------+"
read anykey

############ Getting  vars from the Vars ##############

echo "Enter your VPC ID =>"
read vpc
echo "Enter your Region =>"
read region_name
echo "Name of your private key without .pem => "
read private_key_name
echo " Enter your subnet ID =>"
read subnet
echo "Enter your Image ID =>"
read image

echo -e "Creating cluster with following details \n-\e[32m$vpc \n-\e[32m$region_name \n-\e[32m$private_key_name \n-\e[32m$subnet \n-\e[32mimage \n"


############## Running ansible command to create the cluster ##################

ansible-playbook  --private-key devops.pem -e vpc_id=$vpc  -e region=$region_name -e private_key=$private_key_name -e subnet_id=$subnet -e image=$image  kubernetes.yml
