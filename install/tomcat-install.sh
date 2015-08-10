#! /bin/bash

MSG() {
        echo "=== $1"
}

ERROR() {
        echo "--- $1"
        exit 1
}

MSG	'Add tools'
apt-get install -y nano

MSG	'Copying configuration file'
cp ${COMPASS_SOURCES_DIR}/tomcat-users.xml /usr/local/tomcat/conf/
