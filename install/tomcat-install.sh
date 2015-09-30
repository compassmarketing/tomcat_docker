#! /bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Add tools'
apt-get install -y mc htop

MSG	'Copying configuration file'
cp ${COMPASS_SOURCES_DIR}/tomcat-users.xml /usr/local/tomcat/conf/
