#!/usr/bin/env bash
# ------------------------------------------------------------------------
# Simple bash script used to bootstrap ansible
#
# The following distros are supported: 
#   - Fedora 20 and greater
#   - CentOS 7
#   - Ubuntu 16.04, 17.10, 18.04
#
# Brent WG
# 2018-02-27
# 2018-03-27
# ------------------------------------------------------------------------

# ----------------
# Script Functions
# ----------------
error_exit() {
  echo ""
  echo "$ID_LIKE is not supported by this script"
  echo
  exit 1
}

# --------------------------------------------
# Check to see if Ansible is already installed
# --------------------------------------------
echo ""
echo "Checking to see if Ansible is already installed"
if hash ansible 2>/dev/null ; then
  echo ""
  echo "Ansible is already installed"
  echo ""
  exit 2
fi

# ----------
# Get Distro
# ----------
echo ""
echo "Getting OS version..."
. /etc/os-release

# ---------------
# Install Ansible
# ---------------
echo ""
echo "Installing Ansible for: $ID_LIKE..."
## Deal with Fedora (version 20 and greater)
if [ "$ID_LIKE" == "fedora" ]; then
  ## Use dnf > 21
  if [ $VERSION_ID -gt 21 ]; then
    echo "Using: sudo dnf install -y ansible"
    sudo dnf update
    sudo dnf install -y python3
    sudo dnf install -y python3-pip
    sudo dnf install -y ansible
    ansible-galaxy collection install amazon.aws
    pip install boto boto3
    
  ## Use yum for 20 - 21
  elif [ $VERSION_ID -eq 20 ] || [ $VERSION_ID -eq 21 ]; then
    echo "Using: sudo yum -y install ansible"
    sudo yum update
    sudo yum -y install python3
    sudo yum -y install ansible
    sudo yum install -y python3-pip
    ansible-galaxy collection install amazon.aws
    pip install boto boto3
  else
    error_exit 
  fi
fi

## Deal with CentOS 7
if [ "$ID_LIKE" == "centos" ]; then
    echo "Installing EPEL and Ansible"
    sudo yum update
    sudo yum install -y epel-release
    sudo yum install -y ansible
    sudo yum -y install python3
    sudo yum install -y python3-pip
    ansible-galaxy collection install amazon.aws
    pip install boto boto3
  else
    error_exit
fi

## Deal with Ubuntu
if [ "$ID_LIKE" == "ubuntu" ]; then
   sudo apt update
   sudo apt install software-properties-common
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible	
fi


