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
  echo "Installing Apache and mod-wsgi..."
  sudo apt-get -y install apache2 libapache2-mod-wsgi
  echo "Installing Build-Essential..."
  sudo apt-get -y install build-essential
  echo "Installing PCRE-dev..."
  sudo apt-get -y install libpcre3-dev
  echo "Installing Numactl..."
  sudo apt-get -y install numactl
  echo "Installing cURL..."
  sudo apt-get -y install curl
  echo "Installing zip, 7zip, and unrar..."
  sudo apt-get -y install zip p7zip-full unrar
  echo "Installing libpcap-dev..."
  sudo apt-get -y install libpcap-dev
  echo "Installing Python requirements..."
  sudo apt-get -y install python-simplejson python-pycurl python-dev python-pydot python-pyparsing python-yaml python-setuptools python-numpy python-matplotlib python-lxml
  if [ "$VER" == '10.04' ]
  then
    echo "Installing importlib 1.0.2..."
    sudo ${PYBIN} importlib-1.0.2/setup.py install
    echo "Installing ordereddict 1.1..."
    sudo ${PYBIN} ordereddict-1.1/setup.py install
  fi
  echo "Installing python-dateutil 2.2..."
  sudo ${PYBIN} python-dateutil-2.2/setup.py install
  echo "Installing UPX"
  sudo apt-get -y install upx
  echo "Installing M2Crypto"
  sudo apt-get -y install m2crypto
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
  sudo rpm -i p7zip-9.20.1-2.el6.rf.x86_64.rpm
  sudo rpm -i unrar-4.2.3-1.el6.rf.x86_64.rpm
  echo "Installing libpcap-devel..."
  sudo yum install libpcap-devel
  echo "Installing Python requirements..."
  sudo yum install python-pycurl python-dateutil python-devel python-setuptools
  sudo yum install numpy matplotlib
  sudo ${PYBIN} pydot-1.0.28/setup.py install
  sudo ${PYBIN} pyparsing-1.5.6/setup.py install
  sudo rpm -i libyaml-0.1.4-1.el6.rf.x86_64.rpm
  sudo ${PYBIN} PyYAML-3.10/setup.py install
  echo "Installing UPX"
  sudo rpm -i upx-3.07-1.el6.rf.x86_64.rpm
elif [ "$OS" == 'darwin']
  echo "OSX is not supported yet. See https://github.com/crits/crits/blob/master/documentation/crits_on_osx.txt for instructions."
else
  echo "Unknown distro!"
  echo -e "Detected: $OS $VER"
  exit
fi

echo "Installing MongoDB 2.6.4..."
sudo cp mongodb-linux-x86_64-2.6.4/bin/* /usr/local/bin/
echo "Installing PyMongo 2.7.2..."
sudo ${PYBIN} pymongo-2.7.2/setup.py install
echo "Installing DefusedXML 0.4.1..."
sudo ${PYBIN} defusedxml-0.4.1/setup.py install
echo "Installing Django 1.6.5..."
sudo ${PYBIN} Django-1.6.5/setup.py install
echo "Installing Django Tastypie 0.11.0..."
sudo ${PYBIN} django-tastypie-0.11.0/setup.py install
echo "Installing Django Tastypie Mongoengine 0.4.5..."
sudo ${PYBIN} django-tastypie-mongoengine-0.4.5/setup.py install
echo "Installing MongoEngine 0.8.7..."
sudo ${PYBIN} mongoengine-0.8.7/setup.py install
echo "Installing ssdeep..."
sudo ssdeep-2.11/configure && sudo ssdeep-2.11/make && sudo ssdeep-2.11/make install # Not sure about this line
sudo ${PYBIN} pydeep-0.2/setup.py install
if [ -f /usr/local/lib/libfuzzy.so.2.0.0 ];
then
    sudo echo '/usr/local/lib' > /etc/ld.so.conf.d/libfuzzy-x86_64.conf
else
    sudo echo '/usr/lib' > /etc/ld.so.conf.d/libfuzzy-x86_64.conf
fi
echo "Installing Python magic..."
sudo ${PYBIN} python-magic/setup.py install
echo "Installing dependencies for Services Framework..."
sudo ${PYBIN} anyjson-0.3.3/setup.py install
sudo ${PYBIN} amqp-1.0.6/setup.py install
sudo ${PYBIN} billiard-2.7.3.19/setup.py install
sudo ${PYBIN} kombu-2.5.4/setup.py install
sudo ${PYBIN} celery-3.0.12/setup.py install
sudo ${PYBIN} django-celery-3.0.11/setup.py install
sudo ${PYBIN} requests-v1.1.0-9/setup.py install
sudo ${PYBIN} cybox-2.1.0.5/setup.py install
sudo ${PYBIN} stix-1.1.1.0/setup.py install
echo "Dependency installations complete!"
