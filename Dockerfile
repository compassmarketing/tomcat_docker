FROM	tomcat:7-jre7

ENV	COMPASS_SOURCES_DIR="/root/install" \
	LINK_DIR="/opt/sap/dataservices" \
	DS_COMMON_DIR="/opt/sap/dataservices" \
	JAVA_OPTS="-Xms128m -Xmx2048m -XX:MaxPermSize=512m"

COPY	install	${COMPASS_SOURCES_DIR}

RUN	${COMPASS_SOURCES_DIR}/ubuntu-begin.sh \
	&& ${COMPASS_SOURCES_DIR}/tomcat-install.sh \
	&& ${COMPASS_SOURCES_DIR}/ubuntu-end.sh
