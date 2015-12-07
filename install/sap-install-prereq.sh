#!/bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG_begin	'Create SAP User, setup shell, home and install directories ...'
useradd \
	--comment "SAP User" \
	--create-home \
	--home-dir ${COMPASS_SAP_HOME_DIR} \
	--system \
	--user-group \
	--shell /bin/bash \
	${COMPASS_SAP_USER}
MSG_end	' Done'

MSG_begin	'Create production group for storage mounts ...'
groupadd --gid 10000 production
usermod --append --groups production ${COMPASS_SAP_USER}
MSG_end	' Done'

MSG_begin	'Modify release string ...'
rm /etc/redhat-release
echo 'Red Hat Enterprise Linux Server release 6.6 (Centos)' > /etc/redhat-release
MSG_end	' Done'

MSG_begin	'Increase the max user processes limit ...'
sed -i -e '/^[*]/s/[0-9]*$/65536/' /etc/security/limits.d/90-nproc.conf
MSG_end	' Done'

MSG	'Install Repos'
cp "${COMPASS_SOURCES_DIR}/rpm/MariaDB.repo" /etc/yum.repos.d/
yum install -y \
	${COMPASS_SOURCES_DIR}/rpm/epel-release-*.noarch.rpm \
	${COMPASS_SOURCES_DIR}/rpm/rpmforge-release-*.el6.rf.x86_64.rpm \
	${COMPASS_SOURCES_DIR}/rpm/pgdg-centos*.noarch.rpm

	### MySQL Community repo
# yum install -y ${COMPASS_SOURCES_DIR}/rpm/mysql-community-release-el6-5.noarch.rpm

# head -22 /etc/yum.repos.d/mysql-community.repo > /etc/yum.repos.d/mysql-community.repo.new
# sed -ie 's/^enabled=0/enabled=1/' /etc/yum.repos.d/mysql-community.repo.new
# mv /etc/yum.repos.d/mysql-community.repo.new /etc/yum.repos.d/mysql-community.repo

# head -20 /etc/yum.repos.d/mysql-community-source.repo > /etc/yum.repos.d/mysql-community-source.repo.new
# sed -ie 's/^enabled=0/enabled=1/' /etc/yum.repos.d/mysql-community-source.repo.new
# mv /etc/yum.repos.d/mysql-community-source.repo.new /etc/yum.repos.d/mysql-community-source.repo

MSG	'Install MariaDB client, MySQL ODBC, PostgreSQL and PostgreSQL ODBC,'
MSG	'crontab,'
MSG	'Subversion,'
MSG	'installer requirements,'
MSG	'and sysadmin tools.'

yum install -y \
	MariaDB-client 'mysql-connector-odbc-5.1.*' postgresql94 postgresql94-odbc \
	cronie \
	subversion \
	glibc.i686 libstdc++.i686 compat-libstdc++-33.i686 compat-libstdc++-33 libXext.i686 libXext libXext-devel.i686 libXext-devel ksh \
	htop iotop mc

MSG_begin	'Create .so symlinks for MySQL/MariaDB client library ...'
if [[ -f /usr/lib64/libmysqlclient.so.16 ]]; then
	if [[ ! -f /usr/lib64/libmysqlclient.so ]]; then
		cd /usr/lib64 && { \
			ln -s libmysqlclient.so.16 libmysqlclient.so; \
			ln -s libmysqlclient_r.so.16 libmysqlclient_r.so; \
		}
		MSG_end ' Done'
	fi
elif [[ -f /usr/lib64/mysql/libmysqlclient.so.16 ]]; then
	if [[ ! -f /usr/lib64/mysql/libmysqlclient.so ]]; then
		cd /usr/lib64/mysql && { \
			ln -s libmysqlclient.so.16 libmysqlclient.so; \
			ln -s libmysqlclient_r.so.16 libmysqlclient_r.so; \
		}
		MSG_end ' Done'
	fi
else
	MSG_end ' Fail'
	FATAL 'Cannot find libmysqlclient.so.16.  Exiting.'
fi
