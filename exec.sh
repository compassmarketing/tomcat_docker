#!/bin/bash

source /usr/local/include/shell-tools.shh

start_tomcat() {
	MSG	'Starting Tomcat'
	MSG	'Starting all SIA nodes'
	# !!! something probably double-forks and detaches the entire process tree
	# ccm.sh loads its own environment
	su -c "${COMPASS_SAP_INSTALL_DIR}/sap_bobj/tomcatstartup.sh" ${COMPASS_SAP_USER}
	waitonport 8080
}

stop_tomcat() {
	MSG	'Stopping Tomcat'
	# ccm.sh loads its own environment
	su -c "${COMPASS_SAP_INSTALL_DIR}/sap_bobj/tomcatshutdown.sh" ${COMPASS_SAP_USER}
	waitonstopfull '/opt/sap/sap_bobj/tomcat/bin/tomcat-juli\.jar'
}

container_term_int() {
	stop_tomcat

#	MSG	'Stopping crond ...'
#	if [[ -f /var/run/crond.pid ]]
#	then {
#		kill $(< /var/run/crond.pid)
#		waitonstop 'crond'
#		MSG_end ' Done'
#	}
#	else {
#		MSG_end ' Fail with warning'
#		WARN "/var/run/crond.pid does not exist"
#	}
#	fi

	MSG	'TERM everything that remains!'
	kill -TERM -1

	MSG	'Waiting for 5 seconds'
	sleep_listening 5

	MSG	'KILL everything that remains!'
	kill -KILL -1

	exit 0
}

container_ips_restart() {
	stop_tomcat

	start_tomcat
}

#MSG	'Starting crond'
## !!! crond double-forks
#crond

start_tomcat

MSG	'Register signal handlers'
trap container_term_int TERM INT
trap container_ips_restart USR1

MSG	'Enter wait loop'
while true
do {
	sleep_listening
}
done
