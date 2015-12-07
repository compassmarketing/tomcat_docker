#!/bin/bash

source ${COMPASS_SOURCES_DIR}/include/shell-tools.shh

MSG	'Cleaning up'
yum clean all
rm -rf \
	/tmp/* \
	/var/tmp/*

MSG	'Installation complete'
