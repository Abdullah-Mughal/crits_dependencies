#!/bin/bash

# (c) 2013, The MITRE Corporation. All rights reserved.
# Source code distributed pursuant to license agreement.

PYBIN=`which python`

ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
echo -e "Architecture: $ARCH"

if [ $ARCH -ne '64' ]; then
  echo "** Non 64-bit system detected **"
  echo "These dependencies are for a 64-bit system."
  echo "Exiting.."
  exit
fi

# Using lsb-release because os-release not available on Ubuntu 10.04
if [ -f /etc/lsb-release ]; then
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VER=$DISTRIB_RELEASE
elif [ -f /etc/redhat-release ]; then
  OS=$(cat /etc/redhat-release | sed 's/ Enterprise.*//')
  VER=$(cat /etc/redhat-release | sed 's/.*release //;s/ .*$//')
else
  OS=$(uname -s)
  VER=$(uname -r)
fi

OS="$(tr "[:upper:]" "[:lower:]" <<< "$OS")"
VER="$(tr "[:upper:]" "[:lower:]" <<< "$VER")"

if [ "$OS" == 'ubuntu' ]
then
  echo "Installing dependencies with apt-get"
  apt-get install -y apache2 build-essential curl emacs git libapache2-mod-wsgi libevent-dev libfuzzy-dev libldap2-dev libpcap-dev libpcre3-dev libsasl2-dev libxml2-dev libxslt1-dev libyaml-dev m2crypto mongodb numactl p7zip-full python-dev python-lxml python-m2crypto python-matplotlib python-numpy python-pip python-pycurl python-pydot python-pyparsing python-setuptools python-yaml ssdeep upx zip

# TODO: Need to test centos dependencies
# elif [ "$OS" == 'centos' ] || [ "$OS" == 'redhat' ]
elif [ "$OS" == 'red hat' ]
then
  echo "Installing Apache and mod-wsgi..."
  sudo yum install httpd mod_wsgi mod_ssl
  echo "Installing Build-Essential..."
  sudo yum install make gcc gcc-c++ kernel-devel
  echo "Installing PCRE-dev..."
  sudo yum install pcre pcre-devel
  echo "Installing cURL..."
  sudo yum install curl
  echo "Installing zip, 7zip, and unrar..."
  sudo yum install zip unzip gzip bzip2
  sudo rpm -i ./rpms/p7zip-9.20.1-2.el6.rf.x86_64.rpm
  sudo rpm -i ./rpms/unrar-4.2.3-1.el6.rf.x86_64.rpm
  echo "Installing libpcap-devel..."
  sudo yum install libpcap-devel
  echo "Installing Python requirements..."
  sudo yum install python-pycurl python-dateutil python-devel python-setuptools
  sudo yum install numpy matplotlib
  sudo ${PYBIN} pydot-1.0.28/setup.py install
  sudo ${PYBIN} pyparsing-1.5.6/setup.py install
  sudo rpm -i ./rpms/libyaml-0.1.4-1.el6.rf.x86_64.rpm
  sudo ${PYBIN} PyYAML-3.10/setup.py install
  echo "Installing UPX"
  sudo rpm -i ./rpms/upx-3.07-1.el6.rf.x86_64.rpm
elif [ "$OS" == 'darwin']
then
  echo "OSX is not supported yet. See https://github.com/crits/crits/blob/master/documentation/crits_on_osx.txt for instructions."
else
  echo "Unknown distro!"
  echo -e "Detected: $OS $VER"
  exit
fi

echo "Installing MongoDB 2.6.4..."
sudo cp mongodb-linux-x86_64-2.6.4/bin/* /usr/local/bin/

echo "Installing Python Dependencies"
sudo pip install -r requirements.txt

echo "Dependency installations complete!"

echo "Downloading CRITs"
git clone https://github.com/crits/crits.git

echo "Setting Up MongoDB"
sudo mkdir -p /data/db
sudo ./crits/contrib/mongo/NUMA/mongod_start.sh


crits/crits/config/database_example.py crits/crits/config/database.py
crits/crits/config/database_example.py: line 7: MONGO_HOST: command not found
crits/crits/config/database_example.py: line 8: MONGO_PORT: command not found
crits/crits/config/database_example.py: line 9: MONGO_DATABASE: command not found
crits/crits/config/database_example.py: line 13: MONGO_SSL: command not found
crits/crits/config/database_example.py: line 14: MONGO_USER: command not found
crits/crits/config/database_example.py: line 15: MONGO_PASSWORD: command not found
crits/crits/config/database_example.py: line 23: SECRET_KEY: command not found
crits/crits/config/database_example.py: line 26: FILE_DB: command not found
