#!/bin/bash

# MySQL specific patch (DS 4.2 SP3 change) p.59 DS Admin Guide
sed -i \
	-e '/^export ODBCINST/a\\nODBCSYSINI=$LINK_DIR/bin\nexport ODBCSYSINI' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/dsodbcdb_env.sh

ln -s ds_odbcinst.ini ${COMPASS_SAP_INSTALL_DIR}/dataservices/bin/odbcinst.ini
