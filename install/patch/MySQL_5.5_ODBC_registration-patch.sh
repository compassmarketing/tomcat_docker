#!/bin/bash

# ODBC driver registration
cat <<- _EOF_ >> ${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/ds_odbcinst.ini

	[MySQL 5.5]
	driver=/usr/lib64/libmyodbc5.so
	unixODBC=/usr/lib64/
_EOF_


# Registering driver as if DSConnectionManager.sh was ran
# !!! section must match ds_odbcinst.ini
sed -i \
	-e '/^\[UNIXDBClientDrivers\]/aMYSQL_5_5=MySQL 5.5' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/conf/DSConfig.txt


#MySQL lib locations patch
sed -i \
	-e '/^MYSQL_5_5_DRIVERMANAGER=/s|=.*|=/usr/lib64/libodbc.so.2|' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/dsodbcdb_env.sh
