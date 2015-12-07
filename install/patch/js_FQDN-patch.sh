#!/bin/bash

# Patch for using FQDNs for job servers in repo databases

sed -i \
	-e '/UseDomainName=FALSE/s|FALSE|TRUE\nUnixDomainName=compass\n|' \
	${COMPASS_SAP_INSTALL_DIR}/dataservices/conf/DSConfig.txt
