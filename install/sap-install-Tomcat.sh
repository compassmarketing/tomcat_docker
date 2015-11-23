#!/bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

COMPASS_SAP_IPS_SOURCE='http://boian.compass/IPS-lnx64-4.1SP5-install.tar.xz'
COMPASS_SAP_IPS_SP_SOURCE=''
#COMPASS_SAP_IPS_SP_SOURCE='http://boian.compass/IPS4106_0-20010908.TGZ'
#COMPASS_SAP_IPS_PATCH_SOURCE=''
COMPASS_SAP_IPS_PATCH_SOURCE='http://boian.compass/IPS4105P_9-20010908.TGZ'
#COMPASS_SAP_IPS_PATCH_SOURCE='http://boian.compass/IPS4106P_3-20010908.TGZ'

COMPASS_SAP_IPS_AUTOINSTALL='ips-auto-WEB.ini'
COMPASS_SAP_IPS_SP_AUTOINSTALL='ips-auto-patch.ini'
COMPASS_SAP_IPS_PATCH_AUTOINSTALL='ips-auto-patch.ini'

COMPASS_SAP_DS_SOURCE='http://boian.compass/DS4205P_2-20010964.TGZ'
COMPASS_SAP_DS_SP_SOURCE=''
COMPASS_SAP_DS_PATCH_SOURCE=''

COMPASS_SAP_DS_AUTOINSTALL='ds-auto-WEB.ini'
COMPASS_SAP_DS_SP_AUTOINSTALL=''
COMPASS_SAP_DS_PATCH_AUTOINSTALL=''

COMPASS_ORIGIN_CMS='boian.compass'

MSG	'Install tools to download and uncompress SAP installation files and nc'

yum install -y \
	wget tar xz \
	nc

MSG_begin	'Download SAP install files ...'

cd ${COMPASS_SOURCES_DIR}

wget -q "${COMPASS_SAP_IPS_SOURCE}"
MSG_cont	' IPS ...'

if [[ -n "${COMPASS_SAP_IPS_SP_SOURCE}" ]]
then {
	wget -q "${COMPASS_SAP_IPS_SP_SOURCE}"
	MSG_cont	' IPS Service Pack ...'
}
fi

if [[ -n "${COMPASS_SAP_IPS_PATCH_SOURCE}" ]]
then {
	wget -q "${COMPASS_SAP_IPS_PATCH_SOURCE}"
	MSG_cont	' IPS Patch ...'
}
fi

wget -q "${COMPASS_SAP_DS_SOURCE}"
MSG_cont	' DS ...'

if [[ -n "${COMPASS_SAP_DS_SP_SOURCE}" ]]
then {
	wget -q "${COMPASS_SAP_DS_SP_SOURCE}"
	MSG_cont	' DS Service Pack ...'
}
fi

if [[ -n "${COMPASS_SAP_DS_PATHC_SOURCE}" ]]
then {
	wget -q "${COMPASS_SAP_DS_PATCH_SOURCE}"
	MSG_cont	' DS Service Pack ...'
}
fi

MSG_end	' Done'

MSG_begin	'Uncompress SAP install files ...'

