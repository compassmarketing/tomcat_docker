#!/bin/bash

# MySQL 5.1 from CentOS official repo linking path patch
sed -i \
	-e 's|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=/usr/lib64:|' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/dsodbcdb_env.sh
