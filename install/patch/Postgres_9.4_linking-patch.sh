#!/bin/bash

# Postgres 9.4 linking path patch
sed -i \
	-e 's|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=/usr/pgsql-9.4/lib:|' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/dsodbcdb_env.sh
