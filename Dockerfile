FROM centos:6

# Parameter substitution does not work within the same ENV call
# CentOS wrappers clear /tmp and /var/tmp
ENV	COMPASS_SOURCES_DIR="/tmp/sap_sources" \
	COMPASS_SAP_USER="sap" \
	COMPASS_SAP_HOME_DIR="/opt/sap" \
	COMPASS_SAP_INSTALL_DIR="/opt/sap" \
	COMPASS_SAP_DOMAIN="compass"

COPY	install	${COMPASS_SOURCES_DIR}
RUN	${COMPASS_SOURCES_DIR}/centos-begin.sh \
	&& ${COMPASS_SOURCES_DIR}/sap-install-prereq.sh \
	&& ${COMPASS_SOURCES_DIR}/sap-install-Tomcat.sh \
	&& ${COMPASS_SOURCES_DIR}/centos-end.sh

COPY	exec.sh	/etc/init.d/

#USER	${COMPASS_SAP_USER}
WORKDIR	${COMPASS_SAP_HOME_DIR}
ENTRYPOINT	["/etc/init.d/exec.sh"]
