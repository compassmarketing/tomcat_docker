#!/bin/bash

cat <<- _EOF_ >> ${COMPASS_SAP_INSTALL_DIR}/sap_bobj/setup/dataservices/env.sh

	DS_COMMON_DIR=\$LINK_DIR
	export DS_COMMON_DIR
_EOF_