mkdir -p ${COMPASS_SOURCES_DIR}/ips
tar -xf $(basename ${COMPASS_SAP_IPS_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ips
MSG_cont	' IPS ...'

if [[ -n ${COMPASS_SAP_IPS_SP_SOURCE} ]]
then {
	mkdir -p ${COMPASS_SOURCES_DIR}/ips-sp
	tar -xf $(basename ${COMPASS_SAP_IPS_SP_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ips-sp
	MSG_cont	' IPS Service Pack ...'
}
fi

if [[ -n ${COMPASS_SAP_IPS_PATCH_SOURCE} ]]
then {
	mkdir -p ${COMPASS_SOURCES_DIR}/ips-patch
	tar -xf $(basename ${COMPASS_SAP_IPS_PATCH_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ips-patch
	MSG_cont	' IPS Patch ...'
}
fi

mkdir -p ${COMPASS_SOURCES_DIR}/ds
tar -xf $(basename ${COMPASS_SAP_DS_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ds
MSG_cont	' DS ...'

if [[ -n ${COMPASS_SAP_DS_SP_SOURCE} ]]
then {
	mkdir -p ${COMPASS_SOURCES_DIR}/ds-sp
	tar -xf $(basename ${COMPASS_SAP_DS_SP_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ds-sp
	MSG_cont	' DS Service Pack ...'
}
fi

if [[ -n ${COMPASS_SAP_DS_PATCH_SOURCE} ]]
then {
	mkdir -p ${COMPASS_SOURCES_DIR}/ds-patch
	tar -xf $(basename ${COMPASS_SAP_DS_PATCH_SOURCE}) -C ${COMPASS_SOURCES_DIR}/ds-patch
	MSG_cont	' DS Patch ...'
}
fi

MSG_end	' Done'

MSG_begin	'Prepare installation location ...'
mkdir -p ${COMPASS_SAP_INSTALL_DIR}
chown ${COMPASS_SAP_USER}:${COMPASS_SAP_USER} ${COMPASS_SAP_INSTALL_DIR}
cd $COMPASS_SAP_INSTALL_DIR
MSG_end	' Done'

MSG	'Install WEB from IPS'
# patch autoinstall file !!!FIX ME FOR SPACE
sed -i \
	-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
	-e "s|^existingcmsdbdatabase=.*|existingcmsdbdatabase=sap_CMSDB|" \
	-e "s|^existingcmsdbserver=.*|existingcmsdbserver=${COMPASS_ORIGIN_CMS}|" \
	-e "s|^existingcmsdbport=.*|existingcmsdbport=3306|" \
	-e "s|^existingcmsdbuser=.*|existingcmsdbuser=sapcms|" \
	-e "s|^existingcmsdbpassword=.*|existingcmsdbpassword=sapcms|" \
	-e "s|^existingcmsdbreset=0|existingcmsdbreset=1|" \
	"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_AUTOINSTALL}"

su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ips/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_AUTOINSTALL}" ${COMPASS_SAP_USER}

if [[ -n ${COMPASS_SAP_IPS_SP_SOURCE} ]]
then {
	MSG	'Applying IPS Service Pack'
	# patch autoinstall file !!!FIX ME FOR SPACE
	sed -i \
		-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
		-e "s|^remotecmsname=.*|remotecmsname=${COMPASS_ORIGIN_CMS}|" \
		"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_SP_AUTOINSTALL}"

	su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ips-sp/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_SP_AUTOINSTALL}" ${COMPASS_SAP_USER}
}
fi

if [[ -n ${COMPASS_SAP_IPS_PATCH_SOURCE} ]]
then {
	MSG	'Applying IPS Patch'
	# patch autoinstall file !!!FIX ME FOR SPACE
	sed -i \
		-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
		-e "s|^remotecmsname=.*|remotecmsname=${COMPASS_ORIGIN_CMS}|" \
		"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_PATCH_AUTOINSTALL}"

	su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ips-patch/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_IPS_PATCH_AUTOINSTALL}" ${COMPASS_SAP_USER}
}
fi

MSG	'Install WEB from DS'
# patch autoinstall file
sed -i \
	-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
	-e "s|^dscmssystem=.*|dscmssystem=${COMPASS_ORIGIN_CMS}|" \
	"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_AUTOINSTALL}"

su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ds/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_AUTOINSTALL}" ${COMPASS_SAP_USER}

if [[ -n ${COMPASS_SAP_DS_SP_SOURCE} ]]
then {
	MSG	'Applying DS Service Pack'
	sed -i \
		-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
		-e "s|^dscmssystem=.*|dscmssystem=${COMPASS_ORIGIN_CMS}|" \
		"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_SP_AUTOINSTALL}"

	su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ds-sp/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_SP_AUTOINSTALL}" ${COMPASS_SAP_USER}
}
fi

if [[ -n ${COMPASS_SAP_DS_PATCH_SOURCE} ]]
then {
	MSG	'Applying DS Patch'
	sed -i \
		-e "s|^installdir=.*|installdir=${COMPASS_SAP_INSTALL_DIR}|" \
		-e "s|^dscmssystem=.*|dscmssystem=${COMPASS_ORIGIN_CMS}|" \
		"${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_PATCH_AUTOINSTALL}"

	su -c "export LANG='en_US.UTF-8'; ${COMPASS_SOURCES_DIR}/ds-patch/setup.sh -r ${COMPASS_SOURCES_DIR}/${COMPASS_SAP_DS_PATCH_AUTOINSTALL}" ${COMPASS_SAP_USER}
}
fi

MSG_begin	'Copy JDBC drivers ... '
# JDBC for Data Services binaries
cp "${COMPASS_SOURCES_DIR}"/jar/mysql-connector-java-* "$COMPASS_SAP_INSTALL_DIR"/sap_bobj/enterprise_xi40/java/lib/im/mysql/
chmod 555 "$COMPASS_SAP_INSTALL_DIR"/sap_bobj/enterprise_xi40/java/lib/im/mysql/mysql-connector-java-*
# JDBC for all Tomcat applications
cp "${COMPASS_SOURCES_DIR}"/jar/mysql-connector-java-* "$COMPASS_SAP_INSTALL_DIR"/sap_bobj/tomcat/lib/
chmod 555 "$COMPASS_SAP_INSTALL_DIR"/sap_bobj/tomcat/lib/mysql-connector-java-*
MSG_end	' Done'

MSG_begin	'Installing Compass Tools ...'

chmod 644 ${COMPASS_SOURCES_DIR}/include/*
cp ${COMPASS_SOURCES_DIR}/include/* /usr/local/include/

MSG_end	' Done'

MSG_begin	'Applying patches '
# Apply linking patched in reverse order or preference
su -c "${COMPASS_SOURCES_DIR}/patch/MySQL_5.1_CentOS_repo_linking-patch.sh" ${COMPASS_SAP_USER}
MSG_cont	'.'

su -c "${COMPASS_SOURCES_DIR}/patch/DS_SP3_MySQL_specific-patch.sh" ${COMPASS_SAP_USER}
MSG_cont	'.'
su -c "${COMPASS_SOURCES_DIR}/patch/MySQL_5.5_ODBC_registration-patch.sh" ${COMPASS_SAP_USER}
MSG_cont	'.'
su -c "${COMPASS_SOURCES_DIR}/patch/ips_scheduling-patch.sh" ${COMPASS_SAP_USER}
MSG_end	'. Done'

MSG	'Remove tools to download and uncompress SAP installation files,'
MSG	'and MariaDB server'
yum remove -y \
	wget tar xz \

MSG	'SAP cleanup'
rm -rf \
	/opt/sap/*.sh \
	/opt/sap/setup* \
	/opt/sap/InstallData
